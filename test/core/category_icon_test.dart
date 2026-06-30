import 'package:carburo/src/core/widgets/category_icon.dart';
import 'package:carburo/src/domain/models/category.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Category _cat({
  int? iconCode,
  CategoryKind kind = CategoryKind.expense,
  bool isDefault = false,
}) => Category(
  id: 1,
  name: 'X',
  color: 0xFF000000,
  kind: kind,
  isDefault: isDefault,
  iconCode: iconCode,
);

void main() {
  test('expense category resolves its seeded icon code to a const icon', () {
    expect(categoryIcon(_cat(iconCode: 0xe53b)), Icons.receipt_long); // Bollo
    expect(categoryIcon(_cat(iconCode: 0xe1a7)), Icons.shield); // Assicurazione
    expect(categoryIcon(_cat(iconCode: 0xe54f)), Icons.local_parking);
  });

  test('unknown or missing code falls back to a neutral icon', () {
    expect(categoryIcon(_cat(iconCode: 0x9999)), Icons.category);
    expect(categoryIcon(_cat(iconCode: null)), Icons.category);
  });

  test('fuel categories fall back by their default flag (no stored code)', () {
    expect(
      categoryIcon(_cat(kind: CategoryKind.fuel, isDefault: true)),
      Icons.person,
    );
    expect(
      categoryIcon(_cat(kind: CategoryKind.fuel, isDefault: false)),
      Icons.group,
    );
  });
}
