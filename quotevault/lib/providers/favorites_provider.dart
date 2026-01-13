import 'package:flutter/material.dart';
import '../config/supabase.dart';
import '../models/quote.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Quote> _favorites = [];

  List<Quote> get favorites => _favorites;

  Future<void> loadFavorites() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final res = await supabase
        .from('favorites')
        .select('quotes(*)')
        .eq('user_id', user.id);

    _favorites
      ..clear()
      ..addAll((res as List).map((e) => Quote.fromJson(e['quotes'])));

    notifyListeners();
  }


  bool isFavorite(String quoteId) =>
      _favorites.any((q) => q.id == quoteId);

  Future<void> toggleFavorite(Quote q) async {
    final user = supabase.auth.currentUser!;

    if (isFavorite(q.id)) {
      await supabase
          .from('favorites')
          .delete()
          .match({'user_id': user.id, 'quote_id': q.id});
    } else {
      await supabase
          .from('favorites')
          .insert({'user_id': user.id, 'quote_id': q.id});
    }

    await loadFavorites();
  }
}
