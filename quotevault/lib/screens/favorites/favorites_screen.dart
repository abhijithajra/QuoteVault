import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/favorites_provider.dart';
import '../../widgets/favorite_button.dart';
import '../share/share_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoritesProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Favorites")),
      body: fav.favorites.isEmpty
          ? Center(
        child: Text(
          "No favorites yet",
          style: theme.textTheme.bodySmall,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: fav.favorites.length,
        itemBuilder: (_, i) {
          final q = fav.favorites[i];
          return _favoriteCard(theme, q);
        },
      ),
    );
  }

  Widget _favoriteCard(ThemeData theme, dynamic q) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.30 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ShareQuoteScreen(q.text, q.author)),
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
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      q.author,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
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
}
