import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/formatters.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/reminder.dart';
import '../../providers.dart';
import '../calendar/calendar_providers.dart';
import '../expenses/expense_providers.dart';
import 'reminder_providers.dart';

double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

enum _Recur { none, yearly, biennial, semiannual, fixedDate }

const _recurLabels = {
  _Recur.none: 'Una tantum',
  _Recur.yearly: 'Ogni anno',
  _Recur.biennial: 'Ogni 2 anni',
  _Recur.semiannual: 'Ogni 6 mesi',
  _Recur.fixedDate: 'Date fisse (stagionale)',
};

class ReminderFormScreen extends ConsumerStatefulWidget {
  const ReminderFormScreen({super.key, required this.initial});
  final Reminder initial;

  @override
  ConsumerState<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends ConsumerState<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.initial.title);
  late final _dueOdometer = TextEditingController(
    text: widget.initial.dueOdometer?.toString(),
  );
  late final _recurKm = TextEditingController(
    text: widget.initial.recurKmEvery?.toString(),
  );
  late final _leadDays = TextEditingController(
    text: widget.initial.leadDays?.toString(),
  );
  late final _leadKm = TextEditingController(
    text: widget.initial.leadKm?.toString(),
  );
  late TriggerMode _trigger = widget.initial.triggerMode;
  late DateTime? _dueDate = widget.initial.dueDate;
  late bool _notify = widget.initial.notify;
  late int? _linkedCategory = widget.initial.linkedExpenseCategoryId;
  late _Recur _recur = _initialRecur(widget.initial);

  static _Recur _initialRecur(Reminder r) {
    if (r.recurUnit == RecurUnit.fixedDate) return _Recur.fixedDate;
    if (r.recurUnit == RecurUnit.year && r.recurEvery == 2) {
      return _Recur.biennial;
    }
    if (r.recurUnit == RecurUnit.year) return _Recur.yearly;
    if (r.recurUnit == RecurUnit.month && r.recurEvery == 6) {
      return _Recur.semiannual;
    }
    return _Recur.none;
  }

  @override
  void dispose() {
    for (final c in [_title, _dueOdometer, _recurKm, _leadDays, _leadKm]) {
      c.dispose();
    }
    super.dispose();
  }

  (int?, RecurUnit?) _recurValues() => switch (_recur) {
    _Recur.none => (null, null),
    _Recur.yearly => (1, RecurUnit.year),
    _Recur.biennial => (2, RecurUnit.year),
    _Recur.semiannual => (6, RecurUnit.month),
    _Recur.fixedDate => (null, RecurUnit.fixedDate),
  };

  bool get _hasDate => _trigger != TriggerMode.distance;
  bool get _hasKm => _trigger != TriggerMode.date;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final (recurEvery, recurUnit) = _recurValues();
    final now = DateTime.now();
    final r = widget.initial.copyWith(
      title: _title.text.trim(),
      triggerMode: _trigger,
      dueDate: _hasDate ? _dueDate : null,
      dueOdometer: _hasKm ? _parse(_dueOdometer.text) : null,
      recurEvery: recurEvery,
      recurUnit: recurUnit,
      recurKmEvery: _hasKm ? int.tryParse(_recurKm.text.trim()) : null,
      leadDays: _hasDate ? int.tryParse(_leadDays.text.trim()) : null,
      leadKm: _hasKm ? int.tryParse(_leadKm.text.trim()) : null,
      notify: _notify,
      linkedExpenseCategoryId: _linkedCategory,
      updatedAt: now,
    );
    final id = await ref.read(reminderRepositoryProvider).upsert(r);
    await ref
        .read(reminderNotificationSchedulerProvider)
        .sync(r.copyWith(id: id));
    ref.invalidate(reminderEvaluationsProvider(r.vehicleId));
    ref.invalidate(calendarEventsProvider(r.vehicleId));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(expenseCategoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initial.id == 0 ? 'Nuova scadenza' : 'Modifica scadenza',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Titolo'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            SegmentedButton<TriggerMode>(
              segments: const [
                ButtonSegment(value: TriggerMode.date, label: Text('Data')),
                ButtonSegment(value: TriggerMode.distance, label: Text('Km')),
                ButtonSegment(value: TriggerMode.both, label: Text('Entrambi')),
              ],
              selected: {_trigger},
              onSelectionChanged: (s) => setState(() => _trigger = s.first),
            ),
            const SizedBox(height: 8),
            if (_hasDate) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: const Text('Scadenza (data)'),
                subtitle: Text(_dueDate == null ? '—' : fmtDate(_dueDate!)),
                trailing: const Icon(Icons.edit),
                onTap: _pickDate,
              ),
              DropdownButtonFormField<_Recur>(
                initialValue: _recur,
                decoration: const InputDecoration(labelText: 'Ripetizione'),
                items: [
                  for (final r in _Recur.values)
                    DropdownMenuItem(value: r, child: Text(_recurLabels[r]!)),
                ],
                onChanged: (v) => setState(() => _recur = v ?? _recur),
              ),
              TextFormField(
                controller: _leadDays,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preavviso (giorni)',
                ),
              ),
            ],
            if (_hasKm) ...[
              TextFormField(
                controller: _dueOdometer,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Scadenza (odometro km)',
                ),
              ),
              TextFormField(
                controller: _recurKm,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Ripeti ogni (km)',
                ),
              ),
              TextFormField(
                controller: _leadKm,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Preavviso (km)'),
              ),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Notifica'),
              value: _notify,
              onChanged: (v) => setState(() => _notify = v),
            ),
            cats.maybeWhen(
              data: (list) => DropdownButtonFormField<int?>(
                initialValue: _linkedCategory,
                decoration: const InputDecoration(
                  labelText: 'Spesa collegata (opzionale)',
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Nessuna')),
                  for (final c in list)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                onChanged: (v) => setState(() => _linkedCategory = v),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: const Text('Salva')),
          ],
        ),
      ),
    );
  }
}
