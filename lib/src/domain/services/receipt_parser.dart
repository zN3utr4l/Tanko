import '../models/receipt_data.dart';

/// Best-effort extraction of fill-up fields from OCR'd receipt lines.
/// Never throws; any field it cannot read confidently stays null.
class ReceiptParser {
  const ReceiptParser();

  /// Known Italian fuel brands, upper-case keyword -> display name.
  static const _brands = <String, String>{
    'ENI': 'Eni',
    'AGIP': 'Agip',
    'Q8': 'Q8',
    'ESSO': 'Esso',
    'TAMOIL': 'Tamoil',
    'REPSOL': 'Repsol',
    'BEYFIN': 'Beyfin',
    'TOTALERG': 'TotalErg',
    'TOTAL': 'Total',
    'SHELL': 'Shell',
    // 'IP' and 'API' are short; match as whole words only (see _hasWord).
  };

  ReceiptData parse(List<String> lines) {
    final upper = lines.map((l) => l.toUpperCase()).toList();
    return ReceiptData(
      station: _station(upper),
      amount: _numNear(upper, RegExp(r'IMPORTO|TOTALE|EURO|€')),
      liters: _numNear(upper, RegExp(r'LITRI|\bLT\b')),
      pricePerLiter: _numNear(upper, RegExp(r'/L|PREZZO')),
      date: _date(lines.join('\n')),
    );
  }

  String? _station(List<String> upper) {
    for (final entry in _brands.entries) {
      if (upper.any((l) => l.contains(entry.key))) return entry.value;
    }
    if (upper.any((l) => _hasWord(l, 'IP'))) return 'IP';
    if (upper.any((l) => _hasWord(l, 'API'))) return 'Api';
    return null;
  }

  bool _hasWord(String line, String word) =>
      RegExp('\\b$word\\b').hasMatch(line);

  /// First number on a line matching [marker]. Handles "28,50" and "1.789".
  double? _numNear(List<String> upper, RegExp marker) {
    final numRe = RegExp(r'(\d+[.,]\d+)');
    for (final l in upper) {
      if (!marker.hasMatch(l)) continue;
      final m = numRe.firstMatch(l);
      if (m != null) {
        return double.tryParse(m.group(1)!.replaceAll(',', '.'));
      }
    }
    return null;
  }

  DateTime? _date(String text) {
    final m = RegExp(r'(\d{2})[/.\-](\d{2})[/.\-](\d{4})').firstMatch(text);
    if (m == null) return null;
    final d = int.tryParse(m.group(1)!);
    final mo = int.tryParse(m.group(2)!);
    final y = int.tryParse(m.group(3)!);
    if (d == null || mo == null || y == null) return null;
    if (mo < 1 || mo > 12 || d < 1 || d > 31) return null;
    return DateTime(y, mo, d);
  }
}
