import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cocktail.dart';
import '../core/app_core.dart';
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
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isDemoItem 
              ? null
              : () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.cocktailDetail,
                    arguments: cocktail,
                  );
                },
          borderRadius: BorderRadius.circular(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calcular altura disponível para o conteúdo
              final imageHeight = constraints.maxWidth * 9 / 16; // Aspect ratio 16:9
              final availableContentHeight = constraints.maxHeight - imageHeight;
              
              return SizedBox(
                height: constraints.maxHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container da imagem com altura fixa
                    SizedBox(
                      height: imageHeight,
                      child: Stack(
                        children: [
                          // Imagem
                          SizedBox.expand(
                            child: Image.network(
                              cocktail.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.local_bar,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[300],
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
                            ),
                          ),
                          
                          // Botão de favorito
                          if (!isDemoItem)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (isFavorite) {
                                        favoritesProvider.removeFavorite(cocktail.id);
                                      } else {
                                        favoritesProvider.addFavorite(cocktail);
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorite ? Colors.red : Colors.grey[600],
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    // Conteúdo com altura restrita
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LayoutBuilder(
                          builder: (context, contentConstraints) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Nome do coquetel
                                Flexible(
                                  child: Text(
                                    cocktail.name,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Categoria
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    cocktail.category,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Instruções com altura flexível
                                Expanded(
                                  child: Text(
                                    cocktail.instructions,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: isCompact ? 2 : 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
