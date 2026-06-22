import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/comparison.dart';
import '../../domain/models/cost_summary.dart';
import '../../domain/models/monthly_total.dart';
import '../../domain/services/range_comparator.dart';
import '../../providers.dart';
import '../expenses/expense_providers.dart';
import '../fillups/fillup_providers.dart';

part 'stats_providers.g.dart';

@riverpod
Future<List<MonthlyTotal>> monthlySpend(Ref ref, int vehicleId) async {
  final fills = await ref.watch(fillUpsProvider(vehicleId).future);
  return ref.watch(statsServiceProvider).monthlySpend(fills);
}

@riverpod
Future<CostSummary> costSummary(Ref ref, int vehicleId) async {
  final fills = await ref.watch(fillUpsProvider(vehicleId).future);
  final expenses = await ref.watch(
    expensesForVehicleProvider(vehicleId).future,
  );
  return ref.watch(statsServiceProvider).costSummary(fills, expenses);
}

@riverpod
Future<ConsumptionComparison> vehicleComparison(Ref ref, int vehicleId) async {
  final fills = await ref.watch(fillUpsProvider(vehicleId).future);
  final stats = ref.watch(statsServiceProvider).compute(fills);
  final vehicle = await ref.watch(vehicleRepositoryProvider).getById(vehicleId);
  return const RangeComparator().compare(stats, vehicle.specs);
}
