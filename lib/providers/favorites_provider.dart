import 'package:flutter/foundation.dart';
import '../models/cocktail.dart';

class FavoritesProvider with ChangeNotifier {
  final Map<String, Cocktail> _favorites = {};
  
  Map<String, Cocktail> get items => {..._favorites};
  
  int get count => _favorites.length;
  
  bool isFavorite(String id) {
    return _favorites.containsKey(id);
  }
  
  void toggleFavorite(Cocktail cocktail) {
    if (_favorites.containsKey(cocktail.id)) {
      _favorites.remove(cocktail.id);
    } else {
      _favorites[cocktail.id] = cocktail;
    }
    notifyListeners();
  }
  
  void removeFavorite(String id) {
    _favorites.remove(id);
    notifyListeners();
  }
}