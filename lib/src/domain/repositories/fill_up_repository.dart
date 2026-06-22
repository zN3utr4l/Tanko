import '../models/fill_up.dart';

abstract class FillUpRepository {
  Future<List<FillUp>> forVehicle(int vehicleId);
  Future<List<FillUp>> all();
  Future<int> upsert(FillUp fillUp);
  Future<void> delete(int id);
}
