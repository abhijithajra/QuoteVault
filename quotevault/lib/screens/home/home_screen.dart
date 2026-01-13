import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/quote_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/settings_provider.dart';
import '../../models/quote.dart';
import '../../widgets/favorite_button.dart';
import '../auth/profile_screen.dart';
import '../share/share_screen.dart';
import '../favorites/favorites_screen.dart';
import '../collections/collections_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String search = '';
  String category = 'All';

  final categories = const [
    'All',
    'Motivation',
    'Love',
    'Success',
    'Wisdom',
    'Humor'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuoteProvider>().loadQuotes();
      context.read<FavoritesProvider>().loadFavorites();
      context.read<QuoteProvider>().loadDailyQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    final qp = context.watch<QuoteProvider>();
    final daily = qp.dailyQuote;
    final accent = context.watch<SettingsProvider>().accentColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    List<Quote> list = qp.quotes;
    if (category != 'All') list = qp.byCategory(category);
    if (search.isNotEmpty) list = qp.search(search);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("QuoteVault"),
        actions: [
          _nav(Icons.person, const ProfileScreen(), accent),
          _nav(Icons.favorite, const FavoritesScreen(), accent),
          _nav(Icons.folder, const CollectionsScreen(), accent),
          _nav(Icons.settings, const SettingsScreen(), accent),
        ],
      ),
      body: qp.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          if (daily != null) _hero(daily),

          // 🔍 Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => search = v),
                      style: TextStyle(fontSize: 15, color: onSurface),
                      decoration: const InputDecoration(
                        hintText: "Search quotes or authors",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (search.isNotEmpty)
                    GestureDetector(
                      onTap: () => setState(() => search = ''),
                      child:
                      Icon(Icons.close, size: 18, color: accent),
                    ),
                ],
              ),
            ),
          ),

          // 🧩 Categories
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: categories.map((c) {
                final sel = c == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () => setState(() => category = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: sel ? accent : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          if (!sel)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                            )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          c,
                          style: GoogleFonts.inter(
                            color: sel
                                ? Colors.white
                                : onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // 📜 Quotes
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  search = '';
                  category = 'All';
                });
                await context.read<QuoteProvider>().loadQuotes(reset: true);
              },
              child: list.isEmpty
                  ? ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text("No quotes found")),
                ],
              )
                  : ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) => _quoteCard(list[i], onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🌞 Hero
  Widget _hero(Quote q) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B5CF6), Color(0xFF4BC6B9)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B5CF6).withOpacity(.35),
            blurRadius: 30,
            offset: const Offset(0, 15),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quote of the Day",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Text(
            q.text,
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(q.author,
              style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // 📖 Quote card
  Widget _quoteCard(Quote q, Color onSurface) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      decoration: _card(),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ShareQuoteScreen(q.text, q.author)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                q.text,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  height: 1.5,
                  color: onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      q.author,
                      style: TextStyle(
                          color:
                          Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  FavoriteButton(quote: q),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _card() => BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );

  Widget _nav(IconData i, Widget s, Color accent) => IconButton(
    icon: Icon(i, color: accent),
    onPressed: () =>
        Navigator.push(context, MaterialPageRoute(builder: (_) => s)),
  );
}
