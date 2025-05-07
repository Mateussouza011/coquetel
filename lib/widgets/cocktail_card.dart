import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../screens/cocktail_detail_screen.dart';

class CocktailCard extends StatelessWidget {
  final Cocktail cocktail;
  final bool isCompact;
  
  const CocktailCard({
    Key? key, 
    required this.cocktail,
    this.isCompact = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isCompact ? 2.0 : 3.0,
      margin: isCompact 
          ? const EdgeInsets.all(4.0)
          : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CocktailDetailScreen(cocktail: cocktail),
            ),
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
          ],
        ),
      ),
    );
  }
}
