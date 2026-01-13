import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quote.dart';
import '../providers/favorites_provider.dart';
import '../providers/settings_provider.dart';

class FavoriteButton extends StatelessWidget {
  final Quote quote;
  const FavoriteButton({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoritesProvider>();
    final settings = context.watch<SettingsProvider>();
    final isFav = fav.isFavorite(quote.id);

    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isFav),
          color: isFav ? settings.accentColor : Theme.of(context).iconTheme.color,
        ),
      ),
      onPressed: () => fav.toggleFavorite(quote),
    );
  }
}