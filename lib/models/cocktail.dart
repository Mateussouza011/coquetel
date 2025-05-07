class Cocktail {
  final String id;
  final String name;
  final String category;
  final String instructions;
  final String imageUrl;
  final List<CocktailIngredient> ingredients;
  
  Cocktail({
    required this.id,
    required this.name,
    required this.category,
    required this.instructions,
    required this.imageUrl,
    required this.ingredients,
  });
  
  factory Cocktail.fromJson(Map<String, dynamic> json) {
    // Extrair ingredientes e medidas
    List<CocktailIngredient> ingredients = [];
    
    // A API armazena ingredientes em strIngredient1, strIngredient2, etc.
    for (int i = 1; i <= 15; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];
      
      // Adicionar apenas se existir um ingrediente
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add(
          CocktailIngredient(
            name: ingredient.trim(),
            measure: measure?.trim() ?? '',
          )
        );
      }
    }
    
    return Cocktail(
      id: json['idDrink'] ?? '',
      name: json['strDrink'] ?? '',
      category: json['strCategory'] ?? 'Unknown',
      instructions: json['strInstructions'] ?? '',
      imageUrl: json['strDrinkThumb'] ?? '',
      ingredients: ingredients,
    );
  }
}

class CocktailIngredient {
  final String name;
  final String measure;
  
  CocktailIngredient({
    required this.name,
    required this.measure,
  });
}
