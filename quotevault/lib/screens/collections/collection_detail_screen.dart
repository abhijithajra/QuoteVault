import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/collections_provider.dart';
import '../../providers/quote_provider.dart';
import '../../models/quote.dart';
import '../share/share_screen.dart';

class CollectionDetailScreen extends StatefulWidget {
  final dynamic collection;
  const CollectionDetailScreen(this.collection, {super.key});

  @override
  State<CollectionDetailScreen> createState() =>
      _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  List<Quote> quotes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final cp = context.read<CollectionsProvider>();
    quotes = await cp.quotesIn(widget.collection.id);
    if (mounted) setState(() => loading = false);
  }

  Future<void> _addQuote(Quote q) async {
    await context.read<CollectionsProvider>()
        .addQuote(widget.collection.id, q.id);
    await _load();
  }

  Future<void> _removeQuote(Quote q) async {
    await context.read<CollectionsProvider>()
        .removeQuote(widget.collection.id, q.id);
    await _load();
  }

  Future<void> _openAddQuoteSheet() async {
    final selected = await showModalBottomSheet<Quote>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddQuoteSheet(),
    );

    if (selected != null) await _addQuote(selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.collection.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: quotes.isEmpty
                ? Center(
              child: Text(
                "No quotes in this collection",
                style: theme.textTheme.bodySmall,
              ),
            )
                : ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (_, i) => _quoteCard(theme, quotes[i]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _openAddQuoteSheet,
              icon: const Icon(Icons.add),
              label: const Text("Add Quote"),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final theme = Theme.of(context);

    final yes = await showDialog<bool>(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_outline,
                    size: 42, color: Colors.redAccent),
                const SizedBox(height: 20),
                Text("Delete this collection?",
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Text(
                  "This collection and all quotes will be permanently removed.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: const Text("Delete"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

    if (yes == true) {
      await context
          .read<CollectionsProvider>()
          .deleteCollection(widget.collection.id);
      if (mounted) Navigator.pop(context);
    }
  }

  Widget _quoteCard(ThemeData theme, Quote q) {
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShareQuoteScreen(q.text, q.author),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
              blurRadius: 25,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 52, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.text,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text(q.author, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Positioned(
              right: 14,
              top: 14,
              child: GestureDetector(
                onTap: () => _removeQuote(q),
                child: const Icon(Icons.close, color: Colors.redAccent),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AddQuoteSheet extends StatefulWidget {
  const _AddQuoteSheet();

  @override
  State<_AddQuoteSheet> createState() => _AddQuoteSheetState();
}

class _AddQuoteSheetState extends State<_AddQuoteSheet> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final qp = context.watch<QuoteProvider>();
    final theme = Theme.of(context);
    final quotes = qp.search(search);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius:
          const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (v) => setState(() => search = v),
                decoration: const InputDecoration(
                  hintText: "Search quotes...",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: quotes.length,
                itemBuilder: (_, i) {
                  final q = quotes[i];
                  return ListTile(
                    title: Text(q.text,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(q.author),
                    trailing: const Icon(Icons.add_circle),
                    onTap: () => Navigator.pop(context, q),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
