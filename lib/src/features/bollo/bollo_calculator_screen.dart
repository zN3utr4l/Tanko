import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/enums.dart';
import '../../domain/models/vehicle.dart';
import '../../domain/services/bollo_calculator.dart';
import '../../domain/services/bollo_reminder.dart';
import '../expenses/expense_providers.dart';
import '../reminders/reminder_form_screen.dart';
import '../vehicles/vehicle_providers.dart';

/// "€ 1234,56" — Italian-style, enough for a single amount on this screen.
String _euroStr(double v) => '€ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

/// Offline bollo (car-tax) calculator. Computes the ordinary tax (and the
/// superbollo for >185 kW) from the data on the libretto — power in kW (P.2)
/// and the Euro class (V.9) — using the national tariff. No network, no plate.
/// Optionally pick one of your vehicles to pre-fill kW from its CV, then turn
/// the result into an annual bollo reminder.
class BolloCalculatorScreen extends ConsumerStatefulWidget {
  const BolloCalculatorScreen({super.key});

  @override
  ConsumerState<BolloCalculatorScreen> createState() =>
      _BolloCalculatorScreenState();
}

class _BolloCalculatorScreenState extends ConsumerState<BolloCalculatorScreen> {
  static const _calc = BolloCalculator();

  final _kw = TextEditingController();
  EuroClass _euro = EuroClass.euro6;
  int? _year;
  int? _vehicleId;

  @override
  void dispose() {
    _kw.dispose();
    super.dispose();
  }

  BolloResult? get _result {
    final kw = int.tryParse(_kw.text.trim());
    if (kw == null || kw <= 0) return null;
    final age = _year == null ? null : DateTime.now().year - _year!;
    return _calc.compute(powerKw: kw, euroClass: _euro, vehicleAgeYears: age);
  }

  void _selectVehicle(int? id, List<Vehicle> vehicles) {
    setState(() {
      _vehicleId = id;
      // Pre-fill kW from the vehicle's CV (the libretto has the exact kW; this
      // is a sensible default the user can correct).
      Vehicle? v;
      for (final x in vehicles) {
        if (x.id == id) {
          v = x;
          break;
        }
      }
      final cv = v?.specs.powerPs;
      if (cv != null && cv > 0) _kw.text = cvToKw(cv).toString();
      if (v?.euroClass != null) _euro = v!.euroClass!;
      _year = v?.year;
    });
  }

  void _createReminder(double amount) {
    final cats = ref.read(expenseCategoriesProvider).asData?.value ?? const [];
    int? bolloCategoryId;
    for (final c in cats) {
      if (c.name.toLowerCase() == 'bollo') {
        bolloCategoryId = c.id;
        break;
      }
    }
    final draft = bolloReminderDraft(
      vehicleId: _vehicleId!,
      amount: amount,
      linkedExpenseCategoryId: bolloCategoryId,
      now: DateTime.now(),
    );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ReminderFormScreen(initial: draft)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final thisYear = DateTime.now().year;
    final result = _result;
    final vehicles =
        ref.watch(vehiclesProvider).asData?.value ?? const <Vehicle>[];
    return Scaffold(
      appBar: AppBar(title: const Text('Calcolatore bollo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (vehicles.isNotEmpty) ...[
            DropdownButtonFormField<int?>(
              initialValue: _vehicleId,
              decoration: const InputDecoration(
                labelText: 'Veicolo (opz.)',
                helperText: 'Pre-compila kW, classe Euro e anno',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<int?>(child: Text('—')),
                for (final v in vehicles)
                  DropdownMenuItem<int?>(
                    value: v.id,
                    child: Text('${v.make} ${v.model}'),
                  ),
              ],
              onChanged: (id) => _selectVehicle(id, vehicles),
            ),
            const SizedBox(height: 16),
          ],
          TextField(
            controller: _kw,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Potenza (kW)',
              helperText: 'Libretto, campo P.2 · se hai i CV: kW ≈ CV × 0,735',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<EuroClass>(
            key: ValueKey(_euro),
            initialValue: _euro,
            decoration: const InputDecoration(
              labelText: 'Classe ambientale',
              helperText: 'Libretto, campo V.9',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final e in EuroClass.values)
                DropdownMenuItem(value: e, child: Text('Euro ${e.index}')),
            ],
            onChanged: (e) => setState(() => _euro = e ?? _euro),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int?>(
            key: ValueKey(_year),
            initialValue: _year,
            decoration: const InputDecoration(
              labelText: 'Anno immatricolazione (opz.)',
              helperText: 'Solo per lo sconto superbollo (auto > 185 kW)',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<int?>(child: Text('—')),
              for (var y = thisYear; y >= 1980; y--)
                DropdownMenuItem<int?>(value: y, child: Text('$y')),
            ],
            onChanged: (y) => setState(() => _year = y),
          ),
          const SizedBox(height: 24),
          if (result != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row('Bollo ordinario', _euroStr(result.ordinary)),
                    if (result.superbollo > 0) ...[
                      const SizedBox(height: 8),
                      _row('Superbollo', _euroStr(result.superbollo)),
                    ],
                    const Divider(height: 24),
                    _row(
                      'Totale annuo',
                      _euroStr(result.total),
                      emphasize: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_vehicleId != null)
              FilledButton.tonalIcon(
                onPressed: () => _createReminder(result.total),
                icon: const Icon(Icons.notification_add_outlined),
                label: const Text('Crea promemoria bollo'),
              )
            else if (vehicles.isNotEmpty)
              Text(
                'Seleziona un veicolo per creare il promemoria annuale.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
          const SizedBox(height: 16),
          Text(
            'Stima basata sulla tariffa nazionale (€/kW per classe Euro). '
            'Alcune regioni applicano importi diversi e Sardegna e '
            'Friuli-Venezia Giulia sono gestite a parte. Veicoli elettrici e '
            'storici seguono regimi speciali non calcolati qui.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool emphasize = false}) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleLarge
        : Theme.of(context).textTheme.bodyLarge;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
