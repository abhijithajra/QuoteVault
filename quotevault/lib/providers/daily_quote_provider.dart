import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../config/supabase.dart';

class QuoteProvider extends ChangeNotifier {
  final List<Quote> _quotes = [];
  bool loading = false;

  List<Quote> get quotes => _quotes;

  Future<void> loadQuotes() async {
    loading = true;
    notifyListeners();

    final res = await supabase.from('quotes').select();
    _quotes.clear();
    _quotes.addAll((res as List).map((e) => Quote.fromJson(e)));

    loading = false;
    notifyListeners();
  }

  Quote? get dailyQuote {
    if (_quotes.isEmpty) return null;
    final day = DateTime.now().day;
    return _quotes[day % _quotes.length];
  }

  List<Quote> byCategory(String cat) =>
      _quotes.where((q) => q.category == cat).toList();

  List<Quote> search(String query) {
    final q = query.toLowerCase().trim();
    return _quotes.where((e) =>
    e.text.toLowerCase().contains(q) ||
        e.author.toLowerCase().contains(q)
    ).toList();
  }
}
