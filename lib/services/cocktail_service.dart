import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cocktail.dart';

class CocktailService {
  static const String baseUrl = 'https://www.thecocktaildb.com/api/json/v1/1';
  
  Future<List<Cocktail>> getCocktails({int page = 1}) async {
    // Calculate the letter based on the page number to simulate pagination
    // This is needed because the API doesn't support traditional pagination
    String letter = String.fromCharCode('a'.codeUnitAt(0) + (page - 1) % 26);
    
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?f=$letter')
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> drinks = data['drinks'] ?? [];
      
      if (drinks.isEmpty) {
        return [];
      }
      
      return drinks.map((json) => Cocktail.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cocktails');
    }
  }

  Future<List<Cocktail>> searchCocktails(String query) async {
    if (query.isEmpty) return [];
    
    try {
      // Endpoint de busca por nome na API TheCocktailDB
      // Use baseUrl da própria classe, não de ApiConfig
      final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['drinks'] == null) {
          return [];
        }
        
        final List<dynamic> drinksJson = data['drinks'];
        
        return drinksJson.map((json) => Cocktail.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search cocktails - Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching cocktails: $e');
    }
  }
}