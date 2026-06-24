import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/vehicle.dart';
import '../../providers.dart';
import 'vehicle_providers.dart';

double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

class VehicleFormScreen extends ConsumerStatefulWidget {
  const VehicleFormScreen({super.key, this.initial});
  final Vehicle? initial;

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _make = TextEditingController(text: widget.initial?.make);
  late final _model = TextEditingController(text: widget.initial?.model);
  late final _plate = TextEditingController(text: widget.initial?.plate);
  late final _trim = TextEditingController(text: widget.initial?.trim);
  late final _tank = TextEditingController(
    text: widget.initial?.specs.tankCapacityL?.toString(),
  );
  late final _consumption = TextEditingController(
    text: widget.initial?.specs.mfrConsumption?.toString(),
  );
  late final _power = TextEditingController(
    text: widget.initial?.specs.powerPs?.toString(),
  );
  late int? _year = widget.initial?.year;
  late FuelType _fuel = widget.initial?.fuelType ?? FuelType.petrol;
  late EuroClass? _euroClass = widget.initial?.euroClass;
  late bool _isDefault = widget.initial?.isDefault ?? false;

  @override
  void dispose() {
    _make.dispose();
    _model.dispose();
    _plate.dispose();
    _trim.dispose();
    _tank.dispose();
    _consumption.dispose();
    _power.dispose();
    super.dispose();
  }

  bool _specsChanged(Vehicle? base) {
    final specs = base?.specs ?? const VehicleSpecs();
    return _parse(_tank.text) != specs.tankCapacityL ||
        _parse(_consumption.text) != specs.mfrConsumption ||
        int.tryParse(_power.text.trim()) != specs.powerPs;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final base = widget.initial;
    final tank = _parse(_tank.text);
    final cons = _parse(_consumption.text);
    final power = int.tryParse(_power.text.trim());
    final normalizedPlate = ref
        .read(vehicleLookupServiceProvider)
        .normalizePlate(_plate.text);
    final specsChanged = _specsChanged(base);
    final source = specsChanged
        ? SpecSource.manual
        : (base?.specs.source ?? SpecSource.manual);
    final vehicle = Vehicle(
      id: base?.id ?? 0,
      make: _make.text.trim(),
      model: _model.text.trim(),
      year: _year,
      trim: _trim.text.trim().isEmpty ? null : _trim.text.trim(),
      fuelType: _fuel,
      plate: normalizedPlate.isEmpty ? null : normalizedPlate,
      euroClass: _euroClass,
      colorTag: base?.colorTag ?? 0,
      isDefault: _isDefault,
      specs: (base?.specs ?? const VehicleSpecs()).copyWith(
        tankCapacityL: tank,
        mfrConsumption: cons,
        mfrRangeKm: (tank != null && cons != null && cons > 0)
            ? tank * 100 / cons
            : null,
        powerPs: power,
        source: source,
        catalogRef: specsChanged ? null : base?.specs.catalogRef,
      ),
      createdAt: base?.createdAt ?? now,
      updatedAt: now,
    );
    await ref.read(vehicleRepositoryProvider).upsert(vehicle);
    ref.invalidate(vehiclesProvider);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final thisYear = DateTime.now().year;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initial == null ? 'Nuovo veicolo' : 'Modifica veicolo',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _make,
              decoration: const InputDecoration(labelText: 'Marca'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Obbligatorio' : null,
            ),
            TextFormField(
              controller: _model,
              decoration: const InputDecoration(labelText: 'Modello'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Obbligatorio' : null,
            ),
            TextFormField(
              controller: _plate,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Targa',
                hintText: 'AB123CD',
                prefixIcon: Icon(Icons.pin),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    initialValue: _year,
                    decoration: const InputDecoration(labelText: 'Anno'),
                    items: [
                      const DropdownMenuItem<int?>(child: Text('—')),
                      for (var y = thisYear + 1; y >= 1980; y--)
                        DropdownMenuItem<int?>(value: y, child: Text('$y')),
                    ],
                    onChanged: (y) => setState(() => _year = y),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _trim,
                    decoration: const InputDecoration(
                      labelText: 'Allestimento',
                    ),
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<FuelType>(
              initialValue: _fuel,
              decoration: const InputDecoration(labelText: 'Carburante'),
              items: [
                for (final f in FuelType.values)
                  DropdownMenuItem(value: f, child: Text(f.name)),
              ],
              onChanged: (f) => setState(() => _fuel = f ?? _fuel),
            ),
            DropdownButtonFormField<EuroClass?>(
              initialValue: _euroClass,
              decoration: const InputDecoration(
                labelText: 'Classe ambientale (Euro)',
                helperText: 'Per il calcolo del bollo · libretto V.9',
              ),
              items: [
                const DropdownMenuItem<EuroClass?>(child: Text('—')),
                for (final e in EuroClass.values)
                  DropdownMenuItem<EuroClass?>(
                    value: e,
                    child: Text('Euro ${e.index}'),
                  ),
              ],
              onChanged: (e) => setState(() => _euroClass = e),
            ),
            TextFormField(
              controller: _tank,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Capacità serbatoio (L)',
              ),
            ),
            TextFormField(
              controller: _consumption,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Consumo dichiarato (L/100km)',
              ),
            ),
            TextFormField(
              controller: _power,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Potenza (CV)'),
            ),
            SwitchListTile(
              title: const Text('Veicolo predefinito'),
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: const Text('Salva')),
          ],
        ),
      ),
    );
  }
}
