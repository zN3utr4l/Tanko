import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/category.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/fill_up.dart';
import '../../providers.dart';

part 'fillup_providers.g.dart';

@riverpod
Future<List<FillUp>> fillUps(Ref ref, int vehicleId) =>
    ref.watch(fillUpRepositoryProvider).forVehicle(vehicleId);

/// All categories (both kinds) — for id→name/colour lookups in lists/charts.
@riverpod
Future<List<Category>> allCategories(Ref ref) =>
    ref.watch(categoryRepositoryProvider).all();

/// Fuel categories only — for the fuel fill-up picker (never expense ones).
@riverpod
Future<List<Category>> fuelCategories(Ref ref) async {
  final all = await ref.watch(categoryRepositoryProvider).all();
  return all.where((c) => c.kind == CategoryKind.fuel).toList()
    ..sort((a, b) => a.ord.compareTo(b.ord));
}
