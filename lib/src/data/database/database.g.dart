// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fuel'),
  );
  static const VerificationMeta _iconCodeMeta = const VerificationMeta(
    'iconCode',
  );
  @override
  late final GeneratedColumn<int> iconCode = GeneratedColumn<int>(
    'icon_code',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ordMeta = const VerificationMeta('ord');
  @override
  late final GeneratedColumn<int> ord = GeneratedColumn<int>(
    'ord',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    color,
    isDefault,
    kind,
    iconCode,
    ord,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('icon_code')) {
      context.handle(
        _iconCodeMeta,
        iconCode.isAcceptableOrUnknown(data['icon_code']!, _iconCodeMeta),
      );
    }
    if (data.containsKey('ord')) {
      context.handle(
        _ordMeta,
        ord.isAcceptableOrUnknown(data['ord']!, _ordMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      iconCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon_code'],
      ),
      ord: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ord'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final int id;
  final String name;
  final int color;
  final bool isDefault;
  final String kind;
  final int? iconCode;
  final int ord;
  const CategoryRow({
    required this.id,
    required this.name,
    required this.color,
    required this.isDefault,
    required this.kind,
    this.iconCode,
    required this.ord,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['is_default'] = Variable<bool>(isDefault);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || iconCode != null) {
      map['icon_code'] = Variable<int>(iconCode);
    }
    map['ord'] = Variable<int>(ord);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      isDefault: Value(isDefault),
      kind: Value(kind),
      iconCode: iconCode == null && nullToAbsent
          ? const Value.absent()
          : Value(iconCode),
      ord: Value(ord),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      kind: serializer.fromJson<String>(json['kind']),
      iconCode: serializer.fromJson<int?>(json['iconCode']),
      ord: serializer.fromJson<int>(json['ord']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'isDefault': serializer.toJson<bool>(isDefault),
      'kind': serializer.toJson<String>(kind),
      'iconCode': serializer.toJson<int?>(iconCode),
      'ord': serializer.toJson<int>(ord),
    };
  }

  CategoryRow copyWith({
    int? id,
    String? name,
    int? color,
    bool? isDefault,
    String? kind,
    Value<int?> iconCode = const Value.absent(),
    int? ord,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    isDefault: isDefault ?? this.isDefault,
    kind: kind ?? this.kind,
    iconCode: iconCode.present ? iconCode.value : this.iconCode,
    ord: ord ?? this.ord,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      kind: data.kind.present ? data.kind.value : this.kind,
      iconCode: data.iconCode.present ? data.iconCode.value : this.iconCode,
      ord: data.ord.present ? data.ord.value : this.ord,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('kind: $kind, ')
          ..write('iconCode: $iconCode, ')
          ..write('ord: $ord')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, color, isDefault, kind, iconCode, ord);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.isDefault == this.isDefault &&
          other.kind == this.kind &&
          other.iconCode == this.iconCode &&
          other.ord == this.ord);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  final Value<bool> isDefault;
  final Value<String> kind;
  final Value<int?> iconCode;
  final Value<int> ord;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.kind = const Value.absent(),
    this.iconCode = const Value.absent(),
    this.ord = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int color,
    this.isDefault = const Value.absent(),
    this.kind = const Value.absent(),
    this.iconCode = const Value.absent(),
    this.ord = const Value.absent(),
  }) : name = Value(name),
       color = Value(color);
  static Insertable<CategoryRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<bool>? isDefault,
    Expression<String>? kind,
    Expression<int>? iconCode,
    Expression<int>? ord,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (isDefault != null) 'is_default': isDefault,
      if (kind != null) 'kind': kind,
      if (iconCode != null) 'icon_code': iconCode,
      if (ord != null) 'ord': ord,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? color,
    Value<bool>? isDefault,
    Value<String>? kind,
    Value<int?>? iconCode,
    Value<int>? ord,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      kind: kind ?? this.kind,
      iconCode: iconCode ?? this.iconCode,
      ord: ord ?? this.ord,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (iconCode.present) {
      map['icon_code'] = Variable<int>(iconCode.value);
    }
    if (ord.present) {
      map['ord'] = Variable<int>(ord.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('kind: $kind, ')
          ..write('iconCode: $iconCode, ')
          ..write('ord: $ord')
          ..write(')'))
        .toString();
  }
}

