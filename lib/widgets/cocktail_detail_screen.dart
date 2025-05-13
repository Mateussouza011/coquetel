import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../l10n/app_localizations.dart';

class CocktailDetailScreen extends StatelessWidget {
  final Cocktail cocktail;
  
  const CocktailDetailScreen({Key? key, required this.cocktail}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero animation for smooth transition from card
            Hero(
              tag: 'cocktail-${cocktail.id}',
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  cocktail.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.error)),
                    );
                  },
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name with larger font
                  Text(
                    cocktail.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16.0),
                  
                  // Category with nice styling
                  Row(
                    children: [
                      Icon(Icons.category, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        localizations.categoryLabel(cocktail.category),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24.0),
                  
                  // Instructions section
                  Text(
                    localizations.instructionsTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12.0),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cocktail.instructions,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
