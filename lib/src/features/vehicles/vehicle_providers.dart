import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/vehicle.dart';
import '../../providers.dart';

part 'vehicle_providers.g.dart';

@riverpod
Future<List<Vehicle>> vehicles(Ref ref) =>
    ref.watch(vehicleRepositoryProvider).all();
