import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/catalog.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/vehicle.dart';
import '../../providers.dart';
import 'catalog_providers.dart';
import 'vehicle_providers.dart';

double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

/// Add a vehicle by picking Make -> Model -> Trim from the online catalog,
/// auto-filling specs. Every field stays editable, and a manual fallback is
/// always available (used when offline or the trim isn't found).
class AddVehicleWizardScreen extends ConsumerStatefulWidget {
  const AddVehicleWizardScreen({super.key});

  @override
  ConsumerState<AddVehicleWizardScreen> createState() =>
      _AddVehicleWizardScreenState();
}

class _AddVehicleWizardScreenState
    extends ConsumerState<AddVehicleWizardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _make = TextEditingController();
  final _model = TextEditingController();
  final _year = TextEditingController();
  final _trimCtrl = TextEditingController();
  final _tank = TextEditingController();
  final _consumption = TextEditingController();
  final _power = TextEditingController();

  String? _makeId;
  String? _selectedModel;
  CatalogTrim? _trim;
  FuelType _fuel = FuelType.petrol;
  bool _isDefault = false;
  bool _manual = false;

  @override
  void dispose() {
    for (final c in [
      _make,
      _model,
      _year,
      _trimCtrl,
      _tank,
      _consumption,
      _power,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _applyTrim(CatalogTrim t) {
    setState(() {
      _trim = t;
      _make.text = _makeName ?? t.make;
      _model.text = t.model;
      _year.text = t.year?.toString() ?? '';
      _trimCtrl.text = t.trim ?? '';
      _tank.text = t.tankCapacityL?.toString() ?? '';
      _consumption.text = t.consumptionL100?.toString() ?? '';
      _power.text = t.powerPs?.toString() ?? '';
      if (t.fuelType != null) _fuel = t.fuelType!;
    });
  }

  String? _makeName;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final tank = _parse(_tank.text);
    final cons = _parse(_consumption.text);
    final vehicle = Vehicle(
      id: 0,
      make: _make.text.trim(),
      model: _model.text.trim(),
      year: int.tryParse(_year.text.trim()),
      trim: _trimCtrl.text.trim().isEmpty ? null : _trimCtrl.text.trim(),
      fuelType: _fuel,
      isDefault: _isDefault,
      specs: VehicleSpecs(
        tankCapacityL: tank,
        mfrConsumption: cons,
        mfrRangeKm: (tank != null && cons != null && cons > 0)
            ? tank * 100 / cons
            : null,
        powerPs: int.tryParse(_power.text.trim()),
        source: _trim != null ? SpecSource.carquery : SpecSource.manual,
        catalogRef: _trim?.modelId,
      ),
      createdAt: now,
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
        title: const Text('Nuovo veicolo'),
        actions: [
          TextButton(
            onPressed: () => setState(() => _manual = !_manual),
            child: Text(_manual ? 'Catalogo' : 'Manuale'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!_manual) ..._catalogSection(),
            const Divider(),
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _year,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Anno'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _trimCtrl,
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

  List<Widget> _catalogSection() {
    final makesAsync = ref.watch(catalogMakesProvider);
    return [
      makesAsync.when(
        loading: () => const LinearProgressIndicator(),
        error: (e, _) =>
            _CatalogError(onManual: () => setState(() => _manual = true)),
        data: (makes) => DropdownButtonFormField<String>(
          initialValue: _makeId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Marca (catalogo)'),
          items: [
            for (final m in makes)
              DropdownMenuItem(value: m.id, child: Text(m.name)),
          ],
          onChanged: (id) => setState(() {
            _makeId = id;
            _makeName = makes.firstWhere((m) => m.id == id).name;
            _selectedModel = null;
            _trim = null;
          }),
        ),
      ),
      if (_makeId != null)
        ref
            .watch(catalogModelsProvider(_makeId!))
            .when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => const Text('Modelli non disponibili'),
              data: (models) => DropdownButtonFormField<String>(
                initialValue: _selectedModel,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Modello (catalogo)',
                ),
                items: [
                  for (final m in models)
                    DropdownMenuItem(value: m, child: Text(m)),
                ],
                onChanged: (m) => setState(() {
                  _selectedModel = m;
                  _trim = null;
                }),
              ),
            ),
      if (_makeId != null && _selectedModel != null)
        ref
            .watch(catalogTrimsProvider(_makeId!, _selectedModel!))
            .when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => const Text('Allestimenti non disponibili'),
              data: (trims) => DropdownButtonFormField<CatalogTrim>(
                initialValue: _trim,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Allestimento (catalogo)',
                ),
                items: [
                  for (final t in trims)
                    DropdownMenuItem(value: t, child: Text(t.label)),
                ],
                onChanged: (t) {
                  if (t != null) _applyTrim(t);
                },
              ),
            ),
    ];
  }
}

class _CatalogError extends StatelessWidget {
  const _CatalogError({required this.onManual});
  final VoidCallback onManual;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catalogo non raggiungibile (sei offline o il servizio è giù).',
        ),
        TextButton(onPressed: onManual, child: const Text('Inserisci a mano')),
      ],
    );
  }
}
