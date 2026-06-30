import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import '../../core/formatters.dart';
import '../../core/widgets/form_section_card.dart';
import '../../data/lookup/mimit_fuel_price_lookup.dart';
import '../../domain/models/enums.dart';
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
  late int? _categoryId = widget.initial?.categoryId;
  late double? _latitude = widget.initial?.latitude;
  late double? _longitude = widget.initial?.longitude;
  late String? _receiptPhotoPath = widget.initial?.receiptPhotoPath;
  String? _officialPriceNote;
  bool _checkingOfficialPrice = false;

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
    final source = await _pickImageSource();
    if (source == null || !mounted) return;
    final XFile? file = await ImagePicker().pickImage(source: source);
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

  Future<ImageSource?> _pickImageSource() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Scatta foto'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Scegli dalla galleria'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkOfficialPrice() async {
    final liters = _parse(_liters.text);
    final amount = _parse(_amount.text);
    if (liters == null || liters <= 0 || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci importo e litri prima')),
      );
      return;
    }
    final settings = await ref.read(lookupSettingsProvider.future);
    if (!mounted) return;
    if (!settings.stationOnlineLookupEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ricerca distributori online disattivata'),
        ),
      );
      return;
    }
    setState(() => _checkingOfficialPrice = true);
    final at = _latitude != null && _longitude != null
        ? GeoPoint(_latitude!, _longitude!)
        : await ref.read(locationServiceProvider).current();
    if (!mounted) return;
    if (at == null) {
      setState(() => _checkingOfficialPrice = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Posizione non disponibile')),
      );
      return;
    }
    final candidates = await ref
        .read(mimitFuelPriceLookupProvider)
        .nearby(latitude: at.latitude, longitude: at.longitude);
    if (!mounted) return;
    setState(() => _checkingOfficialPrice = false);
    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nessun prezzo MIMIT vicino trovato')),
      );
      return;
    }
    final vehicle = await ref
        .read(vehicleRepositoryProvider)
        .getById(widget.vehicleId);
    if (!mounted) return;
    final priced = [
      for (final c in candidates)
        if (c.bestPriceFor(vehicle.fuelType) != null) c,
    ];
    if (priced.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nessun prezzo compatibile trovato')),
      );
      return;
    }
    final picked = await showDialog<int>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Prezzi ufficiali MIMIT'),
        children: [
          for (var i = 0; i < math.min(priced.length, 8); i++)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, i),
              child: Text(_mimitCandidateLabel(priced[i], vehicle.fuelType)),
            ),
        ],
      ),
    );
    if (picked == null || !mounted) return;
    final station = priced[picked];
    final price = station.bestPriceFor(vehicle.fuelType)!;
    final entered = amount / liters;
    final delta = entered - price.price;
    setState(() {
      _station.text = station.name;
      _latitude = station.latitude;
      _longitude = station.longitude;
      _officialPriceNote =
          'MIMIT: ${price.price.toStringAsFixed(3).replaceAll('.', ',')} €/L '
          '(${price.isSelf ? 'self' : 'servito'}) · differenza '
          '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(3).replaceAll('.', ',')} €/L';
    });
  }

  String _mimitCandidateLabel(
    MimitFuelStationPriceCandidate candidate,
    FuelType fuelType,
  ) {
    final price = candidate.bestPriceFor(fuelType)!;
    final euros = price.price.toStringAsFixed(3).replaceAll('.', ',');
    return '${candidate.name} · $euros €/L · ${candidate.distanceMeters.round()} m';
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
    final comparable = existing
        .where((f) => f.id != (widget.initial?.id ?? 0))
        .toList();
    final maxOdometer = comparable.isEmpty
        ? null
        : comparable.map((f) => f.odometer).reduce((a, b) => a > b ? a : b);
    if (maxOdometer != null && odometer < maxOdometer && mounted) {
      final confirmed = await _confirmSaveAnomaly(
        title: 'Odometro inferiore',
        message:
            'L\'odometro inserito e inferiore al massimo registrato '
            '(${maxOdometer.toStringAsFixed(0)} km).',
      );
      if (!confirmed) return;
    }
    final amount = _parse(_amount.text)!;
    final duplicate = comparable.any(
      (f) =>
          _sameDay(f.date, _date) &&
          f.odometer == odometer &&
          (f.amount - amount).abs() < 0.01,
    );
    if (duplicate && mounted) {
      final confirmed = await _confirmSaveAnomaly(
        title: 'Possibile duplicato',
        message:
            'Esiste gia un rifornimento con stessa data, importo e odometro.',
      );
      if (!confirmed) return;
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
            amount: amount,
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

  Future<bool> _confirmSaveAnomaly({
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Correggi'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salva comunque'),
          ),
        ],
      ),
    );
    return result == true;
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

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
            FormSectionCard(
              key: const Key('fillup-main-section'),
              title: 'Rifornimento',
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Data'),
                  subtitle: Text(fmtDate(_date)),
                  trailing: const Icon(Icons.edit),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 14),
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
                const SizedBox(height: 14),
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
                const SizedBox(height: 12),
                Text(
                  'Prezzo: $_pricePerLiter',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 14),
            FormSectionCard(
              key: const Key('fillup-details-section'),
              title: 'Dettagli',
              children: [
                if (_officialPriceNote != null) ...[
                  Text(
                    _officialPriceNote!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                ],
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _checkingOfficialPrice
                        ? null
                        : _checkOfficialPrice,
                    icon: _checkingOfficialPrice
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.price_check_outlined),
                    label: const Text('Confronta prezzo MIMIT'),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('odometer'),
                  controller: _odometer,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Odometro (km)'),
                  validator: (v) =>
                      _parse(v ?? '') == null ? 'Obbligatorio' : null,
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Pieno'),
                  value: _isFull,
                  onChanged: (v) => setState(() => _isFull = v),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 14),
                TextFormField(
                  controller: _station,
                  decoration: const InputDecoration(labelText: 'Distributore'),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _useReceipt,
                      icon: const Icon(Icons.document_scanner_outlined),
                      label: Text(
                        _receiptPhotoPath == null
                            ? 'Leggi scontrino'
                            : 'Rileggi scontrino',
                      ),
                    ),
                    if (_receiptPhotoPath != null) ...[
                      TextButton.icon(
                        onPressed: () => OpenFilex.open(_receiptPhotoPath!),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Apri'),
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            setState(() => _receiptPhotoPath = null),
                        icon: const Icon(Icons.close),
                        label: const Text('Rimuovi'),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _note,
                  decoration: const InputDecoration(labelText: 'Note'),
                ),
              ],
            ),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}
