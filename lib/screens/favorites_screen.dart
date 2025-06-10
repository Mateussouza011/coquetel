import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/favorites_provider.dart';
import '../widgets/cocktail_card.dart';
import '../routes/app_routes.dart';
import '../widgets/app_bottom_nav.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final favorites = Provider.of<FavoritesProvider>(context);
    final favoritesList = favorites.items.values.toList();
    
    // Check if we're on a large screen
    final isLargeScreen = MediaQuery.of(context).size.width > 900;
    final cardCrossAxisCount = isLargeScreen ? 3 : 1;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.favorites ?? "Favorites"),
      ),
      body: favoritesList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.noFavorites ?? "No favorites yet",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.timeline);
                    },
                    child: Text(localizations.exploreMore ?? "Explore Cocktails"),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cardCrossAxisCount,
                childAspectRatio: isLargeScreen ? 1.2 : 1.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favoritesList.length,
              itemBuilder: (ctx, i) => CocktailCard(
                cocktail: favoritesList[i],
                isCompact: isLargeScreen,
              ),
            ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}