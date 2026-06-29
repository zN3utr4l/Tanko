import 'package:flutter/material.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/reminder.dart';
import '../../domain/services/reminder_evaluator.dart';

/// Pre-seeded Italian scadenze. Picking one pre-fills an editable reminder form.
class ReminderTemplate {
  const ReminderTemplate({
    required this.label,
    required this.icon,
    required this.type,
    required this.triggerMode,
    this.recurEvery,
    this.recurUnit,
    this.recurKmEvery,
    this.leadDays,
    this.leadKm,
    this.fixedMonth,
    this.fixedDay,
    this.linkedExpenseCategoryName,
  });

  final String label;
  final IconData icon;
  final ReminderType type;
  final TriggerMode triggerMode;
  final int? recurEvery;
  final RecurUnit? recurUnit;
  final int? recurKmEvery;
  final int? leadDays;
  final int? leadKm;
  final int? fixedMonth;
  final int? fixedDay;
  final String? linkedExpenseCategoryName;

  /// Builds an editable draft anchored to [now] (id 0 = new).
  Reminder draft(int vehicleId, DateTime now, {int? linkedExpenseCategoryId}) {
    DateTime? due;
    if (recurUnit == RecurUnit.fixedDate &&
        fixedMonth != null &&
        fixedDay != null) {
      due = DateTime(now.year, fixedMonth!, fixedDay!);
      if (!due.isAfter(now)) {
        due = DateTime(now.year + 1, fixedMonth!, fixedDay!);
      }
    } else if (triggerMode != TriggerMode.distance) {
      due = switch (recurUnit) {
        RecurUnit.year => ReminderEvaluator.addMonths(
          now,
          12 * (recurEvery ?? 1),
        ),
        RecurUnit.month => ReminderEvaluator.addMonths(now, recurEvery ?? 1),
        _ => ReminderEvaluator.addMonths(now, 12),
      };
    }
    return Reminder(
      id: 0,
      vehicleId: vehicleId,
      type: type,
      title: label,
      triggerMode: triggerMode,
      dueDate: due,
      recurEvery: recurEvery,
      recurUnit: recurUnit,
      recurKmEvery: recurKmEvery,
      leadDays: leadDays,
      leadKm: leadKm,
      linkedExpenseCategoryId: linkedExpenseCategoryId,
      createdAt: now,
      updatedAt: now,
    );
  }
}

const reminderTemplates = <ReminderTemplate>[
  ReminderTemplate(
    label: 'Revisione',
    icon: Icons.build,
    type: ReminderType.revisione,
    triggerMode: TriggerMode.date,
    recurEvery: 2,
    recurUnit: RecurUnit.year,
    leadDays: 30,
    linkedExpenseCategoryName: 'Revisione',
  ),
  ReminderTemplate(
    label: 'Bollo auto',
    icon: Icons.receipt_long,
    type: ReminderType.bollo,
    triggerMode: TriggerMode.date,
    recurEvery: 1,
    recurUnit: RecurUnit.year,
    leadDays: 30,
    linkedExpenseCategoryName: 'Bollo',
  ),
  ReminderTemplate(
    label: 'Assicurazione RCA',
    icon: Icons.shield,
    type: ReminderType.assicurazione,
    triggerMode: TriggerMode.date,
    recurEvery: 1,
    recurUnit: RecurUnit.year,
    leadDays: 45,
    linkedExpenseCategoryName: 'Assicurazione',
  ),
  ReminderTemplate(
    label: 'Tagliando',
    icon: Icons.car_repair,
    type: ReminderType.tagliando,
    triggerMode: TriggerMode.both,
    recurEvery: 2,
    recurUnit: RecurUnit.year,
    recurKmEvery: 20000,
    leadDays: 30,
    leadKm: 1000,
    linkedExpenseCategoryName: 'Tagliando',
  ),
  ReminderTemplate(
    label: 'Cambio gomme estive',
    icon: Icons.ac_unit,
    type: ReminderType.gomme,
    triggerMode: TriggerMode.date,
    recurUnit: RecurUnit.fixedDate,
    fixedMonth: 4,
    fixedDay: 15,
    leadDays: 14,
    linkedExpenseCategoryName: 'Cambio gomme',
  ),
  ReminderTemplate(
    label: 'Cambio gomme invernali',
    icon: Icons.snowing,
    type: ReminderType.gomme,
    triggerMode: TriggerMode.date,
    recurUnit: RecurUnit.fixedDate,
    fixedMonth: 11,
    fixedDay: 15,
    leadDays: 14,
    linkedExpenseCategoryName: 'Cambio gomme',
  ),
  ReminderTemplate(
    label: 'Personalizzata',
    icon: Icons.notifications,
    type: ReminderType.custom,
    triggerMode: TriggerMode.date,
    leadDays: 14,
  ),
];
