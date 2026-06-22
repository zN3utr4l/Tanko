import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/reminder_evaluation.dart';
import '../../providers.dart';
import '../expenses/expense_providers.dart';
import '../fillups/fillup_providers.dart';

part 'reminder_providers.g.dart';

/// Highest odometer seen across fuel-ups and expenses — the basis for
/// distance-based reminder evaluation.
@riverpod
Future<double> currentOdometer(Ref ref, int vehicleId) async {
  final fills = await ref.watch(fillUpsProvider(vehicleId).future);
  final expenses = await ref.watch(
    expensesForVehicleProvider(vehicleId).future,
  );
  final odos = <double>[
    ...fills.map((f) => f.odometer),
    ...expenses.where((e) => e.odometer != null).map((e) => e.odometer!),
  ];
  return odos.isEmpty ? 0 : odos.reduce(max);
}

@riverpod
Future<List<ReminderEvaluation>> reminderEvaluations(
  Ref ref,
  int vehicleId,
) async {
  final reminders = await ref
      .watch(reminderRepositoryProvider)
      .forVehicle(vehicleId);
  final odo = await ref.watch(currentOdometerProvider(vehicleId).future);
  final evaluator = ref.watch(reminderEvaluatorProvider);
  final today = DateTime.now();

  final evals = reminders
      .where((r) => r.active)
      .map((r) => evaluator.evaluate(r, today: today, currentOdometer: odo))
      .toList();

  int rank(ReminderStatus s) => switch (s) {
    ReminderStatus.overdue => 0,
    ReminderStatus.upcoming => 1,
    _ => 2,
  };
  evals.sort((a, b) => rank(a.status).compareTo(rank(b.status)));
  return evals;
}
