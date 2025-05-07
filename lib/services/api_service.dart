import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cocktail.dart';
import '../config/api_config.dart';

class ApiService {
  Future<List<Cocktail>> getCocktails({int page = 1, String firstLetter = 'a'}) async {
    // Calculate the letter based on the page number to simulate pagination
    // This is needed because the API doesn't support traditional pagination
    String letter = String.fromCharCode('a'.codeUnitAt(0) + (page - 1) % 26);
    
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/search.php?f=$letter')
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
}
