import 'package:flutter/material.dart';

import '../../domain/models/category.dart';
import '../../domain/models/enums.dart';

/// Maps a category's stored [Category.iconCode] (a Material Icons code point,
/// seeded for the expense categories) to a **const** [IconData].
///
/// We deliberately do NOT build `IconData(code, fontFamily: 'MaterialIcons')`
/// at runtime: the release build (`flutter build apk --release`, the CD/CI
/// gate) tree-shakes the icon font and fails on non-const `IconData`. A const
/// lookup keeps every glyph statically referenced, so tree-shaking stays on.
const _byCode = <int, IconData>{
  0xe1a7: Icons.shield, // Assicurazione
  0xe53b: Icons.receipt_long, // Bollo
  0xe8e8: Icons.build, // Revisione
  0xe869: Icons.car_repair, // Tagliando / Riparazioni
  0xe53f: Icons.tire_repair, // Cambio gomme
  0xe863: Icons.sync, // Inversione gomme
  0xe8b8: Icons.engineering, // Manutenzione straordinaria
  0xe002: Icons.warning, // Multe
  0xe57f: Icons.local_atm, // Pedaggi
  0xe54f: Icons.local_parking, // Parcheggio
  0xe798: Icons.local_car_wash, // Autolavaggio
  0xe8cc: Icons.shopping_bag, // Accessori
  0xe619: Icons.more_horiz, // Altro
};

/// The icon to show for [category]. Expense categories resolve from their
/// seeded [Category.iconCode]; fuel categories (which carry no code) fall back
/// by their default flag — "Mie" vs "Non mie". Anything unmapped gets a
/// neutral [Icons.category].
IconData categoryIcon(Category category) {
  final mapped = _byCode[category.iconCode];
  if (mapped != null) return mapped;
  if (category.kind == CategoryKind.fuel) {
    return category.isDefault ? Icons.person : Icons.group;
  }
  return Icons.category;
}
