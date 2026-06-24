import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/catalog.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/reminder.dart';
import '../../domain/models/vehicle.dart';
import '../../providers.dart';
import '../reminders/reminder_providers.dart';
import 'catalog_providers.dart';
import 'vehicle_providers.dart';
import 'vehicle_lookup_browser_screen.dart';

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
  final _plate = TextEditingController();
  final _tank = TextEditingController();
  final _consumption = TextEditingController();
  final _power = TextEditingController();

  int? _year;
  EuroClass? _euroClass;
  FuelType _fuel = FuelType.petrol;
  bool _isDefault = false;
  SpecSource _specSource = SpecSource.manual;
  String? _insuranceCompany;
  DateTime? _insuranceExpiry;
  int _fieldVersion = 0;

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
      _plate,
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
      _specSource = SpecSource.catalog;
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
      _specSource = SpecSource.catalog;
      _trimCtrl.text = t.name;
      if (t.fuelType != null) _fuel = t.fuelType!;
      if (t.tankCapacityL != null) _tank.text = t.tankCapacityL!.toString();
      if (t.consumptionL100 != null) {
        _consumption.text = t.consumptionL100!.toString();
      }
      if (t.powerPs != null) _power.text = t.powerPs!.toString();
    });
  }

  void _markManual() {
    if (_specSource != SpecSource.manual) {
      setState(() => _specSource = SpecSource.manual);
    }
  }

  Future<void> _openLookup(String title, Uri uri) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VehicleLookupBrowserScreen(title: title, uri: uri),
      ),
    );
  }

  Future<void> _pasteLookupData() async {
    final controller = TextEditingController();
    final pasted = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Incolla dati verifica'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Dati copiati dalla verifica',
          ),
          maxLines: 8,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Applica'),
          ),
        ],
      ),
    );
    if (pasted == null) return;
    final data = ref.read(vehicleLookupServiceProvider).parsePastedText(pasted);
    if (!mounted) return;
    setState(() {
      final normalizedPlate = ref
          .read(vehicleLookupServiceProvider)
          .normalizePlate(_plate.text);
      _plate.text = data.plate ?? normalizedPlate;
      if (data.make != null) _make.text = data.make!;
      if (data.model != null) _model.text = data.model!;
      if (data.trim != null) _trimCtrl.text = data.trim!;
      if (data.year != null) _year = data.year;
      if (data.fuelType != null) _fuel = data.fuelType!;
      if (data.euroClass != null) _euroClass = data.euroClass;
      if (data.powerPs != null) _power.text = data.powerPs!.toString();
      _insuranceCompany = data.insuranceCompany;
      _insuranceExpiry = data.insuranceExpiry;
      _fieldVersion++;
      if (data.hasVehicleFields) _specSource = SpecSource.online;
    });
    if (data.make != null) {
      await _loadModels(data.make!);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final tank = _parse(_tank.text);
    final cons = _parse(_consumption.text);
    final normalizedPlate = ref
        .read(vehicleLookupServiceProvider)
        .normalizePlate(_plate.text);
    final vehicle = Vehicle(
      id: 0,
      make: _make.text.trim(),
      model: _model.text.trim(),
      year: _year,
      trim: _trimCtrl.text.trim().isEmpty ? null : _trimCtrl.text.trim(),
      fuelType: _fuel,
      plate: normalizedPlate.isEmpty ? null : normalizedPlate,
      euroClass: _euroClass,
      isDefault: _isDefault,
      specs: VehicleSpecs(
        tankCapacityL: tank,
        mfrConsumption: cons,
        mfrRangeKm: (tank != null && cons != null && cons > 0)
            ? tank * 100 / cons
            : null,
        powerPs: int.tryParse(_power.text.trim()),
        source: _specSource,
        catalogRef: null,
      ),
      createdAt: now,
      updatedAt: now,
    );
    final vehicleId = await ref.read(vehicleRepositoryProvider).upsert(vehicle);
    if (_insuranceExpiry != null) {
      await ref
          .read(reminderRepositoryProvider)
          .upsert(
            Reminder(
              id: 0,
              vehicleId: vehicleId,
              type: ReminderType.assicurazione,
              title: _insuranceCompany == null
                  ? 'Assicurazione'
                  : 'Assicurazione - $_insuranceCompany',
              triggerMode: TriggerMode.date,
              dueDate: _insuranceExpiry,
              recurEvery: 1,
              recurUnit: RecurUnit.year,
              leadDays: 30,
              createdAt: now,
              updatedAt: now,
            ),
          );
      ref.invalidate(reminderEvaluationsProvider(vehicleId));
    }
    ref.invalidate(vehiclesProvider);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final makes = ref.watch(catalogMakesProvider).asData?.value ?? const [];
    final onlineLookupEnabled =
        ref
            .watch(lookupSettingsProvider)
            .asData
            ?.value
            .vehicleOnlineLookupEnabled ??
        false;
    final thisYear = DateTime.now().year;
    return Scaffold(
      appBar: AppBar(title: const Text('Nuovo veicolo')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _plate,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Targa',
                hintText: 'AB123CD',
                prefixIcon: Icon(Icons.pin),
              ),
            ),
            const SizedBox(height: 8),
            _LookupAssistCard(
              onlineEnabled: onlineLookupEnabled,
              onPaste: _pasteLookupData,
              onInsurance: () {
                final service = ref.read(vehicleLookupServiceProvider);
                _openLookup(
                  'Verifica RCA',
                  service.insuranceVerificationUri(_plate.text),
                );
              },
              onEuroClass: () {
                final service = ref.read(vehicleLookupServiceProvider);
                _openLookup(
                  'Classe ambientale',
                  service.environmentalClassVerificationUri(_plate.text),
                );
              },
            ),
            const SizedBox(height: 12),
            _MakeField(
              key: ValueKey('make-$_fieldVersion'),
              controller: _make,
              makes: makes,
              onChanged: (text) {
                _loadModels(text);
                // typing a new make invalidates a catalog-prefilled model
                _markManual();
              },
            ),
            const SizedBox(height: 4),
            _ModelField(
              key: ValueKey('model-$_fieldVersion'),
              controller: _model,
              models: _models,
              onSelected: _applyModel,
              onChanged: (_) => _markManual(),
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
                    onChanged: (y) => setState(() {
                      _year = y;
                      if (_specSource != SpecSource.manual) {
                        _specSource = SpecSource.manual;
                      }
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TrimField(
                    key: ValueKey('trim-$_fieldVersion'),
                    controller: _trimCtrl,
                    trims: _trims,
                    onSelected: _applyTrim,
                    onChanged: (_) => _markManual(),
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
              onChanged: (f) => setState(() {
                _fuel = f ?? _fuel;
                if (_specSource != SpecSource.manual) {
                  _specSource = SpecSource.manual;
                }
              }),
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
              onChanged: (e) => setState(() {
                _euroClass = e;
                if (_specSource != SpecSource.manual) {
                  _specSource = SpecSource.manual;
                }
              }),
            ),
            TextFormField(
              controller: _tank,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Capacità serbatoio (L)',
              ),
              onChanged: (_) => _markManual(),
            ),
            TextFormField(
              controller: _consumption,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Consumo dichiarato (L/100km)',
              ),
              onChanged: (_) => _markManual(),
            ),
            TextFormField(
              controller: _power,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Potenza (CV)'),
              onChanged: (_) => _markManual(),
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

class _LookupAssistCard extends StatelessWidget {
  const _LookupAssistCard({
    required this.onlineEnabled,
    required this.onPaste,
    required this.onInsurance,
    required this.onEuroClass,
  });

  final bool onlineEnabled;
  final VoidCallback onPaste;
  final VoidCallback onInsurance;
  final VoidCallback onEuroClass;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: onlineEnabled ? onInsurance : null,
          icon: const Icon(Icons.verified_user_outlined),
          label: const Text('Verifica RCA'),
        ),
        OutlinedButton.icon(
          onPressed: onlineEnabled ? onEuroClass : null,
          icon: const Icon(Icons.eco_outlined),
          label: const Text('Classe Euro'),
        ),
        FilledButton.tonalIcon(
          onPressed: onPaste,
          icon: const Icon(Icons.content_paste),
          label: const Text('Incolla dati verifica'),
        ),
        if (!onlineEnabled)
          Text(
            'Attiva il lookup veicoli online dalle impostazioni.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}

/// Type-ahead make field. Suggests catalog makes as you type; free text is
/// always accepted for makes not in the catalog.
class _MakeField extends StatelessWidget {
  const _MakeField({
    super.key,
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
    super.key,
    required this.controller,
    required this.models,
    required this.onSelected,
    required this.onChanged,
  });

  final TextEditingController controller;
  final List<CatalogModel> models;
  final ValueChanged<CatalogModel> onSelected;
  final ValueChanged<String> onChanged;

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
          onChanged: (t) {
            controller.text = t;
            onChanged(t);
          },
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
    super.key,
    required this.controller,
    required this.trims,
    required this.onSelected,
    required this.onChanged,
  });

  final TextEditingController controller;
  final List<CatalogTrim> trims;
  final ValueChanged<CatalogTrim> onSelected;
  final ValueChanged<String> onChanged;

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
          onChanged: (t) {
            controller.text = t;
            onChanged(t);
          },
        );
      },
    );
  }
}
