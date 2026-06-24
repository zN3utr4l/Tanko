import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/formatters.dart';
import '../../domain/models/fill_up.dart';
import '../../domain/models/geo_point.dart';
import '../../providers.dart';
import 'fillup_providers.dart';
import 'station_detector.dart';

double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

class FillUpFormScreen extends ConsumerStatefulWidget {
  const FillUpFormScreen({
    super.key,
    required this.vehicleId,
    this.initial,
    this.initialDate,
  });
  final int vehicleId;
  final FillUp? initial;
  final DateTime? initialDate;

  @override
  ConsumerState<FillUpFormScreen> createState() => _FillUpFormScreenState();
}

class _FillUpFormScreenState extends ConsumerState<FillUpFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _amount = TextEditingController(
    text: widget.initial?.amount.toString(),
  );
  late final _liters = TextEditingController(
    text: widget.initial?.liters?.toString(),
  );
  late final _odometer = TextEditingController(
    text: widget.initial?.odometer.toString(),
  );
  late final _station = TextEditingController(text: widget.initial?.station);
  late final _note = TextEditingController(text: widget.initial?.note);
  late DateTime _date =
      widget.initial?.date ?? widget.initialDate ?? DateTime.now();
  late bool _isFull = widget.initial?.isFull ?? true;
  int? _categoryId;
  late double? _latitude = widget.initial?.latitude;
  late double? _longitude = widget.initial?.longitude;
  late String? _receiptPhotoPath = widget.initial?.receiptPhotoPath;

  @override
  void initState() {
    super.initState();
    if (widget.initial == null && shouldOfferDetection(_date, DateTime.now())) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _offerDetection());
    }
  }

  @override
  void dispose() {
    for (final c in [_amount, _liters, _odometer, _station, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  String get _pricePerLiter {
    final a = _parse(_amount.text);
    final l = _parse(_liters.text);
    if (a == null || l == null || l == 0) return '—';
    return '${fmtEuro(a / l)}/L';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _offerDetection() async {
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sei al distributore adesso?'),
        content: const Text(
          'Posso provare a rilevare il distributore dalla tua posizione, '
          'oppure leggerlo dallo scontrino.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'later'),
            child: const Text('Inserisci dopo'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'no'),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, 'yes'),
            child: const Text('Sì'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (choice == 'yes') {
      await _detectFromGps();
    } else if (choice == 'no') {
      await _useReceipt();
    }
  }

  Future<void> _detectFromGps() async {
    final result = await ref.read(stationDetectorProvider).detect();
    if (!mounted) return;
    if (result.position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Posizione non disponibile')),
      );
      return;
    }
    final match = result.match;
    if (match != null) {
      setState(() {
        _station.text = match.name;
        _latitude = match.latitude;
        _longitude = match.longitude;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Rilevato: ${match.name}')));
      return;
    }
    // No history match — record the coords and offer fallbacks.
    setState(() {
      _latitude = result.position!.latitude;
      _longitude = result.position!.longitude;
    });
    await _offerFallback(result.position!);
  }

  Future<void> _offerFallback(GeoPoint at) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Distributore non riconosciuto'),
        content: const Text('Come vuoi inserirlo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'manual'),
            child: const Text('A mano'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'receipt'),
            child: const Text('Usa scontrino'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, 'online'),
            child: const Text('Cerca online'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (choice == 'online') {
      await _lookupOnline(at);
    } else if (choice == 'receipt') {
      await _useReceipt();
    }
  }

  Future<void> _lookupOnline(GeoPoint at) async {
    final settings = await ref.read(lookupSettingsProvider.future);
    if (!mounted) return;
    if (!settings.stationOnlineLookupEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ricerca online disattivata')),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerca online'),
        content: const Text(
          'Le coordinate verranno inviate a OpenStreetMap per cercare i '
          'distributori vicini. Procedere?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Procedi'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final candidates = await ref.read(stationDetectorProvider).lookupOnline(at);
    if (!mounted) return;
    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nessun distributore trovato')),
      );
      return;
    }
    final picked = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Distributori vicini'),
        children: [
          for (final c in candidates)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, c.name),
              child: Text('${c.name} · ${c.distanceMeters.round()} m'),
            ),
        ],
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _station.text = picked);
  }

  Future<void> _useReceipt() async {
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (file == null || !mounted) return;
    final data = await ref.read(stationDetectorProvider).readReceipt(file.path);
    if (!mounted) return;
    setState(() {
      _receiptPhotoPath = file.path;
      if (data.station != null) _station.text = data.station!;
      if (data.amount != null) _amount.text = data.amount!.toString();
      if (data.liters != null) _liters.text = data.liters!.toString();
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final cats = await ref.read(fuelCategoriesProvider.future);
    final categoryId =
        _categoryId ??
        cats.firstWhere((c) => c.isDefault, orElse: () => cats.first).id;
    final odometer = _parse(_odometer.text)!;

    final existing = await ref
        .read(fillUpRepositoryProvider)
        .forVehicle(widget.vehicleId);
    if (existing.isNotEmpty && odometer < existing.last.odometer && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attenzione: odometro inferiore al precedente'),
        ),
      );
    }

    final now = DateTime.now();
    final base = widget.initial;
    await ref
        .read(fillUpRepositoryProvider)
        .upsert(
          FillUp(
            id: base?.id ?? 0,
            vehicleId: widget.vehicleId,
            date: _date,
            amount: _parse(_amount.text)!,
            liters: _parse(_liters.text),
            odometer: odometer,
            isFull: _isFull,
            station: _station.text.trim().isEmpty ? null : _station.text.trim(),
            categoryId: categoryId,
            note: _note.text.trim().isEmpty ? null : _note.text.trim(),
            latitude: _latitude,
            longitude: _longitude,
            receiptPhotoPath: _receiptPhotoPath,
            createdAt: base?.createdAt ?? now,
            updatedAt: now,
          ),
        );
    ref.invalidate(fillUpsProvider(widget.vehicleId));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(fuelCategoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? 'Nuovo rifornimento' : 'Modifica'),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(onPressed: _save, child: const Text('Salva')),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Data'),
              subtitle: Text(fmtDate(_date)),
              trailing: const Icon(Icons.edit),
              onTap: _pickDate,
            ),
            TextFormField(
              key: const Key('amount'),
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Importo (€)'),
              onChanged: (_) => setState(() {}),
              validator: (v) {
                final n = _parse(v ?? '');
                if (v == null || v.trim().isEmpty) return 'Obbligatorio';
                if (n == null || n <= 0) return 'Deve essere > 0';
                return null;
              },
            ),
            TextFormField(
              key: const Key('liters'),
              controller: _liters,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Litri'),
              onChanged: (_) => setState(() {}),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final n = _parse(v);
                if (n == null || n <= 0) return 'Deve essere > 0';
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Prezzo: $_pricePerLiter',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              key: const Key('odometer'),
              controller: _odometer,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Odometro (km)'),
              validator: (v) => _parse(v ?? '') == null ? 'Obbligatorio' : null,
            ),
            SwitchListTile(
              title: const Text('Pieno'),
              value: _isFull,
              onChanged: (v) => setState(() => _isFull = v),
            ),
            cats.maybeWhen(
              data: (list) => DropdownButtonFormField<int>(
                initialValue:
                    _categoryId ??
                    list
                        .firstWhere(
                          (c) => c.isDefault,
                          orElse: () => list.first,
                        )
                        .id,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: [
                  for (final c in list)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                onChanged: (v) => setState(() => _categoryId = v),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
            TextFormField(
              controller: _station,
              decoration: const InputDecoration(labelText: 'Distributore'),
            ),
            TextFormField(
              controller: _note,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}
