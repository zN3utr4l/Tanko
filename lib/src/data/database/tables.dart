import 'package:drift/drift.dart';

@DataClassName('CategoryRow')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get color => integer()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  // 'fuel' | 'expense' — fuel categories and expense categories share this table.
  TextColumn get kind => text().withDefault(const Constant('fuel'))();
  IntColumn get iconCode => integer().nullable()();
  IntColumn get ord => integer().withDefault(const Constant(0))();
}

@DataClassName('VehicleRow')
class Vehicles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get make => text()();
  TextColumn get model => text()();
  IntColumn get year => integer().nullable()();
  TextColumn get trim => text().nullable()();
  TextColumn get fuelType => text()();
  TextColumn get plate => text().nullable()();
  TextColumn get euroClass => text().nullable()();
  IntColumn get colorTag => integer().withDefault(const Constant(0))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  RealColumn get tankCapacityL => real().nullable()();
  RealColumn get mfrConsumption => real().nullable()();
  RealColumn get mfrRangeKm => real().nullable()();
  IntColumn get powerPs => integer().nullable()();
  TextColumn get specSource => text().withDefault(const Constant('manual'))();
  TextColumn get catalogRef => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('FillUpRow')
class FillUps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();
  RealColumn get liters => real().nullable()();
  RealColumn get odometer => real()();
  BoolColumn get isFull => boolean().withDefault(const Constant(true))();
  RealColumn get rangeKm => real().nullable()();
  TextColumn get station => text().nullable()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get note => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get receiptPhotoPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// Declared before Expenses: Expenses.reminderId references Reminders.
@DataClassName('ReminderRow')
class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get triggerMode => text()(); // DATE | DISTANCE | BOTH
  DateTimeColumn get dueDate => dateTime().nullable()();
  RealColumn get dueOdometer => real().nullable()();
  IntColumn get recurEvery => integer().nullable()();
  TextColumn get recurUnit =>
      text().nullable()(); // DAY|MONTH|YEAR|KM|FIXED_DATE
  IntColumn get recurKmEvery => integer().nullable()();
  IntColumn get leadDays => integer().nullable()();
  IntColumn get leadKm => integer().nullable()();
  BoolColumn get notify => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastCompletedDate => dateTime().nullable()();
  RealColumn get lastCompletedOdometer => real().nullable()();
  IntColumn get linkedExpenseCategoryId => integer().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('ExpenseRow')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  RealColumn get odometer => real().nullable()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  RealColumn get amount => real()();
  TextColumn get description => text().nullable()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  IntColumn get reminderId => integer().nullable().references(
    Reminders,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get receiptPhotoPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
