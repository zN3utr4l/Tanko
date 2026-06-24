import '../models/enums.dart';

class VehicleLookupData {
  const VehicleLookupData({
    this.plate,
    this.make,
    this.model,
    this.trim,
    this.year,
    this.fuelType,
    this.euroClass,
    this.powerPs,
    this.insuranceCompany,
    this.insuranceExpiry,
  });

  final String? plate;
  final String? make;
  final String? model;
  final String? trim;
  final int? year;
  final FuelType? fuelType;
  final EuroClass? euroClass;
  final int? powerPs;
  final String? insuranceCompany;
  final DateTime? insuranceExpiry;

  bool get hasVehicleFields =>
      plate != null ||
      make != null ||
      model != null ||
      trim != null ||
      year != null ||
      fuelType != null ||
      euroClass != null ||
      powerPs != null;

  bool get hasRecognizedFields => recognizedFieldLabels.isNotEmpty;

  List<String> get recognizedFieldLabels => [
    if (plate != null) 'Targa',
    if (make != null) 'Marca',
    if (model != null) 'Modello',
    if (trim != null) 'Allestimento',
    if (year != null) 'Anno',
    if (fuelType != null) 'Carburante',
    if (euroClass != null) 'Classe Euro',
    if (powerPs != null) 'Potenza',
    if (insuranceCompany != null) 'Compagnia RCA',
    if (insuranceExpiry != null) 'Scadenza RCA',
  ];
}

class VehicleLookupService {
  const VehicleLookupService();

  static final _nonPlateChars = RegExp(r'[^A-Za-z0-9]');
  static final _yearRe = RegExp(r'(19|20)\d{2}');
  static final _powerRe = RegExp(
    r'(\d+(?:[,.]\d+)?)\s*(cv|kw)\b',
    caseSensitive: false,
  );
  static final _twoOrMoreSpaces = RegExp(r'\s{2,}');
  static final _whitespace = RegExp(r'\s+');

  String normalizePlate(String value) =>
      value.replaceAll(_nonPlateChars, '').toUpperCase();

  Uri insuranceVerificationUri(String plate) => Uri.parse(
    'https://www.ilportaledellautomobilista.it/web/portale-automobilista/ext/verifica-copertura-rc',
  );

  Uri environmentalClassVerificationUri(String plate) => Uri.parse(
    'https://www.ilportaledellautomobilista.it/web/portale-automobilista/ext/verifica-classe-ambientale-veicolo',
  );

  VehicleLookupData parsePastedText(String text) {
    final plate = _firstValue(text, const ['targa']);
    final yearRaw = _firstValue(text, const [
      'anno',
      'anno immatricolazione',
      'data immatricolazione',
      'immatricolazione',
    ]);
    final powerRaw = _firstValue(text, const ['potenza', 'potenza massima']);
    final insuranceExpiryRaw = _firstValue(text, const [
      'scadenza assicurazione',
      'scadenza rca',
      'scadenza copertura',
    ]);

    return VehicleLookupData(
      plate: plate == null ? null : normalizePlate(plate),
      make: _firstValue(text, const ['marca', 'costruttore']),
      model: _firstValue(text, const ['modello']),
      trim: _firstValue(text, const ['allestimento', 'versione']),
      year: _parseYear(yearRaw),
      fuelType: _parseFuel(
        _firstValue(text, const ['alimentazione', 'carburante', 'fuel']),
      ),
      euroClass: _parseEuroClass(
        _firstValue(text, const ['classe ambientale', 'classe euro', 'euro']),
      ),
      powerPs: _parsePowerPs(powerRaw),
      insuranceCompany: _firstValue(text, const [
        'assicurazione',
        'compagnia',
        'compagnia assicurativa',
      ]),
      insuranceExpiry: _parseItalianDate(insuranceExpiryRaw),
    );
  }

  String? _firstValue(String text, List<String> labels) {
    final inlineValue = _firstInlineValue(text, labels);
    if (inlineValue != null) return inlineValue;

    final normalizedLabels = labels.map(_normalizeLabel).toList();
    final twoColumnValue = _firstTwoColumnValue(text, normalizedLabels);
    if (twoColumnValue != null) return twoColumnValue;

    return _firstHeaderTableValue(text, normalizedLabels);
  }

