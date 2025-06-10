import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cocktail.dart';
import '../routes/app_routes.dart';
import '../providers/favorites_provider.dart';

class CocktailCard extends StatelessWidget {
  final Cocktail cocktail;
  final bool isCompact;
  final bool isDemoItem;
  
  const CocktailCard({
    Key? key, 
    required this.cocktail,
    this.isCompact = false,
    this.isDemoItem = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(cocktail.id);
    
    // Se for um item de demo, use um estilo visual diferente
    final demoHighlight = isDemoItem
        ? BoxDecoration(
            border: Border.all(
              color: cocktail.id == 'demo-loading' ? Colors.blue : Colors.red,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(16),
          )
        : null;
    
    return Container(
      decoration: demoHighlight,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: isCompact ? 2.0 : 3.0,
        margin: isCompact 
            ? const EdgeInsets.all(4.0)
            : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: InkWell(
          onTap: isDemoItem 
              ? null // Gerenciado pelo _handleDemoItemTap no TimelineScreen
              : () {
                  // Use rota nomeada com passagem de parâmetro
                  Navigator.of(context).pushNamed(
                    AppRoutes.cocktailDetail,
                    arguments: cocktail,
                  );
                },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with proper aspect ratio - wider for compact mode
              AspectRatio(
                aspectRatio: isCompact ? 1.7 : 16 / 9,
                child: Image.network(
                  cocktail.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.error),
                    );
                  },
                ),
              ),
              
              // Content area with better padding - less padding for compact mode
              Padding(
                padding: isCompact 
                    ? const EdgeInsets.all(8.0)
                    : const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cocktail.name,
                      style: isCompact
                          ? Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                          : Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        cocktail.category,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                          fontSize: isCompact ? 10.0 : 12.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!isCompact) const SizedBox(height: 8.0),
                    if (!isCompact || MediaQuery.of(context).size.width > 1200)
                      Text(
                        cocktail.instructions,
                        maxLines: isCompact ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          fontSize: isCompact ? 12.0 : null,
                        ),
                      ),
                  ],
                ),
              ),
              
              // Adicionar botão de favorito
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      favoritesProvider.toggleFavorite(cocktail);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
