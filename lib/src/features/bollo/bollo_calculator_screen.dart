import 'package:flutter/material.dart';

import '../../domain/services/bollo_calculator.dart';

/// "€ 1234,56" — Italian-style, enough for a single amount on this screen.
String _euroStr(double v) => '€ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

/// Offline bollo (car-tax) calculator. Computes the ordinary tax (and the
/// superbollo for >185 kW) from the data on the libretto — power in kW (P.2)
/// and the Euro class (V.9) — using the national tariff. No network, no plate.
class BolloCalculatorScreen extends StatefulWidget {
  const BolloCalculatorScreen({super.key});

  @override
  State<BolloCalculatorScreen> createState() => _BolloCalculatorScreenState();
}

class _BolloCalculatorScreenState extends State<BolloCalculatorScreen> {
  static const _calc = BolloCalculator();
  static const _euroLabels = {
    EuroClass.euro0: 'Euro 0',
    EuroClass.euro1: 'Euro 1',
    EuroClass.euro2: 'Euro 2',
    EuroClass.euro3: 'Euro 3',
    EuroClass.euro4: 'Euro 4',
    EuroClass.euro5: 'Euro 5',
    EuroClass.euro6: 'Euro 6',
  };

  final _kw = TextEditingController();
  EuroClass _euro = EuroClass.euro6;
  int? _year;

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

  @override
  Widget build(BuildContext context) {
    final thisYear = DateTime.now().year;
    final result = _result;
    return Scaffold(
      appBar: AppBar(title: const Text('Calcolatore bollo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
            initialValue: _euro,
            decoration: const InputDecoration(
              labelText: 'Classe ambientale',
              helperText: 'Libretto, campo V.9',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final e in EuroClass.values)
                DropdownMenuItem(value: e, child: Text(_euroLabels[e]!)),
            ],
            onChanged: (e) => setState(() => _euro = e ?? _euro),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int?>(
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
          if (result != null)
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
