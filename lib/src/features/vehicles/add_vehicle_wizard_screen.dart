import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/catalog.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/vehicle.dart';
import '../../providers.dart';
import 'catalog_providers.dart';
import 'vehicle_providers.dart';

double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

/// Add a vehicle with a single smart form. Make and Model are type-ahead fields
/// backed by the bundled offline catalog: typing suggests matches and picking a
/// known model pre-fills its specs. Year is a dropdown over a plausible range,
/// and Allestimento suggests the model's known trims (when curated). Anything
/// not in the catalog can simply be typed in — every field stays editable and
/// there's no network to fail.
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
  final _trimCtrl = TextEditingController();
  final _tank = TextEditingController();
  final _consumption = TextEditingController();
  final _power = TextEditingController();

  int? _year;
  FuelType _fuel = FuelType.petrol;
  bool _isDefault = false;
  bool _fromCatalog = false;

  /// Models of the currently-typed make, fetched once per make from the
  /// offline catalog. Empty when the make isn't in the catalog (manual entry).
  List<CatalogModel> _models = const [];
  String _modelsForMake = '';

  /// Trims (allestimenti) of the currently-selected catalog model. Empty when
  /// no catalog model is picked or the model has no curated trims.
  List<CatalogTrim> _trims = const [];

  @override
  void dispose() {
    for (final c in [
      _make,
      _model,
      _trimCtrl,
      _tank,
      _consumption,
      _power,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadModels(String make) async {
    final key = make.trim().toLowerCase();
    if (key == _modelsForMake) return;
    final models = await ref.read(catalogRepositoryProvider).models(make);
    if (!mounted) return;
    setState(() {
      _modelsForMake = key;
      _models = models;
    });
  }

  void _applyModel(CatalogModel m) {
    setState(() {
      _fromCatalog = true;
      _model.text = m.name;
      // Trims may be curated on any fuel/power variant sharing this model
      // name (the catalog splits variants into separate entries), so gather
      // them across all same-named entries and de-duplicate.
      final seen = <String>{};
      _trims = [
        for (final x in _models)
          if (x.name == m.name)
            for (final t in x.trims)
              if (seen.add(t.name.toLowerCase())) t,
      ];
      if (m.fuelType != null) _fuel = m.fuelType!;
      _tank.text = m.tankCapacityL?.toString() ?? '';
      _consumption.text = m.consumptionL100?.toString() ?? '';
      _power.text = m.powerPs?.toString() ?? '';
    });
  }

  void _applyTrim(CatalogTrim t) {
    setState(() {
      _fromCatalog = true;
      _trimCtrl.text = t.name;
      if (t.fuelType != null) _fuel = t.fuelType!;
      if (t.tankCapacityL != null) _tank.text = t.tankCapacityL!.toString();
      if (t.consumptionL100 != null) {
        _consumption.text = t.consumptionL100!.toString();
      }
      if (t.powerPs != null) _power.text = t.powerPs!.toString();
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final tank = _parse(_tank.text);
    final cons = _parse(_consumption.text);
    final vehicle = Vehicle(
      id: 0,
      make: _make.text.trim(),
      model: _model.text.trim(),
      year: _year,
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
        source: _fromCatalog ? SpecSource.catalog : SpecSource.manual,
        catalogRef: null,
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
    final makes = ref.watch(catalogMakesProvider).asData?.value ?? const [];
    final thisYear = DateTime.now().year;
    return Scaffold(
      appBar: AppBar(title: const Text('Nuovo veicolo')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _MakeField(
              controller: _make,
              makes: makes,
              onChanged: (text) {
                _loadModels(text);
                // typing a new make invalidates a catalog-prefilled model
                if (_fromCatalog) setState(() => _fromCatalog = false);
              },
            ),
            const SizedBox(height: 4),
            _ModelField(
              controller: _model,
              models: _models,
              onSelected: _applyModel,
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
                  child: _TrimField(
                    controller: _trimCtrl,
                    trims: _trims,
                    onSelected: _applyTrim,
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
}

/// Type-ahead make field. Suggests catalog makes as you type; free text is
/// always accepted for makes not in the catalog.
class _MakeField extends StatelessWidget {
  const _MakeField({
    required this.controller,
    required this.makes,
    required this.onChanged,
  });

  final TextEditingController controller;
  final List<String> makes;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      // Seed the field's controller text so it survives rebuilds.
      initialValue: controller.value,
      optionsBuilder: (value) {
        final q = value.text.trim().toLowerCase();
        if (q.isEmpty) return const Iterable<String>.empty();
        return makes.where((m) => m.toLowerCase().contains(q));
      },
      onSelected: (sel) {
        controller.text = sel;
        onChanged(sel);
      },
      fieldViewBuilder: (context, fieldController, focusNode, _) {
        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Marca',
            hintText: 'Scrivi per cercare nel catalogo',
            suffixIcon: Icon(Icons.search),
          ),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Obbligatorio' : null,
          onChanged: (t) {
            controller.text = t;
            onChanged(t);
          },
        );
      },
    );
  }
}

/// Type-ahead model field. Suggests the selected make's catalog models (with
/// fuel/power to disambiguate variants); free text is always accepted.
class _ModelField extends StatelessWidget {
  const _ModelField({
    required this.controller,
    required this.models,
    required this.onSelected,
  });

  final TextEditingController controller;
  final List<CatalogModel> models;
  final ValueChanged<CatalogModel> onSelected;

  String _label(CatalogModel m) {
    final extra = <String>[
      if (m.fuelType != null) m.fuelType!.name,
      if (m.powerPs != null) '${m.powerPs} CV',
    ];
    return extra.isEmpty ? m.name : '${m.name} · ${extra.join(' · ')}';
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<CatalogModel>(
      initialValue: controller.value,
      displayStringForOption: (m) => m.name,
      optionsBuilder: (value) {
        final q = value.text.trim().toLowerCase();
        if (q.isEmpty) return models;
        return models.where((m) => m.name.toLowerCase().contains(q));
      },
      onSelected: onSelected,
      optionsViewBuilder: (context, onSelectedCb, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260, maxWidth: 360),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  for (final m in options)
                    ListTile(
                      dense: true,
                      title: Text(_label(m)),
                      onTap: () => onSelectedCb(m),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: (context, fieldController, focusNode, _) {
        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          decoration: const InputDecoration(labelText: 'Modello'),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Obbligatorio' : null,
          onChanged: (t) => controller.text = t,
        );
      },
    );
  }
}

/// Type-ahead allestimento (trim) field. Suggests the selected model's curated
/// trims (with fuel/power to disambiguate); free text is always accepted, and
/// when no model/trims are loaded it behaves as a plain text field.
class _TrimField extends StatelessWidget {
  const _TrimField({
    required this.controller,
    required this.trims,
    required this.onSelected,
  });

  final TextEditingController controller;
  final List<CatalogTrim> trims;
  final ValueChanged<CatalogTrim> onSelected;

  String _label(CatalogTrim t) {
    final extra = <String>[
      if (t.fuelType != null) t.fuelType!.name,
      if (t.powerPs != null) '${t.powerPs} CV',
    ];
    return extra.isEmpty ? t.name : '${t.name} · ${extra.join(' · ')}';
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<CatalogTrim>(
      initialValue: controller.value,
      displayStringForOption: (t) => t.name,
      optionsBuilder: (value) {
        final q = value.text.trim().toLowerCase();
        if (q.isEmpty) return trims;
        return trims.where((t) => t.name.toLowerCase().contains(q));
      },
      onSelected: onSelected,
      optionsViewBuilder: (context, onSelectedCb, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260, maxWidth: 360),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  for (final t in options)
                    ListTile(
                      dense: true,
                      title: Text(_label(t)),
                      onTap: () => onSelectedCb(t),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: (context, fieldController, focusNode, _) {
        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          decoration: const InputDecoration(labelText: 'Allestimento'),
          onChanged: (t) => controller.text = t,
        );
      },
    );
  }
}
