import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../core/formatters.dart';
import '../../domain/models/expense.dart';
import '../../providers.dart';
import 'expense_providers.dart';

double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

class ExpenseFormScreen extends ConsumerStatefulWidget {
  const ExpenseFormScreen({
    super.key,
    required this.vehicleId,
    this.initial,
    this.initialDate,
  });
  final int vehicleId;
  final Expense? initial;
  final DateTime? initialDate;

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _amount = TextEditingController(
    text: widget.initial?.amount.toString(),
  );
  late final _odometer = TextEditingController(
    text: widget.initial?.odometer?.toString(),
  );
  late final _description = TextEditingController(
    text: widget.initial?.description,
  );
  late DateTime _date =
      widget.initial?.date ?? widget.initialDate ?? DateTime.now();
  late bool _isRecurring = widget.initial?.isRecurring ?? false;
  late int? _categoryId = widget.initial?.categoryId;
  late String? _photoPath = widget.initial?.receiptPhotoPath;

  @override
  void dispose() {
    _amount.dispose();
    _odometer.dispose();
    _description.dispose();
    super.dispose();
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

  Future<void> _pickPhoto() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      final dir = await getApplicationDocumentsDirectory();
      final dest = p.join(dir.path, 'receipt_${picked.name}');
      await File(picked.path).copy(dest);
      setState(() => _photoPath = dest);
    } catch (_) {
      /* best-effort */
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final cats = await ref.read(expenseCategoriesProvider.future);
    final categoryId = _categoryId ?? (cats.isEmpty ? null : cats.first.id);
    if (categoryId == null) return;
    final now = DateTime.now();
    final base = widget.initial;
    await ref
        .read(expenseRepositoryProvider)
        .upsert(
          Expense(
            id: base?.id ?? 0,
            vehicleId: widget.vehicleId,
            date: _date,
            odometer: _parse(_odometer.text),
            categoryId: categoryId,
            amount: _parse(_amount.text)!,
            description: _description.text.trim().isEmpty
                ? null
                : _description.text.trim(),
            isRecurring: _isRecurring,
            receiptPhotoPath: _photoPath,
            createdAt: base?.createdAt ?? now,
            updatedAt: now,
          ),
        );
    ref.invalidate(expensesForVehicleProvider(widget.vehicleId));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(expenseCategoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? 'Nuova spesa' : 'Modifica spesa'),
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
              decoration: const InputDecoration(
                labelText: 'Importo (€)',
                prefixIcon: Icon(Icons.euro),
              ),
              validator: (v) {
                final n = _parse(v ?? '');
                if (v == null || v.trim().isEmpty) return 'Obbligatorio';
                if (n == null || n <= 0) return 'Deve essere > 0';
                return null;
              },
            ),
            const SizedBox(height: 8),
            cats.maybeWhen(
              data: (list) => DropdownButtonFormField<int>(
                initialValue:
                    _categoryId ?? (list.isEmpty ? null : list.first.id),
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  prefixIcon: Icon(Icons.category),
                ),
                items: [
                  for (final c in list)
                    DropdownMenuItem(
                      value: c.id,
                      child: Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Color(c.color),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(c.name),
                        ],
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _categoryId = v),
                validator: (v) => v == null ? 'Scegli una categoria' : null,
              ),
              orElse: () => const LinearProgressIndicator(),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Data'),
              subtitle: Text(fmtDate(_date)),
              trailing: const Icon(Icons.edit),
              onTap: _pickDate,
            ),
            TextFormField(
              controller: _odometer,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Odometro (km, opzionale)',
                prefixIcon: Icon(Icons.speed),
              ),
            ),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Descrizione',
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Ricorrente'),
              value: _isRecurring,
              onChanged: (v) => setState(() => _isRecurring = v),
            ),
            OutlinedButton.icon(
              onPressed: _pickPhoto,
              icon: const Icon(Icons.photo_camera),
              label: Text(
                _photoPath == null
                    ? 'Aggiungi foto scontrino'
                    : 'Foto allegata ✓',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: const Text('Salva')),
          ],
        ),
      ),
    );
  }
}
