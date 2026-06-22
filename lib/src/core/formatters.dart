import 'package:intl/intl.dart';

final _euro = NumberFormat.currency(locale: 'it_IT', symbol: '€');
final _num1 = NumberFormat('#,##0.0', 'it_IT');
final _num0 = NumberFormat('#,##0', 'it_IT');
final _date = DateFormat('dd/MM/yyyy');

String fmtEuro(num v) => _euro.format(v);
String fmtLiters(num v) => '${_num1.format(v)} L';
String fmtKm(num v) => '${_num0.format(v)} km';
String fmtConsumption(num v) => '${_num1.format(v)} L/100km';
String fmtDate(DateTime d) => _date.format(d);
