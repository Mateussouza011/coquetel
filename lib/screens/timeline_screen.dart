import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../widgets/cocktail_card.dart';
import '../services/cocktail_service.dart';
import '../l10n/app_localizations.dart';
import '../services/language_service.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final CocktailService _cocktailService = CocktailService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final LanguageService _languageService = LanguageService();
  
  List<Cocktail> _cocktails = [];
  List<Cocktail> _filteredCocktails = [];
  List<String> _categories = [];
  String? _selectedCategory;
  
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String _searchQuery = '';
  bool _hasError = false;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _loadCocktails();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
        if (!_searchQuery.isNotEmpty && _selectedCategory == null && !_isLoading && _hasMore) {
          _loadMoreCocktails();
        }
      }
    });

    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Cocktail> result = List.from(_cocktails);
    
    // Aplicar filtro de busca por nome, se houver
    if (_searchQuery.isNotEmpty) {
      result = result.where((cocktail) => 
          cocktail.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    // Aplicar filtro de categoria, se um estiver selecionado
    if (_selectedCategory != null) {
      result = result.where((cocktail) => 
          cocktail.category == _selectedCategory
      ).toList();
    }
    
    // Ordenar alfabeticamente
    result.sort((a, b) => a.name.compareTo(b.name));
    
    setState(() {
      _filteredCocktails = result;
    });
  }
  
  Future<void> _loadCocktails() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    
    try {
      final cocktails = await _cocktailService.getCocktails(page: _currentPage);
      
      // Extrair categorias únicas
      Set<String> uniqueCategories = {};
      for (var cocktail in cocktails) {
        if (cocktail.category.isNotEmpty) {
          uniqueCategories.add(cocktail.category);
        }
      }
      
      setState(() {
        _cocktails = cocktails;
        _categories = uniqueCategories.toList()..sort();
        _applyFilters();
        _isLoading = false;
        _hasMore = cocktails.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Erro ao carregar os coquetéis: $e';
      });
    }
  }
  
  Future<void> _loadMoreCocktails() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    
    try {
      _currentPage++;
      final newCocktails = await _cocktailService.getCocktails(page: _currentPage);
      
      // Extract unique categories
      Set<String> uniqueCategories = Set.from(_categories);
      for (var cocktail in newCocktails) {
        if (cocktail.category.isNotEmpty) {
          uniqueCategories.add(cocktail.category);
        }
      }
      
      setState(() {
        _cocktails.addAll(newCocktails);
        _categories = uniqueCategories.toList()..sort();
        _applyFilters();
        _isLoading = false;
        _hasMore = newCocktails.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Erro ao carregar mais coquetéis: $e';
      });
    }
  }
  
  Future<void> _refreshTimeline() async {
    setState(() {
      _currentPage = 1;
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = null;
      _hasError = false;
    });
    return _loadCocktails();
  }
  
  Widget _buildErrorWidget(BuildContext context, AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage.isNotEmpty 
                ? _errorMessage 
                : localizations.errorLoadingData,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshTimeline,
            icon: const Icon(Icons.refresh),
            label: Text(localizations.tryAgain),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Check if we're on a large screen (tablet or desktop)
    final isLargeScreen = MediaQuery.of(context).size.width > 900;
    final cardCrossAxisCount = isLargeScreen ? 3 : 1;
    
    // Get the localization instance
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        centerTitle: true,
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (Locale locale) {
              _languageService.changeLocale(locale);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              const PopupMenuItem<Locale>(
                value: Locale('pt'),
                child: Text('Português'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('en'),
                child: Text('English'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('es'),
                child: Text('Español'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('fr'),
                child: Text('Français'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros - barra de pesquisa e categorias
          if (!_hasError) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: localizations.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),
            
            // Filtro de categoria
            if (_categories.isNotEmpty)
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      localizations.categoryFilter,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _categories.isEmpty 
                          ? Center(child: Text(localizations.loadingCategories))
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  // Opção "Todas"
                                  FilterChip(
                                    label: Text(
                                      localizations.allCategories,
                                      style: TextStyle(
                                        color: _selectedCategory == null 
                                            ? Theme.of(context).colorScheme.onPrimary 
                                            : null,
                                      ),
                                    ),
                                    selected: _selectedCategory == null,
                                    selectedColor: Theme.of(context).colorScheme.primary,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _selectedCategory = null;
                                        _applyFilters();
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  // Chips para cada categoria
                                  ..._categories.map((category) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: FilterChip(
                                      label: Text(
                                        category,
                                        style: TextStyle(
                                          color: _selectedCategory == category 
                                              ? Theme.of(context).colorScheme.onPrimary 
                                              : null,
                                        ),
                                      ),
                                      selected: _selectedCategory == category,
                                      selectedColor: Theme.of(context).colorScheme.primary,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          _selectedCategory = selected ? category : null;
                                          _applyFilters();
                                        });
                                      },
                                    ),
                                  )).toList(),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
          ],
          
          // Contagem de resultados
          if (!_hasError && (_searchQuery.isNotEmpty || _selectedCategory != null))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  localizations.resultsCount(_filteredCocktails.length),
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          
          // Conteúdo principal - Gerenciamento de estados
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshTimeline,
              child: _isLoading && _cocktails.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(localizations.loadingMessage),
                        ],
                      ),
                    )
                  : _hasError
                      ? _buildErrorWidget(context, localizations)
                      : _filteredCocktails.isEmpty
                          ? Center(
                              child: _searchQuery.isNotEmpty || _selectedCategory != null
                                  ? Text(localizations.noMatchingResults)
                                  : Text(localizations.noResults),
                            )
                          : GridView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(8.0),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cardCrossAxisCount,
                                childAspectRatio: isLargeScreen ? 1.2 : 1.0,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: _filteredCocktails.length + 
                                (_hasMore && _searchQuery.isEmpty && _selectedCategory == null ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _filteredCocktails.length) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                
                                return CocktailCard(
                                  cocktail: _filteredCocktails[index],
                                  isCompact: isLargeScreen,
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
