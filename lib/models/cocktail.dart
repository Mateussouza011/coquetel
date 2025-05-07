class Cocktail {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String instructions;

  Cocktail({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.instructions,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
      id: json['idDrink'] ?? '',
      name: json['strDrink'] ?? '',
      category: json['strCategory'] ?? '',
      imageUrl: json['strDrinkThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
    );
  }
}
