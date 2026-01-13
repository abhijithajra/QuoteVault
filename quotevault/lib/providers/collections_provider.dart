import 'package:flutter/material.dart';
import '../config/supabase.dart';
import '../models/quote.dart';

class Collection {
  final String id;
  final String name;
  Collection(this.id, this.name);
}

class CollectionsProvider extends ChangeNotifier {
  final List<Collection> _collections = [];
  List<Collection> get collections => _collections;

  Future<void> load() async {
    final user = supabase.auth.currentUser!;
    final res = await supabase
        .from('collections')
        .select()
        .eq('user_id', user.id);

    _collections.clear();
    _collections.addAll(
        (res as List).map((e) => Collection(e['id'], e['name'])));
    notifyListeners();
  }

  Future<void> create(String name) async {
    final user = supabase.auth.currentUser!;
    await supabase.from('collections').insert({
      'user_id': user.id,
      'name': name,
    });
    await load();
  }

  Future<void> addQuote(String collectionId, String quoteId) async {
    await supabase.from('collection_quotes').insert({
      'collection_id': collectionId,
      'quote_id': quoteId,
    });
  }

  Future<List<Quote>> quotesIn(String collectionId) async {
    final res = await supabase
        .from('collection_quotes')
        .select('quotes(*)')
        .eq('collection_id', collectionId);

    return (res as List).map((e) => Quote.fromJson(e['quotes'])).toList();
  }

  Future<void> removeQuote(String collectionId, String quoteId) async {
    await supabase
        .from('collection_quotes')
        .delete()
        .eq('collection_id', collectionId)
        .eq('quote_id', quoteId);
  }

  Future<void> deleteCollection(String id) async {
    await supabase.from('collections').delete().eq('id', id);
    await load();
  }
}
