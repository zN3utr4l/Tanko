import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/vehicle.dart';
import '../../domain/models/vehicle_stats.dart';
import '../../providers.dart';
import '../fillups/fillup_providers.dart';
import '../vehicles/vehicle_providers.dart';

part 'dashboard_providers.g.dart';

/// The vehicle the dashboard (and every other vehicle-scoped screen) is bound
/// to: the default one if set, otherwise the first. Derived from
/// [vehiclesProvider] so adding/removing a vehicle refreshes all screens
/// through a single invalidation.
@riverpod
Future<Vehicle?> dashboardVehicle(Ref ref) async {
  final all = await ref.watch(vehiclesProvider.future);
  if (all.isEmpty) return null;
  return all.firstWhere((v) => v.isDefault, orElse: () => all.first);
}

@riverpod
Future<VehicleStats> vehicleStats(Ref ref, int vehicleId) async {
  final fills = await ref.watch(fillUpsProvider(vehicleId).future);
  return ref.watch(statsServiceProvider).compute(fills);
}
