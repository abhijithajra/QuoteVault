import 'package:flutter/material.dart';

import '../config/supabase.dart';
import '../models/quote.dart';

class QuoteProvider extends ChangeNotifier {
  final List<Quote> _quotes = [];
  bool loading = false;
  int _page = 0;
  bool _hasMore = true;
  final int _limit = 20;

  Quote? _daily;
  Quote? get dailyQuote => _daily;


  List<Quote> get quotes => List.unmodifiable(_quotes);

  Future<void> loadQuotes({bool reset = false}) async {
    if (reset) {
      _page = 0;
      _hasMore = true;
      _quotes.clear();
    }

    if (!_hasMore) return;

    loading = true;
    notifyListeners();

    final res = await supabase
        .from('quotes')
        .select()
        .range(_page * _limit, (_page + 1) * _limit - 1);

    if (res.isEmpty) {
      _hasMore = false;
    } else {
      _quotes.addAll(res.map((e) => Quote.fromJson(e)));
      _page++;
    }

    loading = false;
    notifyListeners();
  }

  List<Quote> byCategory(String c) =>
      _quotes.where((q) => q.category == c).toList();

  List<Quote> search(String q) {
    final t = q.toLowerCase();
    return _quotes.where((e) =>
    e.text.toLowerCase().contains(t) ||
        e.author.toLowerCase().contains(t)).toList();
  }

  Future<void> loadDailyQuote() async {
    final res = await supabase.rpc('get_daily_quote');

    if (res == null || (res as List).isEmpty) {
      _daily = null;
    } else {
      _daily = Quote.fromJson(res[0]);
    }

    notifyListeners();
  }
}
