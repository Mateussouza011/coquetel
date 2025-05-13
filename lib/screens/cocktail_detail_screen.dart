import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../l10n/app_localizations.dart';

class CocktailDetailScreen extends StatelessWidget {
  final Cocktail cocktail;
  
  const CocktailDetailScreen({Key? key, required this.cocktail}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail.name),
      ),
      body: SafeArea(
        child: isDesktop 
            ? _buildDesktopLayout(context, localizations) 
            : _buildMobileLayout(context, localizations),
      ),
    );
  }
  
  Widget _buildMobileLayout(BuildContext context, AppLocalizations localizations) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem com altura controlada
          SizedBox(
            height: 200, // Altura fixa para a imagem
            width: double.infinity,
            child: Image.network(
              cocktail.imageUrl,
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
          
          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildCocktailInfo(context, localizations),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDesktopLayout(BuildContext context, AppLocalizations localizations) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagem à esquerda (40% da largura)
        Flexible(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                cocktail.imageUrl,
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
        ),
        
        // Informações à direita (60% da largura)
        Flexible(
          flex: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _buildCocktailInfo(context, localizations),
          ),
        ),
      ],
    );
  }
  
  Widget _buildCocktailInfo(BuildContext context, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nome do coquetel
        Text(
          cocktail.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16.0),
        
        // Categoria
        _buildInfoItem(
          context, 
          localizations.categoryLabel(cocktail.category),
          Icons.category
        ),
        
        const Divider(height: 24.0),
        
        // Ingredientes
        Text(
          localizations.ingredientsTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8.0),
        
        // Lista de ingredientes
        _buildIngredientsList(context),
        
        const SizedBox(height: 24.0),
        
        // Instruções
        Text(
          localizations.instructionsTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            cocktail.instructions,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
  
  Widget _buildIngredientsList(BuildContext context) {
    if (cocktail.ingredients.isEmpty) {
      return Text(
        "Não foram encontrados ingredientes para este coquetel.",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
        ),
      );
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: cocktail.ingredients.map((ingredient) {
          return ListTile(
            leading: Icon(
              Icons.local_bar,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              ingredient.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: ingredient.measure.isNotEmpty
                ? Text(
                    ingredient.measure,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : null,
            dense: true,
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildInfoItem(BuildContext context, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}