import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/market_models.dart';

class LocalStore {
  static const _pricesKey = 'sokobei.prices.v1';
  static const _ledgerKey = 'sokobei.ledger.v1';
  static const _settingsKey = 'sokobei.settings.v1';
  Future<List<PriceObservation>> loadPrices() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_pricesKey);
    if (raw == null) return [];
    try { return (jsonDecode(raw) as List).map((e) => PriceObservation.fromJson(Map<String,dynamic>.from(e))).toList(); }
    catch (_) { return []; }
  }
  Future<List<LedgerEntry>> loadLedger() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_ledgerKey);
    if (raw == null) return [];
    try { return (jsonDecode(raw) as List).map((e) => LedgerEntry.fromJson(Map<String,dynamic>.from(e))).toList(); }
    catch (_) { return []; }
  }
  Future<void> savePrices(List<PriceObservation> items) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_pricesKey, jsonEncode(items.map((e)=>e.toJson()).toList()));
  }
  Future<void> saveLedger(List<LedgerEntry> items) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_ledgerKey, jsonEncode(items.map((e)=>e.toJson()).toList()));
  }
  Future<Map<String,String>> settings() async {
    final p = await SharedPreferences.getInstance();
    return {'theme':p.getString('sokobei.theme') ?? 'Market Obsidian',
      'role':p.getString('sokobei.role') ?? 'Market Lead'};
  }
  Future<void> setSetting(String key, String value) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('sokobei.$key', value);
  }
  Future<int> bytesUsed() async {
    final p = await SharedPreferences.getInstance();
    return utf8.encode(p.getString(_pricesKey) ?? '').length +
      utf8.encode(p.getString(_ledgerKey) ?? '').length;
  }
  Future<void> clearAll() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_pricesKey); await p.remove(_ledgerKey);
  }
}
