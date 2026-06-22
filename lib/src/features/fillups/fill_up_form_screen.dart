import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/formatters.dart';
import '../../domain/models/fill_up.dart';
import '../../providers.dart';
import 'fillup_providers.dart';

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
  late final DateTime _date =
      widget.initial?.date ?? widget.initialDate ?? DateTime.now();
  late bool _isFull = widget.initial?.isFull ?? true;
  int? _categoryId;

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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: const Text('Salva')),
          ],
        ),
      ),
    );
  }
}