class $VehiclesTable extends Vehicles
    with TableInfo<$VehiclesTable, VehicleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _makeMeta = const VerificationMeta('make');
  @override
  late final GeneratedColumn<String> make = GeneratedColumn<String>(
    'make',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trimMeta = const VerificationMeta('trim');
  @override
  late final GeneratedColumn<String> trim = GeneratedColumn<String>(
    'trim',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fuelTypeMeta = const VerificationMeta(
    'fuelType',
  );
  @override
  late final GeneratedColumn<String> fuelType = GeneratedColumn<String>(
    'fuel_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plateMeta = const VerificationMeta('plate');
  @override
  late final GeneratedColumn<String> plate = GeneratedColumn<String>(
    'plate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _euroClassMeta = const VerificationMeta(
    'euroClass',
  );
  @override
  late final GeneratedColumn<String> euroClass = GeneratedColumn<String>(
    'euro_class',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorTagMeta = const VerificationMeta(
    'colorTag',
  );
  @override
  late final GeneratedColumn<int> colorTag = GeneratedColumn<int>(
    'color_tag',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tankCapacityLMeta = const VerificationMeta(
    'tankCapacityL',
  );
  @override
  late final GeneratedColumn<double> tankCapacityL = GeneratedColumn<double>(
    'tank_capacity_l',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mfrConsumptionMeta = const VerificationMeta(
    'mfrConsumption',
  );
  @override
  late final GeneratedColumn<double> mfrConsumption = GeneratedColumn<double>(
    'mfr_consumption',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mfrRangeKmMeta = const VerificationMeta(
    'mfrRangeKm',
  );
  @override
  late final GeneratedColumn<double> mfrRangeKm = GeneratedColumn<double>(
    'mfr_range_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _powerPsMeta = const VerificationMeta(
    'powerPs',
  );
  @override
  late final GeneratedColumn<int> powerPs = GeneratedColumn<int>(
    'power_ps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _specSourceMeta = const VerificationMeta(
    'specSource',
  );
  @override
  late final GeneratedColumn<String> specSource = GeneratedColumn<String>(
    'spec_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _catalogRefMeta = const VerificationMeta(
    'catalogRef',
  );
  @override
  late final GeneratedColumn<String> catalogRef = GeneratedColumn<String>(
    'catalog_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    make,
    model,
    year,
    trim,
    fuelType,
    plate,
    euroClass,
    colorTag,
    isDefault,
    tankCapacityL,
    mfrConsumption,
    mfrRangeKm,
    powerPs,
    specSource,
    catalogRef,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<VehicleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('make')) {
      context.handle(
        _makeMeta,
        make.isAcceptableOrUnknown(data['make']!, _makeMeta),
      );
    } else if (isInserting) {
      context.missing(_makeMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('trim')) {
      context.handle(
        _trimMeta,
        trim.isAcceptableOrUnknown(data['trim']!, _trimMeta),
      );
    }
    if (data.containsKey('fuel_type')) {
      context.handle(
        _fuelTypeMeta,
        fuelType.isAcceptableOrUnknown(data['fuel_type']!, _fuelTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fuelTypeMeta);
    }
    if (data.containsKey('plate')) {
      context.handle(
        _plateMeta,
        plate.isAcceptableOrUnknown(data['plate']!, _plateMeta),
      );
    }
    if (data.containsKey('euro_class')) {
      context.handle(
        _euroClassMeta,
        euroClass.isAcceptableOrUnknown(data['euro_class']!, _euroClassMeta),
      );
    }
    if (data.containsKey('color_tag')) {
      context.handle(
        _colorTagMeta,
        colorTag.isAcceptableOrUnknown(data['color_tag']!, _colorTagMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('tank_capacity_l')) {
      context.handle(
        _tankCapacityLMeta,
        tankCapacityL.isAcceptableOrUnknown(
          data['tank_capacity_l']!,
          _tankCapacityLMeta,
        ),
      );
    }
    if (data.containsKey('mfr_consumption')) {
      context.handle(
        _mfrConsumptionMeta,
        mfrConsumption.isAcceptableOrUnknown(
          data['mfr_consumption']!,
          _mfrConsumptionMeta,
        ),
      );
    }
    if (data.containsKey('mfr_range_km')) {
      context.handle(
        _mfrRangeKmMeta,
        mfrRangeKm.isAcceptableOrUnknown(
          data['mfr_range_km']!,
          _mfrRangeKmMeta,
        ),
      );
    }
    if (data.containsKey('power_ps')) {
      context.handle(
        _powerPsMeta,
        powerPs.isAcceptableOrUnknown(data['power_ps']!, _powerPsMeta),
      );
    }
    if (data.containsKey('spec_source')) {
      context.handle(
        _specSourceMeta,
        specSource.isAcceptableOrUnknown(data['spec_source']!, _specSourceMeta),
      );
    }
    if (data.containsKey('catalog_ref')) {
      context.handle(
        _catalogRefMeta,
        catalogRef.isAcceptableOrUnknown(data['catalog_ref']!, _catalogRefMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VehicleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VehicleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      make: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}make'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      trim: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trim'],
      ),
      fuelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel_type'],
      )!,
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      ),
      euroClass: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}euro_class'],
      ),
      colorTag: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_tag'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      tankCapacityL: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tank_capacity_l'],
      ),
      mfrConsumption: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mfr_consumption'],
      ),
      mfrRangeKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mfr_range_km'],
      ),
      powerPs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}power_ps'],
      ),
      specSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spec_source'],
      )!,
      catalogRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_ref'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class VehicleRow extends DataClass implements Insertable<VehicleRow> {
  final int id;
  final String make;
  final String model;
  final int? year;
  final String? trim;
  final String fuelType;
  final String? plate;
  final String? euroClass;
  final int colorTag;
  final bool isDefault;
  final double? tankCapacityL;
  final double? mfrConsumption;
  final double? mfrRangeKm;
  final int? powerPs;
  final String specSource;
  final String? catalogRef;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VehicleRow({
    required this.id,
    required this.make,
    required this.model,
    this.year,
    this.trim,
    required this.fuelType,
    this.plate,
    this.euroClass,
    required this.colorTag,
    required this.isDefault,
    this.tankCapacityL,
    this.mfrConsumption,
    this.mfrRangeKm,
    this.powerPs,
    required this.specSource,
    this.catalogRef,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['make'] = Variable<String>(make);
    map['model'] = Variable<String>(model);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || trim != null) {
      map['trim'] = Variable<String>(trim);
    }
    map['fuel_type'] = Variable<String>(fuelType);
    if (!nullToAbsent || plate != null) {
      map['plate'] = Variable<String>(plate);
    }
    if (!nullToAbsent || euroClass != null) {
      map['euro_class'] = Variable<String>(euroClass);
    }
    map['color_tag'] = Variable<int>(colorTag);
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || tankCapacityL != null) {
      map['tank_capacity_l'] = Variable<double>(tankCapacityL);
    }
    if (!nullToAbsent || mfrConsumption != null) {
      map['mfr_consumption'] = Variable<double>(mfrConsumption);
    }
    if (!nullToAbsent || mfrRangeKm != null) {
      map['mfr_range_km'] = Variable<double>(mfrRangeKm);
    }
    if (!nullToAbsent || powerPs != null) {
      map['power_ps'] = Variable<int>(powerPs);
    }
    map['spec_source'] = Variable<String>(specSource);
    if (!nullToAbsent || catalogRef != null) {
      map['catalog_ref'] = Variable<String>(catalogRef);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      make: Value(make),
      model: Value(model),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      trim: trim == null && nullToAbsent ? const Value.absent() : Value(trim),
      fuelType: Value(fuelType),
      plate: plate == null && nullToAbsent
          ? const Value.absent()
          : Value(plate),
      euroClass: euroClass == null && nullToAbsent
          ? const Value.absent()
          : Value(euroClass),
      colorTag: Value(colorTag),
      isDefault: Value(isDefault),
      tankCapacityL: tankCapacityL == null && nullToAbsent
          ? const Value.absent()
          : Value(tankCapacityL),
      mfrConsumption: mfrConsumption == null && nullToAbsent
          ? const Value.absent()
          : Value(mfrConsumption),
      mfrRangeKm: mfrRangeKm == null && nullToAbsent
          ? const Value.absent()
          : Value(mfrRangeKm),
      powerPs: powerPs == null && nullToAbsent
          ? const Value.absent()
          : Value(powerPs),
      specSource: Value(specSource),
      catalogRef: catalogRef == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogRef),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VehicleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VehicleRow(
      id: serializer.fromJson<int>(json['id']),
      make: serializer.fromJson<String>(json['make']),
      model: serializer.fromJson<String>(json['model']),
      year: serializer.fromJson<int?>(json['year']),
      trim: serializer.fromJson<String?>(json['trim']),
      fuelType: serializer.fromJson<String>(json['fuelType']),
      plate: serializer.fromJson<String?>(json['plate']),
      euroClass: serializer.fromJson<String?>(json['euroClass']),
      colorTag: serializer.fromJson<int>(json['colorTag']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      tankCapacityL: serializer.fromJson<double?>(json['tankCapacityL']),
      mfrConsumption: serializer.fromJson<double?>(json['mfrConsumption']),
      mfrRangeKm: serializer.fromJson<double?>(json['mfrRangeKm']),
      powerPs: serializer.fromJson<int?>(json['powerPs']),
      specSource: serializer.fromJson<String>(json['specSource']),
      catalogRef: serializer.fromJson<String?>(json['catalogRef']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'make': serializer.toJson<String>(make),
      'model': serializer.toJson<String>(model),
      'year': serializer.toJson<int?>(year),
      'trim': serializer.toJson<String?>(trim),
      'fuelType': serializer.toJson<String>(fuelType),
      'plate': serializer.toJson<String?>(plate),
      'euroClass': serializer.toJson<String?>(euroClass),
      'colorTag': serializer.toJson<int>(colorTag),
      'isDefault': serializer.toJson<bool>(isDefault),
      'tankCapacityL': serializer.toJson<double?>(tankCapacityL),
      'mfrConsumption': serializer.toJson<double?>(mfrConsumption),
      'mfrRangeKm': serializer.toJson<double?>(mfrRangeKm),
      'powerPs': serializer.toJson<int?>(powerPs),
      'specSource': serializer.toJson<String>(specSource),
      'catalogRef': serializer.toJson<String?>(catalogRef),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VehicleRow copyWith({
    int? id,
    String? make,
    String? model,
    Value<int?> year = const Value.absent(),
    Value<String?> trim = const Value.absent(),
    String? fuelType,
    Value<String?> plate = const Value.absent(),
    Value<String?> euroClass = const Value.absent(),
    int? colorTag,
    bool? isDefault,
    Value<double?> tankCapacityL = const Value.absent(),
    Value<double?> mfrConsumption = const Value.absent(),
    Value<double?> mfrRangeKm = const Value.absent(),
    Value<int?> powerPs = const Value.absent(),
    String? specSource,
    Value<String?> catalogRef = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VehicleRow(
    id: id ?? this.id,
    make: make ?? this.make,
    model: model ?? this.model,
    year: year.present ? year.value : this.year,
    trim: trim.present ? trim.value : this.trim,
    fuelType: fuelType ?? this.fuelType,
    plate: plate.present ? plate.value : this.plate,
    euroClass: euroClass.present ? euroClass.value : this.euroClass,
    colorTag: colorTag ?? this.colorTag,
    isDefault: isDefault ?? this.isDefault,
    tankCapacityL: tankCapacityL.present
        ? tankCapacityL.value
        : this.tankCapacityL,
    mfrConsumption: mfrConsumption.present
        ? mfrConsumption.value
        : this.mfrConsumption,
    mfrRangeKm: mfrRangeKm.present ? mfrRangeKm.value : this.mfrRangeKm,
    powerPs: powerPs.present ? powerPs.value : this.powerPs,
    specSource: specSource ?? this.specSource,
    catalogRef: catalogRef.present ? catalogRef.value : this.catalogRef,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VehicleRow copyWithCompanion(VehiclesCompanion data) {
    return VehicleRow(
      id: data.id.present ? data.id.value : this.id,
      make: data.make.present ? data.make.value : this.make,
      model: data.model.present ? data.model.value : this.model,
      year: data.year.present ? data.year.value : this.year,
      trim: data.trim.present ? data.trim.value : this.trim,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      plate: data.plate.present ? data.plate.value : this.plate,
      euroClass: data.euroClass.present ? data.euroClass.value : this.euroClass,
      colorTag: data.colorTag.present ? data.colorTag.value : this.colorTag,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      tankCapacityL: data.tankCapacityL.present
          ? data.tankCapacityL.value
          : this.tankCapacityL,
      mfrConsumption: data.mfrConsumption.present
          ? data.mfrConsumption.value
          : this.mfrConsumption,
      mfrRangeKm: data.mfrRangeKm.present
          ? data.mfrRangeKm.value
          : this.mfrRangeKm,
      powerPs: data.powerPs.present ? data.powerPs.value : this.powerPs,
      specSource: data.specSource.present
          ? data.specSource.value
          : this.specSource,
      catalogRef: data.catalogRef.present
          ? data.catalogRef.value
          : this.catalogRef,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehicleRow(')
          ..write('id: $id, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('trim: $trim, ')
          ..write('fuelType: $fuelType, ')
          ..write('plate: $plate, ')
          ..write('euroClass: $euroClass, ')
          ..write('colorTag: $colorTag, ')
          ..write('isDefault: $isDefault, ')
          ..write('tankCapacityL: $tankCapacityL, ')
          ..write('mfrConsumption: $mfrConsumption, ')
          ..write('mfrRangeKm: $mfrRangeKm, ')
          ..write('powerPs: $powerPs, ')
          ..write('specSource: $specSource, ')
          ..write('catalogRef: $catalogRef, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    make,
    model,
    year,
    trim,
    fuelType,
    plate,
    euroClass,
    colorTag,
    isDefault,
    tankCapacityL,
    mfrConsumption,
    mfrRangeKm,
    powerPs,
    specSource,
    catalogRef,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehicleRow &&
          other.id == this.id &&
          other.make == this.make &&
          other.model == this.model &&
          other.year == this.year &&
          other.trim == this.trim &&
          other.fuelType == this.fuelType &&
          other.plate == this.plate &&
          other.euroClass == this.euroClass &&
          other.colorTag == this.colorTag &&
          other.isDefault == this.isDefault &&
          other.tankCapacityL == this.tankCapacityL &&
          other.mfrConsumption == this.mfrConsumption &&
          other.mfrRangeKm == this.mfrRangeKm &&
          other.powerPs == this.powerPs &&
          other.specSource == this.specSource &&
          other.catalogRef == this.catalogRef &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VehiclesCompanion extends UpdateCompanion<VehicleRow> {
  final Value<int> id;
  final Value<String> make;
  final Value<String> model;
  final Value<int?> year;
  final Value<String?> trim;
  final Value<String> fuelType;
  final Value<String?> plate;
  final Value<String?> euroClass;
  final Value<int> colorTag;
  final Value<bool> isDefault;
  final Value<double?> tankCapacityL;
  final Value<double?> mfrConsumption;
  final Value<double?> mfrRangeKm;
  final Value<int?> powerPs;
  final Value<String> specSource;
  final Value<String?> catalogRef;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.trim = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.plate = const Value.absent(),
    this.euroClass = const Value.absent(),
    this.colorTag = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.tankCapacityL = const Value.absent(),
    this.mfrConsumption = const Value.absent(),
    this.mfrRangeKm = const Value.absent(),
    this.powerPs = const Value.absent(),
    this.specSource = const Value.absent(),
    this.catalogRef = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VehiclesCompanion.insert({
    this.id = const Value.absent(),
    required String make,
    required String model,
    this.year = const Value.absent(),
    this.trim = const Value.absent(),
    required String fuelType,
    this.plate = const Value.absent(),
    this.euroClass = const Value.absent(),
    this.colorTag = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.tankCapacityL = const Value.absent(),
    this.mfrConsumption = const Value.absent(),
    this.mfrRangeKm = const Value.absent(),
    this.powerPs = const Value.absent(),
    this.specSource = const Value.absent(),
    this.catalogRef = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : make = Value(make),
       model = Value(model),
       fuelType = Value(fuelType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VehicleRow> custom({
    Expression<int>? id,
    Expression<String>? make,
    Expression<String>? model,
    Expression<int>? year,
    Expression<String>? trim,
    Expression<String>? fuelType,
    Expression<String>? plate,
    Expression<String>? euroClass,
    Expression<int>? colorTag,
    Expression<bool>? isDefault,
    Expression<double>? tankCapacityL,
    Expression<double>? mfrConsumption,
    Expression<double>? mfrRangeKm,
    Expression<int>? powerPs,
    Expression<String>? specSource,
    Expression<String>? catalogRef,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (trim != null) 'trim': trim,
      if (fuelType != null) 'fuel_type': fuelType,
      if (plate != null) 'plate': plate,
      if (euroClass != null) 'euro_class': euroClass,
      if (colorTag != null) 'color_tag': colorTag,
      if (isDefault != null) 'is_default': isDefault,
      if (tankCapacityL != null) 'tank_capacity_l': tankCapacityL,
      if (mfrConsumption != null) 'mfr_consumption': mfrConsumption,
      if (mfrRangeKm != null) 'mfr_range_km': mfrRangeKm,
      if (powerPs != null) 'power_ps': powerPs,
      if (specSource != null) 'spec_source': specSource,
      if (catalogRef != null) 'catalog_ref': catalogRef,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VehiclesCompanion copyWith({
    Value<int>? id,
    Value<String>? make,
    Value<String>? model,
    Value<int?>? year,
    Value<String?>? trim,
    Value<String>? fuelType,
    Value<String?>? plate,
    Value<String?>? euroClass,
    Value<int>? colorTag,
    Value<bool>? isDefault,
    Value<double?>? tankCapacityL,
    Value<double?>? mfrConsumption,
    Value<double?>? mfrRangeKm,
    Value<int?>? powerPs,
    Value<String>? specSource,
    Value<String?>? catalogRef,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      trim: trim ?? this.trim,
      fuelType: fuelType ?? this.fuelType,
      plate: plate ?? this.plate,
      euroClass: euroClass ?? this.euroClass,
      colorTag: colorTag ?? this.colorTag,
      isDefault: isDefault ?? this.isDefault,
      tankCapacityL: tankCapacityL ?? this.tankCapacityL,
      mfrConsumption: mfrConsumption ?? this.mfrConsumption,
      mfrRangeKm: mfrRangeKm ?? this.mfrRangeKm,
      powerPs: powerPs ?? this.powerPs,
      specSource: specSource ?? this.specSource,
      catalogRef: catalogRef ?? this.catalogRef,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (make.present) {
      map['make'] = Variable<String>(make.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (trim.present) {
      map['trim'] = Variable<String>(trim.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(fuelType.value);
    }
    if (plate.present) {
      map['plate'] = Variable<String>(plate.value);
    }
    if (euroClass.present) {
      map['euro_class'] = Variable<String>(euroClass.value);
    }
    if (colorTag.present) {
      map['color_tag'] = Variable<int>(colorTag.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (tankCapacityL.present) {
      map['tank_capacity_l'] = Variable<double>(tankCapacityL.value);
    }
    if (mfrConsumption.present) {
      map['mfr_consumption'] = Variable<double>(mfrConsumption.value);
    }
    if (mfrRangeKm.present) {
      map['mfr_range_km'] = Variable<double>(mfrRangeKm.value);
    }
    if (powerPs.present) {
      map['power_ps'] = Variable<int>(powerPs.value);
    }
    if (specSource.present) {
      map['spec_source'] = Variable<String>(specSource.value);
    }
    if (catalogRef.present) {
      map['catalog_ref'] = Variable<String>(catalogRef.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('trim: $trim, ')
          ..write('fuelType: $fuelType, ')
          ..write('plate: $plate, ')
          ..write('euroClass: $euroClass, ')
          ..write('colorTag: $colorTag, ')
          ..write('isDefault: $isDefault, ')
          ..write('tankCapacityL: $tankCapacityL, ')
          ..write('mfrConsumption: $mfrConsumption, ')
          ..write('mfrRangeKm: $mfrRangeKm, ')
          ..write('powerPs: $powerPs, ')
          ..write('specSource: $specSource, ')
          ..write('catalogRef: $catalogRef, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, ReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggerModeMeta = const VerificationMeta(
    'triggerMode',
  );
  @override
  late final GeneratedColumn<String> triggerMode = GeneratedColumn<String>(
    'trigger_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueOdometerMeta = const VerificationMeta(
    'dueOdometer',
  );
  @override
  late final GeneratedColumn<double> dueOdometer = GeneratedColumn<double>(
    'due_odometer',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurEveryMeta = const VerificationMeta(
    'recurEvery',
  );
  @override
  late final GeneratedColumn<int> recurEvery = GeneratedColumn<int>(
    'recur_every',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurUnitMeta = const VerificationMeta(
    'recurUnit',
  );
  @override
  late final GeneratedColumn<String> recurUnit = GeneratedColumn<String>(
    'recur_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurKmEveryMeta = const VerificationMeta(
    'recurKmEvery',
  );
  @override
  late final GeneratedColumn<int> recurKmEvery = GeneratedColumn<int>(
    'recur_km_every',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leadDaysMeta = const VerificationMeta(
    'leadDays',
  );
  @override
  late final GeneratedColumn<int> leadDays = GeneratedColumn<int>(
    'lead_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leadKmMeta = const VerificationMeta('leadKm');
  @override
  late final GeneratedColumn<int> leadKm = GeneratedColumn<int>(
    'lead_km',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notifyMeta = const VerificationMeta('notify');
  @override
  late final GeneratedColumn<bool> notify = GeneratedColumn<bool>(
    'notify',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastCompletedDateMeta = const VerificationMeta(
    'lastCompletedDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastCompletedDate =
      GeneratedColumn<DateTime>(
        'last_completed_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastCompletedOdometerMeta =
      const VerificationMeta('lastCompletedOdometer');
  @override
  late final GeneratedColumn<double> lastCompletedOdometer =
      GeneratedColumn<double>(
        'last_completed_odometer',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _linkedExpenseCategoryIdMeta =
      const VerificationMeta('linkedExpenseCategoryId');
  @override
  late final GeneratedColumn<int> linkedExpenseCategoryId =
      GeneratedColumn<int>(
        'linked_expense_category_id',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    type,
    title,
    triggerMode,
    dueDate,
    dueOdometer,
    recurEvery,
    recurUnit,
    recurKmEvery,
    leadDays,
    leadKm,
    notify,
    lastCompletedDate,
    lastCompletedOdometer,
    linkedExpenseCategoryId,
    active,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('trigger_mode')) {
      context.handle(
        _triggerModeMeta,
        triggerMode.isAcceptableOrUnknown(
          data['trigger_mode']!,
          _triggerModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_triggerModeMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('due_odometer')) {
      context.handle(
        _dueOdometerMeta,
        dueOdometer.isAcceptableOrUnknown(
          data['due_odometer']!,
          _dueOdometerMeta,
        ),
      );
    }
    if (data.containsKey('recur_every')) {
      context.handle(
        _recurEveryMeta,
        recurEvery.isAcceptableOrUnknown(data['recur_every']!, _recurEveryMeta),
      );
    }
    if (data.containsKey('recur_unit')) {
      context.handle(
        _recurUnitMeta,
        recurUnit.isAcceptableOrUnknown(data['recur_unit']!, _recurUnitMeta),
      );
    }
    if (data.containsKey('recur_km_every')) {
      context.handle(
        _recurKmEveryMeta,
        recurKmEvery.isAcceptableOrUnknown(
          data['recur_km_every']!,
          _recurKmEveryMeta,
        ),
      );
    }
    if (data.containsKey('lead_days')) {
      context.handle(
        _leadDaysMeta,
        leadDays.isAcceptableOrUnknown(data['lead_days']!, _leadDaysMeta),
      );
    }
    if (data.containsKey('lead_km')) {
      context.handle(
        _leadKmMeta,
        leadKm.isAcceptableOrUnknown(data['lead_km']!, _leadKmMeta),
      );
    }
    if (data.containsKey('notify')) {
      context.handle(
        _notifyMeta,
        notify.isAcceptableOrUnknown(data['notify']!, _notifyMeta),
      );
    }
    if (data.containsKey('last_completed_date')) {
      context.handle(
        _lastCompletedDateMeta,
        lastCompletedDate.isAcceptableOrUnknown(
          data['last_completed_date']!,
          _lastCompletedDateMeta,
        ),
      );
    }
    if (data.containsKey('last_completed_odometer')) {
      context.handle(
        _lastCompletedOdometerMeta,
        lastCompletedOdometer.isAcceptableOrUnknown(
          data['last_completed_odometer']!,
          _lastCompletedOdometerMeta,
        ),
      );
    }
    if (data.containsKey('linked_expense_category_id')) {
      context.handle(
        _linkedExpenseCategoryIdMeta,
        linkedExpenseCategoryId.isAcceptableOrUnknown(
          data['linked_expense_category_id']!,
          _linkedExpenseCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      triggerMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger_mode'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      dueOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}due_odometer'],
      ),
      recurEvery: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recur_every'],
      ),
      recurUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recur_unit'],
      ),
      recurKmEvery: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recur_km_every'],
      ),
      leadDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lead_days'],
      ),
      leadKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lead_km'],
      ),
      notify: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify'],
      )!,
      lastCompletedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_completed_date'],
      ),
      lastCompletedOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_completed_odometer'],
      ),
      linkedExpenseCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}linked_expense_category_id'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class ReminderRow extends DataClass implements Insertable<ReminderRow> {
  final int id;
  final int vehicleId;
  final String type;
  final String title;
  final String triggerMode;
  final DateTime? dueDate;
  final double? dueOdometer;
  final int? recurEvery;
  final String? recurUnit;
  final int? recurKmEvery;
  final int? leadDays;
  final int? leadKm;
  final bool notify;
  final DateTime? lastCompletedDate;
  final double? lastCompletedOdometer;
  final int? linkedExpenseCategoryId;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ReminderRow({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.title,
    required this.triggerMode,
    this.dueDate,
    this.dueOdometer,
    this.recurEvery,
    this.recurUnit,
    this.recurKmEvery,
    this.leadDays,
    this.leadKm,
    required this.notify,
    this.lastCompletedDate,
    this.lastCompletedOdometer,
    this.linkedExpenseCategoryId,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['trigger_mode'] = Variable<String>(triggerMode);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || dueOdometer != null) {
      map['due_odometer'] = Variable<double>(dueOdometer);
    }
    if (!nullToAbsent || recurEvery != null) {
      map['recur_every'] = Variable<int>(recurEvery);
    }
    if (!nullToAbsent || recurUnit != null) {
      map['recur_unit'] = Variable<String>(recurUnit);
    }
    if (!nullToAbsent || recurKmEvery != null) {
      map['recur_km_every'] = Variable<int>(recurKmEvery);
    }
    if (!nullToAbsent || leadDays != null) {
      map['lead_days'] = Variable<int>(leadDays);
    }
    if (!nullToAbsent || leadKm != null) {
      map['lead_km'] = Variable<int>(leadKm);
    }
    map['notify'] = Variable<bool>(notify);
    if (!nullToAbsent || lastCompletedDate != null) {
      map['last_completed_date'] = Variable<DateTime>(lastCompletedDate);
    }
    if (!nullToAbsent || lastCompletedOdometer != null) {
      map['last_completed_odometer'] = Variable<double>(lastCompletedOdometer);
    }
    if (!nullToAbsent || linkedExpenseCategoryId != null) {
      map['linked_expense_category_id'] = Variable<int>(
        linkedExpenseCategoryId,
      );
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      type: Value(type),
      title: Value(title),
      triggerMode: Value(triggerMode),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueOdometer: dueOdometer == null && nullToAbsent
          ? const Value.absent()
          : Value(dueOdometer),
      recurEvery: recurEvery == null && nullToAbsent
          ? const Value.absent()
          : Value(recurEvery),
      recurUnit: recurUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(recurUnit),
      recurKmEvery: recurKmEvery == null && nullToAbsent
          ? const Value.absent()
          : Value(recurKmEvery),
      leadDays: leadDays == null && nullToAbsent
          ? const Value.absent()
          : Value(leadDays),
      leadKm: leadKm == null && nullToAbsent
          ? const Value.absent()
          : Value(leadKm),
      notify: Value(notify),
      lastCompletedDate: lastCompletedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedDate),
      lastCompletedOdometer: lastCompletedOdometer == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedOdometer),
      linkedExpenseCategoryId: linkedExpenseCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedExpenseCategoryId),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderRow(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      triggerMode: serializer.fromJson<String>(json['triggerMode']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      dueOdometer: serializer.fromJson<double?>(json['dueOdometer']),
      recurEvery: serializer.fromJson<int?>(json['recurEvery']),
      recurUnit: serializer.fromJson<String?>(json['recurUnit']),
      recurKmEvery: serializer.fromJson<int?>(json['recurKmEvery']),
      leadDays: serializer.fromJson<int?>(json['leadDays']),
      leadKm: serializer.fromJson<int?>(json['leadKm']),
      notify: serializer.fromJson<bool>(json['notify']),
      lastCompletedDate: serializer.fromJson<DateTime?>(
        json['lastCompletedDate'],
      ),
      lastCompletedOdometer: serializer.fromJson<double?>(
        json['lastCompletedOdometer'],
      ),
      linkedExpenseCategoryId: serializer.fromJson<int?>(
        json['linkedExpenseCategoryId'],
      ),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'triggerMode': serializer.toJson<String>(triggerMode),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'dueOdometer': serializer.toJson<double?>(dueOdometer),
      'recurEvery': serializer.toJson<int?>(recurEvery),
      'recurUnit': serializer.toJson<String?>(recurUnit),
      'recurKmEvery': serializer.toJson<int?>(recurKmEvery),
      'leadDays': serializer.toJson<int?>(leadDays),
      'leadKm': serializer.toJson<int?>(leadKm),
      'notify': serializer.toJson<bool>(notify),
      'lastCompletedDate': serializer.toJson<DateTime?>(lastCompletedDate),
      'lastCompletedOdometer': serializer.toJson<double?>(
        lastCompletedOdometer,
      ),
      'linkedExpenseCategoryId': serializer.toJson<int?>(
        linkedExpenseCategoryId,
      ),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReminderRow copyWith({
    int? id,
    int? vehicleId,
    String? type,
    String? title,
    String? triggerMode,
    Value<DateTime?> dueDate = const Value.absent(),
    Value<double?> dueOdometer = const Value.absent(),
    Value<int?> recurEvery = const Value.absent(),
    Value<String?> recurUnit = const Value.absent(),
    Value<int?> recurKmEvery = const Value.absent(),
    Value<int?> leadDays = const Value.absent(),
    Value<int?> leadKm = const Value.absent(),
    bool? notify,
    Value<DateTime?> lastCompletedDate = const Value.absent(),
    Value<double?> lastCompletedOdometer = const Value.absent(),
    Value<int?> linkedExpenseCategoryId = const Value.absent(),
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ReminderRow(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    type: type ?? this.type,
    title: title ?? this.title,
    triggerMode: triggerMode ?? this.triggerMode,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    dueOdometer: dueOdometer.present ? dueOdometer.value : this.dueOdometer,
    recurEvery: recurEvery.present ? recurEvery.value : this.recurEvery,
    recurUnit: recurUnit.present ? recurUnit.value : this.recurUnit,
    recurKmEvery: recurKmEvery.present ? recurKmEvery.value : this.recurKmEvery,
    leadDays: leadDays.present ? leadDays.value : this.leadDays,
    leadKm: leadKm.present ? leadKm.value : this.leadKm,
    notify: notify ?? this.notify,
    lastCompletedDate: lastCompletedDate.present
        ? lastCompletedDate.value
        : this.lastCompletedDate,
    lastCompletedOdometer: lastCompletedOdometer.present
        ? lastCompletedOdometer.value
        : this.lastCompletedOdometer,
    linkedExpenseCategoryId: linkedExpenseCategoryId.present
        ? linkedExpenseCategoryId.value
        : this.linkedExpenseCategoryId,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReminderRow copyWithCompanion(RemindersCompanion data) {
    return ReminderRow(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      triggerMode: data.triggerMode.present
          ? data.triggerMode.value
          : this.triggerMode,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueOdometer: data.dueOdometer.present
          ? data.dueOdometer.value
          : this.dueOdometer,
      recurEvery: data.recurEvery.present
          ? data.recurEvery.value
          : this.recurEvery,
      recurUnit: data.recurUnit.present ? data.recurUnit.value : this.recurUnit,
      recurKmEvery: data.recurKmEvery.present
          ? data.recurKmEvery.value
          : this.recurKmEvery,
      leadDays: data.leadDays.present ? data.leadDays.value : this.leadDays,
      leadKm: data.leadKm.present ? data.leadKm.value : this.leadKm,
      notify: data.notify.present ? data.notify.value : this.notify,
      lastCompletedDate: data.lastCompletedDate.present
          ? data.lastCompletedDate.value
          : this.lastCompletedDate,
      lastCompletedOdometer: data.lastCompletedOdometer.present
          ? data.lastCompletedOdometer.value
          : this.lastCompletedOdometer,
      linkedExpenseCategoryId: data.linkedExpenseCategoryId.present
          ? data.linkedExpenseCategoryId.value
          : this.linkedExpenseCategoryId,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRow(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('triggerMode: $triggerMode, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueOdometer: $dueOdometer, ')
          ..write('recurEvery: $recurEvery, ')
          ..write('recurUnit: $recurUnit, ')
          ..write('recurKmEvery: $recurKmEvery, ')
          ..write('leadDays: $leadDays, ')
          ..write('leadKm: $leadKm, ')
          ..write('notify: $notify, ')
          ..write('lastCompletedDate: $lastCompletedDate, ')
          ..write('lastCompletedOdometer: $lastCompletedOdometer, ')
          ..write('linkedExpenseCategoryId: $linkedExpenseCategoryId, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    type,
    title,
    triggerMode,
    dueDate,
    dueOdometer,
    recurEvery,
    recurUnit,
    recurKmEvery,
    leadDays,
    leadKm,
    notify,
    lastCompletedDate,
    lastCompletedOdometer,
    linkedExpenseCategoryId,
    active,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderRow &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.type == this.type &&
          other.title == this.title &&
          other.triggerMode == this.triggerMode &&
          other.dueDate == this.dueDate &&
          other.dueOdometer == this.dueOdometer &&
          other.recurEvery == this.recurEvery &&
          other.recurUnit == this.recurUnit &&
          other.recurKmEvery == this.recurKmEvery &&
          other.leadDays == this.leadDays &&
          other.leadKm == this.leadKm &&
          other.notify == this.notify &&
          other.lastCompletedDate == this.lastCompletedDate &&
          other.lastCompletedOdometer == this.lastCompletedOdometer &&
          other.linkedExpenseCategoryId == this.linkedExpenseCategoryId &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RemindersCompanion extends UpdateCompanion<ReminderRow> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<String> type;
  final Value<String> title;
  final Value<String> triggerMode;
  final Value<DateTime?> dueDate;
  final Value<double?> dueOdometer;
  final Value<int?> recurEvery;
  final Value<String?> recurUnit;
  final Value<int?> recurKmEvery;
  final Value<int?> leadDays;
  final Value<int?> leadKm;
  final Value<bool> notify;
  final Value<DateTime?> lastCompletedDate;
  final Value<double?> lastCompletedOdometer;
  final Value<int?> linkedExpenseCategoryId;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.triggerMode = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueOdometer = const Value.absent(),
    this.recurEvery = const Value.absent(),
    this.recurUnit = const Value.absent(),
    this.recurKmEvery = const Value.absent(),
    this.leadDays = const Value.absent(),
    this.leadKm = const Value.absent(),
    this.notify = const Value.absent(),
    this.lastCompletedDate = const Value.absent(),
    this.lastCompletedOdometer = const Value.absent(),
    this.linkedExpenseCategoryId = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    required String type,
    required String title,
    required String triggerMode,
    this.dueDate = const Value.absent(),
    this.dueOdometer = const Value.absent(),
    this.recurEvery = const Value.absent(),
    this.recurUnit = const Value.absent(),
    this.recurKmEvery = const Value.absent(),
    this.leadDays = const Value.absent(),
    this.leadKm = const Value.absent(),
    this.notify = const Value.absent(),
    this.lastCompletedDate = const Value.absent(),
    this.lastCompletedOdometer = const Value.absent(),
    this.linkedExpenseCategoryId = const Value.absent(),
    this.active = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : vehicleId = Value(vehicleId),
       type = Value(type),
       title = Value(title),
       triggerMode = Value(triggerMode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReminderRow> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? triggerMode,
    Expression<DateTime>? dueDate,
    Expression<double>? dueOdometer,
    Expression<int>? recurEvery,
    Expression<String>? recurUnit,
    Expression<int>? recurKmEvery,
    Expression<int>? leadDays,
    Expression<int>? leadKm,
    Expression<bool>? notify,
    Expression<DateTime>? lastCompletedDate,
    Expression<double>? lastCompletedOdometer,
    Expression<int>? linkedExpenseCategoryId,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (triggerMode != null) 'trigger_mode': triggerMode,
      if (dueDate != null) 'due_date': dueDate,
      if (dueOdometer != null) 'due_odometer': dueOdometer,
      if (recurEvery != null) 'recur_every': recurEvery,
      if (recurUnit != null) 'recur_unit': recurUnit,
      if (recurKmEvery != null) 'recur_km_every': recurKmEvery,
      if (leadDays != null) 'lead_days': leadDays,
      if (leadKm != null) 'lead_km': leadKm,
      if (notify != null) 'notify': notify,
      if (lastCompletedDate != null) 'last_completed_date': lastCompletedDate,
      if (lastCompletedOdometer != null)
        'last_completed_odometer': lastCompletedOdometer,
      if (linkedExpenseCategoryId != null)
        'linked_expense_category_id': linkedExpenseCategoryId,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<String>? type,
    Value<String>? title,
    Value<String>? triggerMode,
    Value<DateTime?>? dueDate,
    Value<double?>? dueOdometer,
    Value<int?>? recurEvery,
    Value<String?>? recurUnit,
    Value<int?>? recurKmEvery,
    Value<int?>? leadDays,
    Value<int?>? leadKm,
    Value<bool>? notify,
    Value<DateTime?>? lastCompletedDate,
    Value<double?>? lastCompletedOdometer,
    Value<int?>? linkedExpenseCategoryId,
    Value<bool>? active,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      title: title ?? this.title,
      triggerMode: triggerMode ?? this.triggerMode,
      dueDate: dueDate ?? this.dueDate,
      dueOdometer: dueOdometer ?? this.dueOdometer,
      recurEvery: recurEvery ?? this.recurEvery,
      recurUnit: recurUnit ?? this.recurUnit,
      recurKmEvery: recurKmEvery ?? this.recurKmEvery,
      leadDays: leadDays ?? this.leadDays,
      leadKm: leadKm ?? this.leadKm,
      notify: notify ?? this.notify,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      lastCompletedOdometer:
          lastCompletedOdometer ?? this.lastCompletedOdometer,
      linkedExpenseCategoryId:
          linkedExpenseCategoryId ?? this.linkedExpenseCategoryId,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (triggerMode.present) {
      map['trigger_mode'] = Variable<String>(triggerMode.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (dueOdometer.present) {
      map['due_odometer'] = Variable<double>(dueOdometer.value);
    }
    if (recurEvery.present) {
      map['recur_every'] = Variable<int>(recurEvery.value);
    }
    if (recurUnit.present) {
      map['recur_unit'] = Variable<String>(recurUnit.value);
    }
    if (recurKmEvery.present) {
      map['recur_km_every'] = Variable<int>(recurKmEvery.value);
    }
    if (leadDays.present) {
      map['lead_days'] = Variable<int>(leadDays.value);
    }
    if (leadKm.present) {
      map['lead_km'] = Variable<int>(leadKm.value);
    }
    if (notify.present) {
      map['notify'] = Variable<bool>(notify.value);
    }
    if (lastCompletedDate.present) {
      map['last_completed_date'] = Variable<DateTime>(lastCompletedDate.value);
    }
    if (lastCompletedOdometer.present) {
      map['last_completed_odometer'] = Variable<double>(
        lastCompletedOdometer.value,
      );
    }
    if (linkedExpenseCategoryId.present) {
      map['linked_expense_category_id'] = Variable<int>(
        linkedExpenseCategoryId.value,
      );
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('triggerMode: $triggerMode, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueOdometer: $dueOdometer, ')
          ..write('recurEvery: $recurEvery, ')
          ..write('recurUnit: $recurUnit, ')
          ..write('recurKmEvery: $recurKmEvery, ')
          ..write('leadDays: $leadDays, ')
          ..write('leadKm: $leadKm, ')
          ..write('notify: $notify, ')
          ..write('lastCompletedDate: $lastCompletedDate, ')
          ..write('lastCompletedOdometer: $lastCompletedOdometer, ')
          ..write('linkedExpenseCategoryId: $linkedExpenseCategoryId, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses
    with TableInfo<$ExpensesTable, ExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerMeta = const VerificationMeta(
    'odometer',
  );
  @override
  late final GeneratedColumn<double> odometer = GeneratedColumn<double>(
    'odometer',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRecurringMeta = const VerificationMeta(
    'isRecurring',
  );
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
    'is_recurring',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_recurring" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderIdMeta = const VerificationMeta(
    'reminderId',
  );
  @override
  late final GeneratedColumn<int> reminderId = GeneratedColumn<int>(
    'reminder_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reminders (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _receiptPhotoPathMeta = const VerificationMeta(
    'receiptPhotoPath',
  );
  @override
  late final GeneratedColumn<String> receiptPhotoPath = GeneratedColumn<String>(
    'receipt_photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    date,
    odometer,
    categoryId,
    amount,
    description,
    isRecurring,
    reminderId,
    receiptPhotoPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('odometer')) {
      context.handle(
        _odometerMeta,
        odometer.isAcceptableOrUnknown(data['odometer']!, _odometerMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
        _isRecurringMeta,
        isRecurring.isAcceptableOrUnknown(
          data['is_recurring']!,
          _isRecurringMeta,
        ),
      );
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
        _reminderIdMeta,
        reminderId.isAcceptableOrUnknown(data['reminder_id']!, _reminderIdMeta),
      );
    }
    if (data.containsKey('receipt_photo_path')) {
      context.handle(
        _receiptPhotoPathMeta,
        receiptPhotoPath.isAcceptableOrUnknown(
          data['receipt_photo_path']!,
          _receiptPhotoPathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      odometer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isRecurring: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_recurring'],
      )!,
      reminderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_id'],
      ),
      receiptPhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_photo_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class ExpenseRow extends DataClass implements Insertable<ExpenseRow> {
  final int id;
  final int vehicleId;
  final DateTime date;
  final double? odometer;
  final int categoryId;
  final double amount;
  final String? description;
  final bool isRecurring;
  final int? reminderId;
  final String? receiptPhotoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ExpenseRow({
    required this.id,
    required this.vehicleId,
    required this.date,
    this.odometer,
    required this.categoryId,
    required this.amount,
    this.description,
    required this.isRecurring,
    this.reminderId,
    this.receiptPhotoPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || odometer != null) {
      map['odometer'] = Variable<double>(odometer);
    }
    map['category_id'] = Variable<int>(categoryId);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || reminderId != null) {
      map['reminder_id'] = Variable<int>(reminderId);
    }
    if (!nullToAbsent || receiptPhotoPath != null) {
      map['receipt_photo_path'] = Variable<String>(receiptPhotoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      date: Value(date),
      odometer: odometer == null && nullToAbsent
          ? const Value.absent()
          : Value(odometer),
      categoryId: Value(categoryId),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isRecurring: Value(isRecurring),
      reminderId: reminderId == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderId),
      receiptPhotoPath: receiptPhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPhotoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExpenseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseRow(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      odometer: serializer.fromJson<double?>(json['odometer']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      reminderId: serializer.fromJson<int?>(json['reminderId']),
      receiptPhotoPath: serializer.fromJson<String?>(json['receiptPhotoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'date': serializer.toJson<DateTime>(date),
      'odometer': serializer.toJson<double?>(odometer),
      'categoryId': serializer.toJson<int>(categoryId),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String?>(description),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'reminderId': serializer.toJson<int?>(reminderId),
      'receiptPhotoPath': serializer.toJson<String?>(receiptPhotoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ExpenseRow copyWith({
    int? id,
    int? vehicleId,
    DateTime? date,
    Value<double?> odometer = const Value.absent(),
    int? categoryId,
    double? amount,
    Value<String?> description = const Value.absent(),
    bool? isRecurring,
    Value<int?> reminderId = const Value.absent(),
    Value<String?> receiptPhotoPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ExpenseRow(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    date: date ?? this.date,
    odometer: odometer.present ? odometer.value : this.odometer,
    categoryId: categoryId ?? this.categoryId,
    amount: amount ?? this.amount,
    description: description.present ? description.value : this.description,
    isRecurring: isRecurring ?? this.isRecurring,
    reminderId: reminderId.present ? reminderId.value : this.reminderId,
    receiptPhotoPath: receiptPhotoPath.present
        ? receiptPhotoPath.value
        : this.receiptPhotoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ExpenseRow copyWithCompanion(ExpensesCompanion data) {
    return ExpenseRow(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      date: data.date.present ? data.date.value : this.date,
      odometer: data.odometer.present ? data.odometer.value : this.odometer,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      amount: data.amount.present ? data.amount.value : this.amount,
      description: data.description.present
          ? data.description.value
          : this.description,
      isRecurring: data.isRecurring.present
          ? data.isRecurring.value
          : this.isRecurring,
      reminderId: data.reminderId.present
          ? data.reminderId.value
          : this.reminderId,
      receiptPhotoPath: data.receiptPhotoPath.present
          ? data.receiptPhotoPath.value
          : this.receiptPhotoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRow(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('odometer: $odometer, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('reminderId: $reminderId, ')
          ..write('receiptPhotoPath: $receiptPhotoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    date,
    odometer,
    categoryId,
    amount,
    description,
    isRecurring,
    reminderId,
    receiptPhotoPath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseRow &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.date == this.date &&
          other.odometer == this.odometer &&
          other.categoryId == this.categoryId &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.isRecurring == this.isRecurring &&
          other.reminderId == this.reminderId &&
          other.receiptPhotoPath == this.receiptPhotoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpensesCompanion extends UpdateCompanion<ExpenseRow> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<DateTime> date;
  final Value<double?> odometer;
  final Value<int> categoryId;
  final Value<double> amount;
  final Value<String?> description;
  final Value<bool> isRecurring;
  final Value<int?> reminderId;
  final Value<String?> receiptPhotoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.date = const Value.absent(),
    this.odometer = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.receiptPhotoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    required DateTime date,
    this.odometer = const Value.absent(),
    required int categoryId,
    required double amount,
    this.description = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.receiptPhotoPath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : vehicleId = Value(vehicleId),
       date = Value(date),
       categoryId = Value(categoryId),
       amount = Value(amount),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ExpenseRow> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<DateTime>? date,
    Expression<double>? odometer,
    Expression<int>? categoryId,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<bool>? isRecurring,
    Expression<int>? reminderId,
    Expression<String>? receiptPhotoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (date != null) 'date': date,
      if (odometer != null) 'odometer': odometer,
      if (categoryId != null) 'category_id': categoryId,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (reminderId != null) 'reminder_id': reminderId,
      if (receiptPhotoPath != null) 'receipt_photo_path': receiptPhotoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<DateTime>? date,
    Value<double?>? odometer,
    Value<int>? categoryId,
    Value<double>? amount,
    Value<String?>? description,
    Value<bool>? isRecurring,
    Value<int?>? reminderId,
    Value<String?>? receiptPhotoPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      odometer: odometer ?? this.odometer,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      isRecurring: isRecurring ?? this.isRecurring,
      reminderId: reminderId ?? this.reminderId,
      receiptPhotoPath: receiptPhotoPath ?? this.receiptPhotoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (odometer.present) {
      map['odometer'] = Variable<double>(odometer.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<int>(reminderId.value);
    }
    if (receiptPhotoPath.present) {
      map['receipt_photo_path'] = Variable<String>(receiptPhotoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('odometer: $odometer, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('reminderId: $reminderId, ')
          ..write('receiptPhotoPath: $receiptPhotoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FillUpsTable extends FillUps with TableInfo<$FillUpsTable, FillUpRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FillUpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _litersMeta = const VerificationMeta('liters');
  @override
  late final GeneratedColumn<double> liters = GeneratedColumn<double>(
    'liters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _odometerMeta = const VerificationMeta(
    'odometer',
  );
  @override
  late final GeneratedColumn<double> odometer = GeneratedColumn<double>(
    'odometer',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFullMeta = const VerificationMeta('isFull');
  @override
  late final GeneratedColumn<bool> isFull = GeneratedColumn<bool>(
    'is_full',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_full" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _rangeKmMeta = const VerificationMeta(
    'rangeKm',
  );
  @override
  late final GeneratedColumn<double> rangeKm = GeneratedColumn<double>(
    'range_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stationMeta = const VerificationMeta(
    'station',
  );
  @override
  late final GeneratedColumn<String> station = GeneratedColumn<String>(
    'station',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptPhotoPathMeta = const VerificationMeta(
    'receiptPhotoPath',
  );
  @override
  late final GeneratedColumn<String> receiptPhotoPath = GeneratedColumn<String>(
    'receipt_photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    date,
    amount,
    liters,
    odometer,
    isFull,
    rangeKm,
    station,
    categoryId,
    note,
    latitude,
    longitude,
    receiptPhotoPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fill_ups';
  @override
  VerificationContext validateIntegrity(
    Insertable<FillUpRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('liters')) {
      context.handle(
        _litersMeta,
        liters.isAcceptableOrUnknown(data['liters']!, _litersMeta),
      );
    }
    if (data.containsKey('odometer')) {
      context.handle(
        _odometerMeta,
        odometer.isAcceptableOrUnknown(data['odometer']!, _odometerMeta),
      );
    } else if (isInserting) {
      context.missing(_odometerMeta);
    }
    if (data.containsKey('is_full')) {
      context.handle(
        _isFullMeta,
        isFull.isAcceptableOrUnknown(data['is_full']!, _isFullMeta),
      );
    }
    if (data.containsKey('range_km')) {
      context.handle(
        _rangeKmMeta,
        rangeKm.isAcceptableOrUnknown(data['range_km']!, _rangeKmMeta),
      );
    }
    if (data.containsKey('station')) {
      context.handle(
        _stationMeta,
        station.isAcceptableOrUnknown(data['station']!, _stationMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('receipt_photo_path')) {
      context.handle(
        _receiptPhotoPathMeta,
        receiptPhotoPath.isAcceptableOrUnknown(
          data['receipt_photo_path']!,
          _receiptPhotoPathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FillUpRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FillUpRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      liters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}liters'],
      ),
      odometer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer'],
      )!,
      isFull: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_full'],
      )!,
      rangeKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}range_km'],
      ),
      station: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      receiptPhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_photo_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FillUpsTable createAlias(String alias) {
    return $FillUpsTable(attachedDatabase, alias);
  }
}

class FillUpRow extends DataClass implements Insertable<FillUpRow> {
  final int id;
  final int vehicleId;
  final DateTime date;
  final double amount;
  final double? liters;
  final double odometer;
  final bool isFull;
  final double? rangeKm;
  final String? station;
  final int categoryId;
  final String? note;
  final double? latitude;
  final double? longitude;
  final String? receiptPhotoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FillUpRow({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.amount,
    this.liters,
    required this.odometer,
    required this.isFull,
    this.rangeKm,
    this.station,
    required this.categoryId,
    this.note,
    this.latitude,
    this.longitude,
    this.receiptPhotoPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['date'] = Variable<DateTime>(date);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || liters != null) {
      map['liters'] = Variable<double>(liters);
    }
    map['odometer'] = Variable<double>(odometer);
    map['is_full'] = Variable<bool>(isFull);
    if (!nullToAbsent || rangeKm != null) {
      map['range_km'] = Variable<double>(rangeKm);
    }
    if (!nullToAbsent || station != null) {
      map['station'] = Variable<String>(station);
    }
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || receiptPhotoPath != null) {
      map['receipt_photo_path'] = Variable<String>(receiptPhotoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FillUpsCompanion toCompanion(bool nullToAbsent) {
    return FillUpsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      date: Value(date),
      amount: Value(amount),
      liters: liters == null && nullToAbsent
          ? const Value.absent()
          : Value(liters),
      odometer: Value(odometer),
      isFull: Value(isFull),
      rangeKm: rangeKm == null && nullToAbsent
          ? const Value.absent()
          : Value(rangeKm),
      station: station == null && nullToAbsent
          ? const Value.absent()
          : Value(station),
      categoryId: Value(categoryId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      receiptPhotoPath: receiptPhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPhotoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FillUpRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FillUpRow(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<double>(json['amount']),
      liters: serializer.fromJson<double?>(json['liters']),
      odometer: serializer.fromJson<double>(json['odometer']),
      isFull: serializer.fromJson<bool>(json['isFull']),
      rangeKm: serializer.fromJson<double?>(json['rangeKm']),
      station: serializer.fromJson<String?>(json['station']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      note: serializer.fromJson<String?>(json['note']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      receiptPhotoPath: serializer.fromJson<String?>(json['receiptPhotoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<double>(amount),
      'liters': serializer.toJson<double?>(liters),
      'odometer': serializer.toJson<double>(odometer),
      'isFull': serializer.toJson<bool>(isFull),
      'rangeKm': serializer.toJson<double?>(rangeKm),
      'station': serializer.toJson<String?>(station),
      'categoryId': serializer.toJson<int>(categoryId),
      'note': serializer.toJson<String?>(note),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'receiptPhotoPath': serializer.toJson<String?>(receiptPhotoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FillUpRow copyWith({
    int? id,
    int? vehicleId,
    DateTime? date,
    double? amount,
    Value<double?> liters = const Value.absent(),
    double? odometer,
    bool? isFull,
    Value<double?> rangeKm = const Value.absent(),
    Value<String?> station = const Value.absent(),
    int? categoryId,
    Value<String?> note = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> receiptPhotoPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FillUpRow(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    date: date ?? this.date,
    amount: amount ?? this.amount,
    liters: liters.present ? liters.value : this.liters,
    odometer: odometer ?? this.odometer,
    isFull: isFull ?? this.isFull,
    rangeKm: rangeKm.present ? rangeKm.value : this.rangeKm,
    station: station.present ? station.value : this.station,
    categoryId: categoryId ?? this.categoryId,
    note: note.present ? note.value : this.note,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    receiptPhotoPath: receiptPhotoPath.present
        ? receiptPhotoPath.value
        : this.receiptPhotoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FillUpRow copyWithCompanion(FillUpsCompanion data) {
    return FillUpRow(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      liters: data.liters.present ? data.liters.value : this.liters,
      odometer: data.odometer.present ? data.odometer.value : this.odometer,
      isFull: data.isFull.present ? data.isFull.value : this.isFull,
      rangeKm: data.rangeKm.present ? data.rangeKm.value : this.rangeKm,
      station: data.station.present ? data.station.value : this.station,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      receiptPhotoPath: data.receiptPhotoPath.present
          ? data.receiptPhotoPath.value
          : this.receiptPhotoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FillUpRow(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('liters: $liters, ')
          ..write('odometer: $odometer, ')
          ..write('isFull: $isFull, ')
          ..write('rangeKm: $rangeKm, ')
          ..write('station: $station, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('receiptPhotoPath: $receiptPhotoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    date,
    amount,
    liters,
    odometer,
    isFull,
    rangeKm,
    station,
    categoryId,
    note,
    latitude,
    longitude,
    receiptPhotoPath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FillUpRow &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.liters == this.liters &&
          other.odometer == this.odometer &&
          other.isFull == this.isFull &&
          other.rangeKm == this.rangeKm &&
          other.station == this.station &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.receiptPhotoPath == this.receiptPhotoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FillUpsCompanion extends UpdateCompanion<FillUpRow> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<DateTime> date;
  final Value<double> amount;
  final Value<double?> liters;
  final Value<double> odometer;
  final Value<bool> isFull;
  final Value<double?> rangeKm;
  final Value<String?> station;
  final Value<int> categoryId;
  final Value<String?> note;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> receiptPhotoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FillUpsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.liters = const Value.absent(),
    this.odometer = const Value.absent(),
    this.isFull = const Value.absent(),
    this.rangeKm = const Value.absent(),
    this.station = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.receiptPhotoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FillUpsCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    required DateTime date,
    required double amount,
    this.liters = const Value.absent(),
    required double odometer,
    this.isFull = const Value.absent(),
    this.rangeKm = const Value.absent(),
    this.station = const Value.absent(),
    required int categoryId,
    this.note = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.receiptPhotoPath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : vehicleId = Value(vehicleId),
       date = Value(date),
       amount = Value(amount),
       odometer = Value(odometer),
       categoryId = Value(categoryId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FillUpRow> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<DateTime>? date,
    Expression<double>? amount,
    Expression<double>? liters,
    Expression<double>? odometer,
    Expression<bool>? isFull,
    Expression<double>? rangeKm,
    Expression<String>? station,
    Expression<int>? categoryId,
    Expression<String>? note,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? receiptPhotoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (liters != null) 'liters': liters,
      if (odometer != null) 'odometer': odometer,
      if (isFull != null) 'is_full': isFull,
      if (rangeKm != null) 'range_km': rangeKm,
      if (station != null) 'station': station,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (receiptPhotoPath != null) 'receipt_photo_path': receiptPhotoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FillUpsCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<DateTime>? date,
    Value<double>? amount,
    Value<double?>? liters,
    Value<double>? odometer,
    Value<bool>? isFull,
    Value<double?>? rangeKm,
    Value<String?>? station,
    Value<int>? categoryId,
    Value<String?>? note,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? receiptPhotoPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FillUpsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      liters: liters ?? this.liters,
      odometer: odometer ?? this.odometer,
      isFull: isFull ?? this.isFull,
      rangeKm: rangeKm ?? this.rangeKm,
      station: station ?? this.station,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      receiptPhotoPath: receiptPhotoPath ?? this.receiptPhotoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (liters.present) {
      map['liters'] = Variable<double>(liters.value);
    }
    if (odometer.present) {
      map['odometer'] = Variable<double>(odometer.value);
    }
    if (isFull.present) {
      map['is_full'] = Variable<bool>(isFull.value);
    }
    if (rangeKm.present) {
      map['range_km'] = Variable<double>(rangeKm.value);
    }
    if (station.present) {
      map['station'] = Variable<String>(station.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (receiptPhotoPath.present) {
      map['receipt_photo_path'] = Variable<String>(receiptPhotoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FillUpsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('liters: $liters, ')
          ..write('odometer: $odometer, ')
          ..write('isFull: $isFull, ')
          ..write('rangeKm: $rangeKm, ')
          ..write('station: $station, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('receiptPhotoPath: $receiptPhotoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $FillUpsTable fillUps = $FillUpsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    vehicles,
    reminders,
    expenses,
    fillUps,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'reminders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('fill_ups', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      required int color,
      Value<bool> isDefault,
      Value<String> kind,
      Value<int?> iconCode,
      Value<int> ord,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> color,
      Value<bool> isDefault,
      Value<String> kind,
      Value<int?> iconCode,
      Value<int> ord,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpensesTable, List<ExpenseRow>>
  _expensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'categories__id__expenses__category_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FillUpsTable, List<FillUpRow>> _fillUpsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.fillUps,
    aliasName: 'categories__id__fill_ups__category_id',
  );

  $$FillUpsTableProcessedTableManager get fillUpsRefs {
    final manager = $$FillUpsTableTableManager(
      $_db,
      $_db.fillUps,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fillUpsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get iconCode => $composableBuilder(
    column: $table.iconCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ord => $composableBuilder(
    column: $table.ord,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> fillUpsRefs(
    Expression<bool> Function($$FillUpsTableFilterComposer f) f,
  ) {
    final $$FillUpsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fillUps,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FillUpsTableFilterComposer(
            $db: $db,
            $table: $db.fillUps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get iconCode => $composableBuilder(
    column: $table.iconCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ord => $composableBuilder(
    column: $table.ord,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get iconCode =>
      $composableBuilder(column: $table.iconCode, builder: (column) => column);

  GeneratedColumn<int> get ord =>
      $composableBuilder(column: $table.ord, builder: (column) => column);

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> fillUpsRefs<T extends Object>(
    Expression<T> Function($$FillUpsTableAnnotationComposer a) f,
  ) {
    final $$FillUpsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fillUps,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FillUpsTableAnnotationComposer(
            $db: $db,
            $table: $db.fillUps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({bool expensesRefs, bool fillUpsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int?> iconCode = const Value.absent(),
                Value<int> ord = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                color: color,
                isDefault: isDefault,
                kind: kind,
                iconCode: iconCode,
                ord: ord,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int color,
                Value<bool> isDefault = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int?> iconCode = const Value.absent(),
                Value<int> ord = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                color: color,
                isDefault: isDefault,
                kind: kind,
                iconCode: iconCode,
                ord: ord,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expensesRefs = false, fillUpsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (expensesRefs) db.expenses,
                if (fillUpsRefs) db.fillUps,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<
                      CategoryRow,
                      $CategoriesTable,
                      ExpenseRow
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._expensesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).expensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                  if (fillUpsRefs)
                    await $_getPrefetchedData<
                      CategoryRow,
                      $CategoriesTable,
                      FillUpRow
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._fillUpsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).fillUpsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({bool expensesRefs, bool fillUpsRefs})
    >;
typedef $$VehiclesTableCreateCompanionBuilder =
    VehiclesCompanion Function({
      Value<int> id,
      required String make,
      required String model,
      Value<int?> year,
      Value<String?> trim,
      required String fuelType,
      Value<String?> plate,
      Value<String?> euroClass,
      Value<int> colorTag,
      Value<bool> isDefault,
      Value<double?> tankCapacityL,
      Value<double?> mfrConsumption,
      Value<double?> mfrRangeKm,
      Value<int?> powerPs,
      Value<String> specSource,
      Value<String?> catalogRef,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$VehiclesTableUpdateCompanionBuilder =
    VehiclesCompanion Function({
      Value<int> id,
      Value<String> make,
      Value<String> model,
      Value<int?> year,
      Value<String?> trim,
      Value<String> fuelType,
      Value<String?> plate,
      Value<String?> euroClass,
      Value<int> colorTag,
      Value<bool> isDefault,
      Value<double?> tankCapacityL,
      Value<double?> mfrConsumption,
      Value<double?> mfrRangeKm,
      Value<int?> powerPs,
      Value<String> specSource,
      Value<String?> catalogRef,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, VehicleRow> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RemindersTable, List<ReminderRow>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'vehicles__id__reminders__vehicle_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<ExpenseRow>>
  _expensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'vehicles__id__expenses__vehicle_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FillUpsTable, List<FillUpRow>> _fillUpsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.fillUps,
    aliasName: 'vehicles__id__fill_ups__vehicle_id',
  );

  $$FillUpsTableProcessedTableManager get fillUpsRefs {
    final manager = $$FillUpsTableTableManager(
      $_db,
      $_db.fillUps,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fillUpsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trim => $composableBuilder(
    column: $table.trim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get euroClass => $composableBuilder(
    column: $table.euroClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorTag => $composableBuilder(
    column: $table.colorTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tankCapacityL => $composableBuilder(
    column: $table.tankCapacityL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mfrConsumption => $composableBuilder(
    column: $table.mfrConsumption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mfrRangeKm => $composableBuilder(
    column: $table.mfrRangeKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get powerPs => $composableBuilder(
    column: $table.powerPs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specSource => $composableBuilder(
    column: $table.specSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogRef => $composableBuilder(
    column: $table.catalogRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> fillUpsRefs(
    Expression<bool> Function($$FillUpsTableFilterComposer f) f,
  ) {
    final $$FillUpsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fillUps,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FillUpsTableFilterComposer(
            $db: $db,
            $table: $db.fillUps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trim => $composableBuilder(
    column: $table.trim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get euroClass => $composableBuilder(
    column: $table.euroClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorTag => $composableBuilder(
    column: $table.colorTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tankCapacityL => $composableBuilder(
    column: $table.tankCapacityL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mfrConsumption => $composableBuilder(
    column: $table.mfrConsumption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mfrRangeKm => $composableBuilder(
    column: $table.mfrRangeKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get powerPs => $composableBuilder(
    column: $table.powerPs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specSource => $composableBuilder(
    column: $table.specSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogRef => $composableBuilder(
    column: $table.catalogRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get make =>
      $composableBuilder(column: $table.make, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get trim =>
      $composableBuilder(column: $table.trim, builder: (column) => column);

  GeneratedColumn<String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<String> get plate =>
      $composableBuilder(column: $table.plate, builder: (column) => column);

  GeneratedColumn<String> get euroClass =>
      $composableBuilder(column: $table.euroClass, builder: (column) => column);

  GeneratedColumn<int> get colorTag =>
      $composableBuilder(column: $table.colorTag, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<double> get tankCapacityL => $composableBuilder(
    column: $table.tankCapacityL,
    builder: (column) => column,
  );

  GeneratedColumn<double> get mfrConsumption => $composableBuilder(
    column: $table.mfrConsumption,
    builder: (column) => column,
  );

  GeneratedColumn<double> get mfrRangeKm => $composableBuilder(
    column: $table.mfrRangeKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get powerPs =>
      $composableBuilder(column: $table.powerPs, builder: (column) => column);

  GeneratedColumn<String> get specSource => $composableBuilder(
    column: $table.specSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catalogRef => $composableBuilder(
    column: $table.catalogRef,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> fillUpsRefs<T extends Object>(
    Expression<T> Function($$FillUpsTableAnnotationComposer a) f,
  ) {
    final $$FillUpsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fillUps,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FillUpsTableAnnotationComposer(
            $db: $db,
            $table: $db.fillUps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          VehicleRow,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (VehicleRow, $$VehiclesTableReferences),
          VehicleRow,
          PrefetchHooks Function({
            bool remindersRefs,
            bool expensesRefs,
            bool fillUpsRefs,
          })
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> make = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> trim = const Value.absent(),
                Value<String> fuelType = const Value.absent(),
                Value<String?> plate = const Value.absent(),
                Value<String?> euroClass = const Value.absent(),
                Value<int> colorTag = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<double?> tankCapacityL = const Value.absent(),
                Value<double?> mfrConsumption = const Value.absent(),
                Value<double?> mfrRangeKm = const Value.absent(),
                Value<int?> powerPs = const Value.absent(),
                Value<String> specSource = const Value.absent(),
                Value<String?> catalogRef = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                make: make,
                model: model,
                year: year,
                trim: trim,
                fuelType: fuelType,
                plate: plate,
                euroClass: euroClass,
                colorTag: colorTag,
                isDefault: isDefault,
                tankCapacityL: tankCapacityL,
                mfrConsumption: mfrConsumption,
                mfrRangeKm: mfrRangeKm,
                powerPs: powerPs,
                specSource: specSource,
                catalogRef: catalogRef,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String make,
                required String model,
                Value<int?> year = const Value.absent(),
                Value<String?> trim = const Value.absent(),
                required String fuelType,
                Value<String?> plate = const Value.absent(),
                Value<String?> euroClass = const Value.absent(),
                Value<int> colorTag = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<double?> tankCapacityL = const Value.absent(),
                Value<double?> mfrConsumption = const Value.absent(),
                Value<double?> mfrRangeKm = const Value.absent(),
                Value<int?> powerPs = const Value.absent(),
                Value<String> specSource = const Value.absent(),
                Value<String?> catalogRef = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => VehiclesCompanion.insert(
                id: id,
                make: make,
                model: model,
                year: year,
                trim: trim,
                fuelType: fuelType,
                plate: plate,
                euroClass: euroClass,
                colorTag: colorTag,
                isDefault: isDefault,
                tankCapacityL: tankCapacityL,
                mfrConsumption: mfrConsumption,
                mfrRangeKm: mfrRangeKm,
                powerPs: powerPs,
                specSource: specSource,
                catalogRef: catalogRef,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                remindersRefs = false,
                expensesRefs = false,
                fillUpsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (remindersRefs) db.reminders,
                    if (expensesRefs) db.expenses,
                    if (fillUpsRefs) db.fillUps,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (remindersRefs)
                        await $_getPrefetchedData<
                          VehicleRow,
                          $VehiclesTable,
                          ReminderRow
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<
                          VehicleRow,
                          $VehiclesTable,
                          ExpenseRow
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (fillUpsRefs)
                        await $_getPrefetchedData<
                          VehicleRow,
                          $VehiclesTable,
                          FillUpRow
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._fillUpsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).fillUpsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      VehicleRow,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (VehicleRow, $$VehiclesTableReferences),
      VehicleRow,
      PrefetchHooks Function({
        bool remindersRefs,
        bool expensesRefs,
        bool fillUpsRefs,
      })
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      required int vehicleId,
      required String type,
      required String title,
      required String triggerMode,
      Value<DateTime?> dueDate,
      Value<double?> dueOdometer,
      Value<int?> recurEvery,
      Value<String?> recurUnit,
      Value<int?> recurKmEvery,
      Value<int?> leadDays,
      Value<int?> leadKm,
      Value<bool> notify,
      Value<DateTime?> lastCompletedDate,
      Value<double?> lastCompletedOdometer,
      Value<int?> linkedExpenseCategoryId,
      Value<bool> active,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      Value<int> vehicleId,
      Value<String> type,
      Value<String> title,
      Value<String> triggerMode,
      Value<DateTime?> dueDate,
      Value<double?> dueOdometer,
      Value<int?> recurEvery,
      Value<String?> recurUnit,
      Value<int?> recurKmEvery,
      Value<int?> leadDays,
      Value<int?> leadKm,
      Value<bool> notify,
      Value<DateTime?> lastCompletedDate,
      Value<double?> lastCompletedOdometer,
      Value<int?> linkedExpenseCategoryId,
      Value<bool> active,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, ReminderRow> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('reminders__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<ExpenseRow>>
  _expensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'reminders__id__expenses__reminder_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.reminderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggerMode => $composableBuilder(
    column: $table.triggerMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dueOdometer => $composableBuilder(
    column: $table.dueOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recurEvery => $composableBuilder(
    column: $table.recurEvery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurUnit => $composableBuilder(
    column: $table.recurUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recurKmEvery => $composableBuilder(
    column: $table.recurKmEvery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leadDays => $composableBuilder(
    column: $table.leadDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leadKm => $composableBuilder(
    column: $table.leadKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notify => $composableBuilder(
    column: $table.notify,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCompletedDate => $composableBuilder(
    column: $table.lastCompletedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastCompletedOdometer => $composableBuilder(
    column: $table.lastCompletedOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get linkedExpenseCategoryId => $composableBuilder(
    column: $table.linkedExpenseCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.reminderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerMode => $composableBuilder(
    column: $table.triggerMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dueOdometer => $composableBuilder(
    column: $table.dueOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurEvery => $composableBuilder(
    column: $table.recurEvery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurUnit => $composableBuilder(
    column: $table.recurUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurKmEvery => $composableBuilder(
    column: $table.recurKmEvery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leadDays => $composableBuilder(
    column: $table.leadDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leadKm => $composableBuilder(
    column: $table.leadKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notify => $composableBuilder(
    column: $table.notify,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCompletedDate => $composableBuilder(
    column: $table.lastCompletedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastCompletedOdometer => $composableBuilder(
    column: $table.lastCompletedOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get linkedExpenseCategoryId => $composableBuilder(
    column: $table.linkedExpenseCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get triggerMode => $composableBuilder(
    column: $table.triggerMode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<double> get dueOdometer => $composableBuilder(
    column: $table.dueOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recurEvery => $composableBuilder(
    column: $table.recurEvery,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurUnit =>
      $composableBuilder(column: $table.recurUnit, builder: (column) => column);

  GeneratedColumn<int> get recurKmEvery => $composableBuilder(
    column: $table.recurKmEvery,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leadDays =>
      $composableBuilder(column: $table.leadDays, builder: (column) => column);

  GeneratedColumn<int> get leadKm =>
      $composableBuilder(column: $table.leadKm, builder: (column) => column);

  GeneratedColumn<bool> get notify =>
      $composableBuilder(column: $table.notify, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCompletedDate => $composableBuilder(
    column: $table.lastCompletedDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastCompletedOdometer => $composableBuilder(
    column: $table.lastCompletedOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<int> get linkedExpenseCategoryId => $composableBuilder(
    column: $table.linkedExpenseCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.reminderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          ReminderRow,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (ReminderRow, $$RemindersTableReferences),
          ReminderRow,
          PrefetchHooks Function({bool vehicleId, bool expensesRefs})
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> triggerMode = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<double?> dueOdometer = const Value.absent(),
                Value<int?> recurEvery = const Value.absent(),
                Value<String?> recurUnit = const Value.absent(),
                Value<int?> recurKmEvery = const Value.absent(),
                Value<int?> leadDays = const Value.absent(),
                Value<int?> leadKm = const Value.absent(),
                Value<bool> notify = const Value.absent(),
                Value<DateTime?> lastCompletedDate = const Value.absent(),
                Value<double?> lastCompletedOdometer = const Value.absent(),
                Value<int?> linkedExpenseCategoryId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                vehicleId: vehicleId,
                type: type,
                title: title,
                triggerMode: triggerMode,
                dueDate: dueDate,
                dueOdometer: dueOdometer,
                recurEvery: recurEvery,
                recurUnit: recurUnit,
                recurKmEvery: recurKmEvery,
                leadDays: leadDays,
                leadKm: leadKm,
                notify: notify,
                lastCompletedDate: lastCompletedDate,
                lastCompletedOdometer: lastCompletedOdometer,
                linkedExpenseCategoryId: linkedExpenseCategoryId,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                required String type,
                required String title,
                required String triggerMode,
                Value<DateTime?> dueDate = const Value.absent(),
                Value<double?> dueOdometer = const Value.absent(),
                Value<int?> recurEvery = const Value.absent(),
                Value<String?> recurUnit = const Value.absent(),
                Value<int?> recurKmEvery = const Value.absent(),
                Value<int?> leadDays = const Value.absent(),
                Value<int?> leadKm = const Value.absent(),
                Value<bool> notify = const Value.absent(),
                Value<DateTime?> lastCompletedDate = const Value.absent(),
                Value<double?> lastCompletedOdometer = const Value.absent(),
                Value<int?> linkedExpenseCategoryId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => RemindersCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                type: type,
                title: title,
                triggerMode: triggerMode,
                dueDate: dueDate,
                dueOdometer: dueOdometer,
                recurEvery: recurEvery,
                recurUnit: recurUnit,
                recurKmEvery: recurKmEvery,
                leadDays: leadDays,
                leadKm: leadKm,
                notify: notify,
                lastCompletedDate: lastCompletedDate,
                lastCompletedOdometer: lastCompletedOdometer,
                linkedExpenseCategoryId: linkedExpenseCategoryId,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false, expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vehicleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleId,
                                referencedTable: $$RemindersTableReferences
                                    ._vehicleIdTable(db),
                                referencedColumn: $$RemindersTableReferences
                                    ._vehicleIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<
                      ReminderRow,
                      $RemindersTable,
                      ExpenseRow
                    >(
                      currentTable: table,
                      referencedTable: $$RemindersTableReferences
                          ._expensesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RemindersTableReferences(
                            db,
                            table,
                            p0,
                          ).expensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.reminderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      ReminderRow,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (ReminderRow, $$RemindersTableReferences),
      ReminderRow,
      PrefetchHooks Function({bool vehicleId, bool expensesRefs})
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required int vehicleId,
      required DateTime date,
      Value<double?> odometer,
      required int categoryId,
      required double amount,
      Value<String?> description,
      Value<bool> isRecurring,
      Value<int?> reminderId,
      Value<String?> receiptPhotoPath,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<int> vehicleId,
      Value<DateTime> date,
      Value<double?> odometer,
      Value<int> categoryId,
      Value<double> amount,
      Value<String?> description,
      Value<bool> isRecurring,
      Value<int?> reminderId,
      Value<String?> receiptPhotoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('expenses__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('expenses__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RemindersTable _reminderIdTable(_$AppDatabase db) =>
      db.reminders.createAlias('expenses__reminder_id__reminders__id');

  $$RemindersTableProcessedTableManager? get reminderId {
    final $_column = $_itemColumn<int>('reminder_id');
    if ($_column == null) return null;
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reminderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPhotoPath => $composableBuilder(
    column: $table.receiptPhotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RemindersTableFilterComposer get reminderId {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPhotoPath => $composableBuilder(
    column: $table.receiptPhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RemindersTableOrderingComposer get reminderId {
    final $$RemindersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableOrderingComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get odometer =>
      $composableBuilder(column: $table.odometer, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptPhotoPath => $composableBuilder(
    column: $table.receiptPhotoPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RemindersTableAnnotationComposer get reminderId {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          ExpenseRow,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (ExpenseRow, $$ExpensesTableReferences),
          ExpenseRow,
          PrefetchHooks Function({
            bool vehicleId,
            bool categoryId,
            bool reminderId,
          })
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double?> odometer = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<int?> reminderId = const Value.absent(),
                Value<String?> receiptPhotoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                vehicleId: vehicleId,
                date: date,
                odometer: odometer,
                categoryId: categoryId,
                amount: amount,
                description: description,
                isRecurring: isRecurring,
                reminderId: reminderId,
                receiptPhotoPath: receiptPhotoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                required DateTime date,
                Value<double?> odometer = const Value.absent(),
                required int categoryId,
                required double amount,
                Value<String?> description = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<int?> reminderId = const Value.absent(),
                Value<String?> receiptPhotoPath = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ExpensesCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                date: date,
                odometer: odometer,
                categoryId: categoryId,
                amount: amount,
                description: description,
                isRecurring: isRecurring,
                reminderId: reminderId,
                receiptPhotoPath: receiptPhotoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({vehicleId = false, categoryId = false, reminderId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (vehicleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.vehicleId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._vehicleIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._vehicleIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (reminderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.reminderId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._reminderIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._reminderIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      ExpenseRow,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (ExpenseRow, $$ExpensesTableReferences),
      ExpenseRow,
      PrefetchHooks Function({bool vehicleId, bool categoryId, bool reminderId})
    >;
typedef $$FillUpsTableCreateCompanionBuilder =
    FillUpsCompanion Function({
      Value<int> id,
      required int vehicleId,
      required DateTime date,
      required double amount,
      Value<double?> liters,
      required double odometer,
      Value<bool> isFull,
      Value<double?> rangeKm,
      Value<String?> station,
      required int categoryId,
      Value<String?> note,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> receiptPhotoPath,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$FillUpsTableUpdateCompanionBuilder =
    FillUpsCompanion Function({
      Value<int> id,
      Value<int> vehicleId,
      Value<DateTime> date,
      Value<double> amount,
      Value<double?> liters,
      Value<double> odometer,
      Value<bool> isFull,
      Value<double?> rangeKm,
      Value<String?> station,
      Value<int> categoryId,
      Value<String?> note,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> receiptPhotoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$FillUpsTableReferences
    extends BaseReferences<_$AppDatabase, $FillUpsTable, FillUpRow> {
  $$FillUpsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('fill_ups__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('fill_ups__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FillUpsTableFilterComposer
    extends Composer<_$AppDatabase, $FillUpsTable> {
  $$FillUpsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFull => $composableBuilder(
    column: $table.isFull,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rangeKm => $composableBuilder(
    column: $table.rangeKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get station => $composableBuilder(
    column: $table.station,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPhotoPath => $composableBuilder(
    column: $table.receiptPhotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FillUpsTableOrderingComposer
    extends Composer<_$AppDatabase, $FillUpsTable> {
  $$FillUpsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFull => $composableBuilder(
    column: $table.isFull,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rangeKm => $composableBuilder(
    column: $table.rangeKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get station => $composableBuilder(
    column: $table.station,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPhotoPath => $composableBuilder(
    column: $table.receiptPhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FillUpsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FillUpsTable> {
  $$FillUpsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get liters =>
      $composableBuilder(column: $table.liters, builder: (column) => column);

  GeneratedColumn<double> get odometer =>
      $composableBuilder(column: $table.odometer, builder: (column) => column);

  GeneratedColumn<bool> get isFull =>
      $composableBuilder(column: $table.isFull, builder: (column) => column);

  GeneratedColumn<double> get rangeKm =>
      $composableBuilder(column: $table.rangeKm, builder: (column) => column);

  GeneratedColumn<String> get station =>
      $composableBuilder(column: $table.station, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get receiptPhotoPath => $composableBuilder(
    column: $table.receiptPhotoPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FillUpsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FillUpsTable,
          FillUpRow,
          $$FillUpsTableFilterComposer,
          $$FillUpsTableOrderingComposer,
          $$FillUpsTableAnnotationComposer,
          $$FillUpsTableCreateCompanionBuilder,
          $$FillUpsTableUpdateCompanionBuilder,
          (FillUpRow, $$FillUpsTableReferences),
          FillUpRow,
          PrefetchHooks Function({bool vehicleId, bool categoryId})
        > {
  $$FillUpsTableTableManager(_$AppDatabase db, $FillUpsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FillUpsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FillUpsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FillUpsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double?> liters = const Value.absent(),
                Value<double> odometer = const Value.absent(),
                Value<bool> isFull = const Value.absent(),
                Value<double?> rangeKm = const Value.absent(),
                Value<String?> station = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> receiptPhotoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FillUpsCompanion(
                id: id,
                vehicleId: vehicleId,
                date: date,
                amount: amount,
                liters: liters,
                odometer: odometer,
                isFull: isFull,
                rangeKm: rangeKm,
                station: station,
                categoryId: categoryId,
                note: note,
                latitude: latitude,
                longitude: longitude,
                receiptPhotoPath: receiptPhotoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                required DateTime date,
                required double amount,
                Value<double?> liters = const Value.absent(),
                required double odometer,
                Value<bool> isFull = const Value.absent(),
                Value<double?> rangeKm = const Value.absent(),
                Value<String?> station = const Value.absent(),
                required int categoryId,
                Value<String?> note = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> receiptPhotoPath = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => FillUpsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                date: date,
                amount: amount,
                liters: liters,
                odometer: odometer,
                isFull: isFull,
                rangeKm: rangeKm,
                station: station,
                categoryId: categoryId,
                note: note,
                latitude: latitude,
                longitude: longitude,
                receiptPhotoPath: receiptPhotoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FillUpsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vehicleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleId,
                                referencedTable: $$FillUpsTableReferences
                                    ._vehicleIdTable(db),
                                referencedColumn: $$FillUpsTableReferences
                                    ._vehicleIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$FillUpsTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$FillUpsTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FillUpsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FillUpsTable,
      FillUpRow,
      $$FillUpsTableFilterComposer,
      $$FillUpsTableOrderingComposer,
      $$FillUpsTableAnnotationComposer,
      $$FillUpsTableCreateCompanionBuilder,
      $$FillUpsTableUpdateCompanionBuilder,
      (FillUpRow, $$FillUpsTableReferences),
      FillUpRow,
      PrefetchHooks Function({bool vehicleId, bool categoryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$FillUpsTableTableManager get fillUps =>
      $$FillUpsTableTableManager(_db, _db.fillUps);
}
