import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  // Factory constructor para criar a instância correta
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? 
        AppLocalizations(const Locale('pt')); // Fallback para português
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  // Dicionário de traduções
  static const Map<String, Map<String, String>> _localizedValues = {
    'pt': {
      'appTitle': 'Linha do Tempo de Coquetéis',
      'searchHint': 'Buscar coquetéis...',
      'noResults': 'Nenhum coquetel encontrado',
      'noMatchingResults': 'Nenhum coquetel corresponde à sua busca',
      'resultsCount': 'Encontrados {} coquetéis',
      'categoryLabel': 'Categoria: {}',
      'ingredientsTitle': 'Ingredientes',
      'instructionsTitle': 'Instruções',
      'loadingMessage': 'Carregando coquetéis...',
      'categoryFilter': 'Categoria:',
      'allCategories': 'Todas',
      'loadingCategories': 'Carregando categorias...',
      'noIngredients': 'Não foram encontrados ingredientes para este coquetel.'
    },
    'en': {
      'appTitle': 'Cocktail Timeline',
      'searchHint': 'Search cocktails...',
      'noResults': 'No cocktails found',
      'noMatchingResults': 'No cocktails match your search',
      'resultsCount': 'Found {} cocktails',
      'categoryLabel': 'Category: {}',
      'ingredientsTitle': 'Ingredients',
      'instructionsTitle': 'Instructions',
      'loadingMessage': 'Loading cocktails...',
      'categoryFilter': 'Category:',
      'allCategories': 'All',
      'loadingCategories': 'Loading categories...',
      'noIngredients': 'No ingredients found for this cocktail.'
    },
    'es': {
      'appTitle': 'Línea de Tiempo de Cócteles',
      'searchHint': 'Buscar cócteles...',
      'noResults': 'No se encontraron cócteles',
      'noMatchingResults': 'Ningún cóctel coincide con tu búsqueda',
      'resultsCount': 'Encontrados {} cócteles',
      'categoryLabel': 'Categoría: {}',
      'ingredientsTitle': 'Ingredientes',
      'instructionsTitle': 'Instrucciones',
      'loadingMessage': 'Cargando cócteles...',
      'categoryFilter': 'Categoría:',
      'allCategories': 'Todas',
      'loadingCategories': 'Cargando categorías...',
      'noIngredients': 'No se encontraron ingredientes para este cóctel.'
    },
    'fr': {
      'appTitle': 'Chronologie des Cocktails',
      'searchHint': 'Rechercher des cocktails...',
      'noResults': 'Aucun cocktail trouvé',
      'noMatchingResults': 'Aucun cocktail ne correspond à votre recherche',
      'resultsCount': 'Trouvé {} cocktails',
      'categoryLabel': 'Catégorie: {}',
      'ingredientsTitle': 'Ingrédients',
      'instructionsTitle': 'Instructions',
      'loadingMessage': 'Chargement des cocktails...',
      'categoryFilter': 'Catégorie:',
      'allCategories': 'Toutes',
      'loadingCategories': 'Chargement des catégories...',
      'noIngredients': 'Aucun ingrédient trouvé pour ce cocktail.'
    },
  };
  
  // Métodos getter para cada texto traduzível
  String get appTitle {
    return _getLocalizedValue('appTitle');
  }
  
  String get searchHint {
    return _getLocalizedValue('searchHint');
  }
  
  String get noResults {
    return _getLocalizedValue('noResults');
  }
  
  String get noMatchingResults {
    return _getLocalizedValue('noMatchingResults');
  }
  
  String resultsCount(int count) {
    String template = _getLocalizedValue('resultsCount');
    return template.replaceAll('{}', count.toString());
  }
  
  String categoryLabel(String category) {
    String template = _getLocalizedValue('categoryLabel');
    return template.replaceAll('{}', category);
  }
  
  String get ingredientsTitle {
    return _getLocalizedValue('ingredientsTitle');
  }
  
  String get instructionsTitle {
    return _getLocalizedValue('instructionsTitle');
  }
  
  String get loadingMessage {
    return _getLocalizedValue('loadingMessage');
  }
  
  String get categoryFilter {
    return _getLocalizedValue('categoryFilter');
  }
  
  String get allCategories {
    return _getLocalizedValue('allCategories');
  }
  
  String get loadingCategories {
    return _getLocalizedValue('loadingCategories');
  }
  
  String get noIngredients {
    return _getLocalizedValue('noIngredients');
  }

  String get errorLoadingData => 'Erro ao carregar os dados. Por favor, tente novamente.';
  String get tryAgain => 'Tentar Novamente';
  
  // Método auxiliar para buscar valor no dicionário
  String _getLocalizedValue(String key) {
    // Tenta obter o valor no idioma atual
    final localizedValues = _localizedValues[locale.languageCode];
    if (localizedValues != null && localizedValues.containsKey(key)) {
      return localizedValues[key]!;
    }
    
    // Fallback para inglês
    return _localizedValues['en']![key]!;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'pt', 'es', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}