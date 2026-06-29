import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/formatters.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/reminder.dart';
import '../../domain/models/reminder_evaluation.dart';
import '../../domain/services/bollo_calculator.dart';
import '../../providers.dart';
import '../calendar/calendar_providers.dart';
import '../dashboard/dashboard_providers.dart';
import '../expenses/expense_providers.dart';
import '../vehicles/widgets/empty_vehicle_prompt.dart';
import 'reminder_form_screen.dart';
import 'reminder_providers.dart';
import 'reminder_templates.dart';

double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));
String _amountText(double v) => v.toStringAsFixed(2).replaceAll('.', ',');

class ScadenzeScreen extends ConsumerWidget {
  const ScadenzeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(dashboardVehicleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Scadenze')),
      floatingActionButton: vehicleAsync.maybeWhen(
        data: (v) => v == null
            ? null
            : FloatingActionButton(
                onPressed: () => _pickTemplate(context, ref, v.id),
                child: const Icon(Icons.add),
              ),
        orElse: () => null,
      ),
      body: vehicleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (vehicle) {
          if (vehicle == null) {
            return const EmptyVehiclePrompt();
          }
          final evals = ref.watch(reminderEvaluationsProvider(vehicle.id));
          return evals.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Errore: $e')),
            data: (list) => list.isEmpty
                ? const Center(child: Text('Nessuna scadenza. Aggiungine una.'))
                : ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      for (final e in list)
                        _ReminderCard(e, vehicleId: vehicle.id),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Future<int?> _linkedExpenseCategoryId(
    WidgetRef ref,
    ReminderTemplate template,
  ) async {
    final name = template.linkedExpenseCategoryName;
    if (name == null) return null;
    final categories = await ref.read(expenseCategoriesProvider.future);
    for (final category in categories) {
      if (category.name == name) return category.id;
    }
    return null;
  }

  void _pickTemplate(BuildContext context, WidgetRef ref, int vehicleId) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final t in reminderTemplates)
              ListTile(
                leading: Icon(t.icon),
                title: Text(t.label),
                onTap: () async {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  final linkedCategoryId = await _linkedExpenseCategoryId(
                    ref,
                    t,
                  );
                  if (!navigator.mounted) return;
                  navigator.push(
                    MaterialPageRoute(
                      builder: (_) => ReminderFormScreen(
                        initial: t.draft(
                          vehicleId,
                          DateTime.now(),
                          linkedExpenseCategoryId: linkedCategoryId,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

(String, Color, IconData) _statusChip(ReminderEvaluation e, ColorScheme cs) {
  switch (e.status) {
    case ReminderStatus.overdue:
      final parts = <String>[
        if (e.daysRemaining != null && e.daysRemaining! < 0)
          'da ${-e.daysRemaining!} giorni',
        if (e.kmRemaining != null && e.kmRemaining! <= 0)
          'di ${(-e.kmRemaining!).round()} km',
      ];
      return ('Scaduto ${parts.join(' / ')}'.trim(), cs.error, Icons.error);
    case ReminderStatus.upcoming:
      final parts = <String>[
        if (e.daysRemaining != null) 'tra ${e.daysRemaining} giorni',
        if (e.kmRemaining != null) 'tra ${e.kmRemaining!.round()} km',
      ];
      return ('In arrivo ${parts.join(' / ')}', Colors.orange, Icons.schedule);
    case ReminderStatus.ok:
      return ('OK', Colors.green, Icons.check_circle);
    case ReminderStatus.completed:
      return ('Completata', cs.outline, Icons.done_all);
  }
}

class _ReminderCard extends ConsumerWidget {
  const _ReminderCard(this.eval, {required this.vehicleId});
  final ReminderEvaluation eval;
  final int vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final (label, color, icon) = _statusChip(eval, cs);
    final r = eval.reminder;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(r.title),
        subtitle: Text(
          label + (r.dueDate != null ? ' · ${fmtDate(r.dueDate!)}' : ''),
          style: TextStyle(color: color),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'complete') {
              _completeSheet(context, ref, r);
            } else if (v == 'edit') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ReminderFormScreen(initial: r),
                ),
              );
            } else if (v == 'delete') {
              ref.read(reminderRepositoryProvider).delete(r.id).then((_) {
                ref.read(reminderNotificationSchedulerProvider).cancel(r.id);
                ref.invalidate(reminderEvaluationsProvider(vehicleId));
                ref.invalidate(calendarEventsProvider(vehicleId));
              });
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'complete', child: Text('Completa')),
            PopupMenuItem(value: 'edit', child: Text('Modifica')),
            PopupMenuItem(value: 'delete', child: Text('Elimina')),
          ],
        ),
      ),
    );
  }

  Future<void> _completeSheet(
    BuildContext context,
    WidgetRef ref,
    Reminder r,
  ) async {
    final amount = TextEditingController();
    final odometer = TextEditingController();
    final needsOdo = r.triggerMode != TriggerMode.date;
    if (r.type == ReminderType.bollo && r.linkedExpenseCategoryId != null) {
      final vehicle = await ref
          .read(vehicleRepositoryProvider)
          .getById(vehicleId);
      final result = const BolloCalculator().computeForVehicle(vehicle);
      if (result != null) amount.text = _amountText(result.total);
    }
    if (needsOdo) {
      final current = await ref.read(currentOdometerProvider(vehicleId).future);
      if (current > 0) odometer.text = current.toStringAsFixed(0);
    }
    var createExpense = r.linkedExpenseCategoryId != null;
    var date = DateTime.now();
    String? amountError;
    if (!context.mounted) {
      amount.dispose();
      odometer.dispose();
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: StatefulBuilder(
          builder: (ctx, setSheet) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Completa: ${r.title}',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_available),
                title: Text('Data: ${fmtDate(date)}'),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setSheet(() => date = picked);
                },
              ),
              if (needsOdo)
                TextField(
                  controller: odometer,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Odometro attuale (km)',
                  ),
                ),
              if (r.linkedExpenseCategoryId != null) ...[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Registra anche la spesa'),
                  value: createExpense,
                  onChanged: (v) => setSheet(() {
                    createExpense = v;
                    if (!v) amountError = null;
                  }),
                ),
                if (createExpense)
                  TextField(
                    controller: amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Importo (€)',
                      errorText: amountError,
                    ),
                    onChanged: (_) {
                      if (amountError != null) {
                        setSheet(() => amountError = null);
                      }
                    },
                  ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  final expenseAmount = createExpense
                      ? _parse(amount.text)
                      : null;
                  if (createExpense &&
                      (expenseAmount == null || expenseAmount <= 0)) {
                    setSheet(() => amountError = 'Inserisci un importo valido');
                    return;
                  }
                  await ref
                      .read(reminderRepositoryProvider)
                      .complete(
                        r.id,
                        date: date,
                        odometer: _parse(odometer.text),
                        createExpense: createExpense,
                        expenseAmount: expenseAmount,
                      );
                  await ref
                      .read(reminderNotificationSchedulerProvider)
                      .rescheduleAll();
                  ref.invalidate(reminderEvaluationsProvider(vehicleId));
                  ref.invalidate(expensesForVehicleProvider(vehicleId));
                  ref.invalidate(calendarEventsProvider(vehicleId));
                  ref.invalidate(currentOdometerProvider(vehicleId));
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: const Text('Conferma'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
    amount.dispose();
    odometer.dispose();
  }
}
