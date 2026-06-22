import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/category.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/expense.dart';
import '../../providers.dart';

part 'expense_providers.g.dart';

@riverpod
Future<List<Expense>> expensesForVehicle(Ref ref, int vehicleId) =>
    ref.watch(expenseRepositoryProvider).forVehicle(vehicleId);

@riverpod
Future<List<Category>> expenseCategories(Ref ref) async {
  final all = await ref.watch(categoryRepositoryProvider).all();
  return all.where((c) => c.kind == CategoryKind.expense).toList()
    ..sort((a, b) => a.ord.compareTo(b.ord));
}
