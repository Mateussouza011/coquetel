import 'cocktail.dart';

class MockCocktails {
  static List<Cocktail> getMockCocktails() {
    return [
      Cocktail(
        id: 'mock-1',
        name: 'Mojito',
        category: 'Cocktail',
        instructions: 'Muddle mint leaves with sugar and lime juice. Add a splash of soda water and fill the glass with cracked ice. Pour the rum and top with soda water. Garnish with mint leaves and a lime wedge.',
        imageUrl: 'https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg',
        ingredients: [
          CocktailIngredient(name: 'White rum', measure: '2-3 oz'),
          CocktailIngredient(name: 'Lime juice', measure: '1 oz'),
          CocktailIngredient(name: 'Sugar', measure: '2 tsp'),
          CocktailIngredient(name: 'Mint', measure: '6 leaves'),
          CocktailIngredient(name: 'Soda water', measure: 'Top'),
        ],
      ),
      Cocktail(
        id: 'mock-2',
        name: 'Margarita',
        category: 'Ordinary Drink',
        instructions: 'Rub the rim of the glass with the lime slice to make the salt stick to it. Take care to moisten only the outer rim and sprinkle the salt on it. The salt should present to the lips of the imbiber and never mix into the cocktail. Shake the other ingredients with ice, then carefully pour into the glass.',
        imageUrl: 'https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg',
        ingredients: [
          CocktailIngredient(name: 'Tequila', measure: '1 1/2 oz'),
          CocktailIngredient(name: 'Triple sec', measure: '1/2 oz'),
          CocktailIngredient(name: 'Lime juice', measure: '1 oz'),
          CocktailIngredient(name: 'Salt', measure: 'pinch'),
        ],
      ),
      Cocktail(
        id: 'mock-3',
        name: 'Piña Colada',
        category: 'Cocktail',
        instructions: 'Mix with crushed ice in blender until smooth. Pour into chilled glass, garnish and serve.',
        imageUrl: 'https://www.thecocktaildb.com/images/media/drink/cpf4j51504371346.jpg',
        ingredients: [
          CocktailIngredient(name: 'White rum', measure: '3 oz'),
          CocktailIngredient(name: 'Coconut cream', measure: '3 tbsp'),
          CocktailIngredient(name: 'Pineapple juice', measure: '3 oz'),
        ],
      ),
    ];
  }
}