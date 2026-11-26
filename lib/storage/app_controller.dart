import 'package:flutter/foundation.dart';
import '../models/market_models.dart';
import 'local_store.dart';

class AppController extends ChangeNotifier {
  AppController(this.store);
  final LocalStore store;
  List<PriceObservation> prices = [];
  List<LedgerEntry> ledger = [];
  String themeName = 'Market Obsidian';
  String role = 'Market Lead';
  bool ready = false;
  bool get isAdmin => role == 'Market Lead';
  Future<void> load() async {
    prices = await store.loadPrices(); ledger = await store.loadLedger();
    final s = await store.settings(); themeName = s['theme']!; role = s['role']!;
    ready = true; notifyListeners();
  }
  Future<void> addPrice(PriceObservation item) async {
    prices = [item, ...prices]; await store.savePrices(prices); notifyListeners();
  }
  Future<void> addLedger(LedgerEntry item) async {
    ledger = [item, ...ledger]; await store.saveLedger(ledger); notifyListeners();
  }
  Future<void> deleteLedger(String id) async {
    if (!isAdmin) return;
    ledger = ledger.where((e)=>e.id != id).toList();
    await store.saveLedger(ledger); notifyListeners();
  }
  Future<void> setTheme(String value) async {
    themeName = value; await store.setSetting('theme', value); notifyListeners();
  }
  Future<void> setRole(String value) async {
    role = value; await store.setSetting('role', value); notifyListeners();
  }
  double get purchases => ledger.where((e)=>e.type=='Purchase').fold(0.0,(s,e)=>s+e.amount);
  double get revenue => ledger.where((e)=>e.type=='Sale').fold(0.0,(s,e)=>s+e.amount);
  double get waste => ledger.where((e)=>e.type=='Spoilage').fold(0.0,(s,e)=>s+e.amount);
  double get netMargin => revenue - purchases - waste;
  List<PriceObservation> get watchlist => prices.where((p) =>
    p.category.toLowerCase() == 'perishable' ||
    prices.any((q)=>q.commodity==p.commodity && q.id!=p.id && q.unitCost>0 &&
      p.unitCost >= q.unitCost * 1.15)).toList();
}