  String? _firstInlineValue(String text, List<String> labels) {
    for (final line in text.split(RegExp(r'\r?\n'))) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      for (final label in labels) {
        final match = RegExp(
          '^${RegExp.escape(label)}\\s*[:=-]\\s*(.+)\$',
          caseSensitive: false,
        ).firstMatch(trimmed);
        if (match != null) {
          final value = _cleanValue(match.group(1)!);
          if (value != null) return value;
        }
      }
    }
    return null;
  }

  String? _firstTwoColumnValue(String text, List<String> normalizedLabels) {
    for (final row in _tableRows(text)) {
      if (row.length != 2) continue;
      if (!_labelMatches(row.first, normalizedLabels)) continue;
      final value = _cleanValue(row.last);
      if (value != null) return value;
    }
    return null;
  }

  String? _firstHeaderTableValue(String text, List<String> normalizedLabels) {
    final rows = _tableRows(text);
    for (var i = 0; i < rows.length - 1; i++) {
      final headers = rows[i];
      if (headers.length < 2) continue;
      final index = headers.indexWhere(
        (cell) => _labelMatches(cell, normalizedLabels),
      );
      if (index == -1) continue;

      for (var j = i + 1; j < rows.length; j++) {
        final values = rows[j];
        if (values.length <= index) continue;
        final value = _cleanValue(values[index]);
        if (value != null) return value;
      }
    }
    return null;
  }

  List<List<String>> _tableRows(String text) => [
    for (final line in text.split(RegExp(r'\r?\n')))
      if (_splitTableRow(line).length >= 2) _splitTableRow(line),
  ];

  List<String> _splitTableRow(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return const [];

    late final List<String> cells;
    if (trimmed.contains('\t')) {
      cells = trimmed.split('\t');
    } else if (trimmed.contains(';')) {
      cells = trimmed.split(';');
    } else if (trimmed.contains('|')) {
      cells = trimmed.split('|');
    } else if (_twoOrMoreSpaces.hasMatch(trimmed)) {
      cells = trimmed.split(_twoOrMoreSpaces);
    } else {
      return const [];
    }

    return [
      for (final cell in cells)
        if (cell.trim().isNotEmpty) cell.trim(),
    ];
  }

  bool _labelMatches(String candidate, List<String> normalizedLabels) {
    final normalized = _normalizeLabel(candidate);
    if (normalized.isEmpty) return false;
    return normalizedLabels.any(
      (label) => normalized == label || normalized.contains(label),
    );
  }

  String _normalizeLabel(String value) {
    final lower = value
        .toLowerCase()
        .replaceAll(RegExp('[àáâä]'), 'a')
        .replaceAll(RegExp('[èéêë]'), 'e')
        .replaceAll(RegExp('[ìíîï]'), 'i')
        .replaceAll(RegExp('[òóôö]'), 'o')
        .replaceAll(RegExp('[ùúûü]'), 'u');
    return lower.replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
  }

  String? _cleanValue(String value) {
    final cleaned = value.trim().replaceAll(_whitespace, ' ');
    if (cleaned.isEmpty || cleaned == '-' || cleaned == '—') return null;
    return cleaned;
  }

  int? _parseYear(String? value) {
    if (value == null) return null;
    final match = _yearRe.firstMatch(value);
    if (match == null) return null;
    final year = int.tryParse(match.group(0)!);
    if (year == null || year < 1980 || year > DateTime.now().year + 1) {
      return null;
    }
    return year;
  }

  FuelType? _parseFuel(String? value) {
    if (value == null) return null;
    final v = value.toLowerCase();
    if (v.contains('benzina') || v.contains('petrol')) return FuelType.petrol;
    if (v.contains('diesel') || v.contains('gasolio')) return FuelType.diesel;
    if (v.contains('gpl') || v.contains('lpg')) return FuelType.lpg;
    if (v.contains('metano') || v.contains('cng')) return FuelType.cng;
    if (v.contains('ibrid') || v.contains('hybrid')) return FuelType.hybrid;
    if (v.contains('elettr') || v.contains('electric')) {
      return FuelType.electric;
    }
    return null;
  }

  EuroClass? _parseEuroClass(String? value) {
    if (value == null) return null;
    final match = RegExp(
      r'euro\s*([0-6])',
      caseSensitive: false,
    ).firstMatch(value);
    if (match == null) return null;
    return EuroClass.values[int.parse(match.group(1)!)];
  }

  int? _parsePowerPs(String? value) {
    if (value == null) return null;
    final match = _powerRe.firstMatch(value);
    if (match == null) return null;
    final amount = double.tryParse(match.group(1)!.replaceAll(',', '.'));
    if (amount == null) return null;
    final unit = match.group(2)!.toLowerCase();
    return unit == 'kw' ? (amount * 1.35962).round() : amount.round();
  }

  DateTime? _parseItalianDate(String? value) {
    if (value == null) return null;
    final match = RegExp(
      r'(\d{1,2})[/-](\d{1,2})[/-](\d{4})',
    ).firstMatch(value);
    if (match == null) return null;
    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final year = int.parse(match.group(3)!);
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }
}
