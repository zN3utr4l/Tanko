import '../models/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> forVehicle(int vehicleId);
  Future<List<Expense>> all();
  Future<int> upsert(Expense expense);
  Future<void> delete(int id);
}
