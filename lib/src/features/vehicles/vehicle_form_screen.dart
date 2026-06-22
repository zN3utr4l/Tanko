import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/vehicle.dart';
import '../../providers.dart';
import 'vehicle_providers.dart';

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
  late final _tank = TextEditingController(
    text: widget.initial?.specs.tankCapacityL?.toString(),
  );
  late FuelType _fuel = widget.initial?.fuelType ?? FuelType.petrol;
  late bool _isDefault = widget.initial?.isDefault ?? false;

  @override
  void dispose() {
    _make.dispose();
    _model.dispose();
    _tank.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final base = widget.initial;
    final vehicle = Vehicle(
      id: base?.id ?? 0,
      make: _make.text.trim(),
      model: _model.text.trim(),
      year: base?.year,
      trim: base?.trim,
      fuelType: _fuel,
      isDefault: _isDefault,
      specs: (base?.specs ?? const VehicleSpecs()).copyWith(
        tankCapacityL: double.tryParse(_tank.text.replaceAll(',', '.')),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? 'Nuovo veicolo' : 'Modifica veicolo'),
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
            DropdownButtonFormField<FuelType>(
              initialValue: _fuel,
              decoration: const InputDecoration(labelText: 'Carburante'),
              items: [
                for (final f in FuelType.values)
                  DropdownMenuItem(value: f, child: Text(f.name)),
              ],
              onChanged: (f) => setState(() => _fuel = f ?? _fuel),
            ),
            TextFormField(
              controller: _tank,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Capacità serbatoio (L)'),
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
