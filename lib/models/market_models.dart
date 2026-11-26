import 'dart:convert';

class PriceObservation {
  PriceObservation({required this.id, required this.commodity, required this.market,
    required this.unit, required this.quantity, required this.price, required this.date,
    this.category = 'Produce', this.note = ''});
  final String id, commodity, market, unit, category, note;
  final double quantity, price;
  final DateTime date;
  double get unitCost => quantity <= 0 ? 0 : price / quantity;
  Map<String, dynamic> toJson() => {'id':id,'commodity':commodity,'market':market,'unit':unit,
    'quantity':quantity,'price':price,'date':date.toIso8601String(),'category':category,'note':note};
  factory PriceObservation.fromJson(Map<String,dynamic> j) => PriceObservation(
    id:j['id'], commodity:j['commodity'], market:j['market'], unit:j['unit'],
    quantity:(j['quantity'] as num).toDouble(), price:(j['price'] as num).toDouble(),
    date:DateTime.parse(j['date']), category:j['category'] ?? 'Produce', note:j['note'] ?? '');
}

class LedgerEntry {
  LedgerEntry({required this.id, required this.commodity, required this.type,
    required this.quantity, required this.amount, required this.date, this.note = ''});
  final String id, commodity, type, note;
  final double quantity, amount;
  final DateTime date;
  Map<String,dynamic> toJson() => {'id':id,'commodity':commodity,'type':type,
    'quantity':quantity,'amount':amount,'date':date.toIso8601String(),'note':note};
  factory LedgerEntry.fromJson(Map<String,dynamic> j) => LedgerEntry(
    id:j['id'], commodity:j['commodity'], type:j['type'],
    quantity:(j['quantity'] as num).toDouble(), amount:(j['amount'] as num).toDouble(),
    date:DateTime.parse(j['date']), note:j['note'] ?? '');
}

String encodeList<T>(List<T> values, Map<String,dynamic> Function(T) encode) =>
    jsonEncode(values.map(encode).toList());
