import 'package:flutter/material.dart';
import 'dart:async';
import '../models/cocktail.dart';
import '../widgets/cocktail_card.dart';
import '../services/cocktail_service.dart';
import '../l10n/app_localizations.dart';
import '../services/language_service.dart';
import '../widgets/app_bottom_nav.dart';
import '../core/app_core.dart';

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
  bool _isSearching = false;
  List<Cocktail> _searchResults = [];
  Timer? _searchDebounce;
  
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
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text;
      setState(() {
        _searchQuery = query;
      });
      
      if (query.length >= 2) {
        setState(() {
          _isSearching = true;
        });
        
        _searchCocktails(query);
      } else {
        setState(() {
          _isSearching = false;
          _searchResults = [];
          _applyFilters();
        });
      }
    });
  }

  Future<void> _searchCocktails(String query) async {
    try {
      final results = await _cocktailService.searchCocktails(query);
      
      if (mounted) {
        setState(() {
          _searchQuery = query;
          _searchResults = results;
          _isSearching = false;
          _filteredCocktails = results;
          
          if (_selectedCategory != null) {
            _filteredCocktails = _filteredCocktails
                .where((cocktail) => cocktail.category == _selectedCategory)
                .toList();
          }
          
          _filteredCocktails.sort((a, b) => a.name.compareTo(b.name));
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _hasError = true;
          _errorMessage = 'Error searching cocktails: $e';
        });
      }
    }
  }

  void _applyFilters() {
    if (_searchResults.isNotEmpty) {
      List<Cocktail> result = List.from(_searchResults);
      
      if (_selectedCategory != null) {
        result = result.where((cocktail) => 
            cocktail.category == _selectedCategory
        ).toList();
      }
      
      result.sort((a, b) => a.name.compareTo(b.name));
      
      setState(() {
        _filteredCocktails = result;
      });
      return;
    }
    
    List<Cocktail> result = List.from(_cocktails);
    
    if (_searchQuery.isNotEmpty) {
      result = result.where((cocktail) => 
          cocktail.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    if (_selectedCategory != null) {
      result = result.where((cocktail) => 
          cocktail.category == _selectedCategory
      ).toList();
    }
    
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
      
      Set<String> uniqueCategories = {'Demo'};
      for (var cocktail in cocktails) {
        if (cocktail.category.isNotEmpty) {
          uniqueCategories.add(cocktail.category);
        }
      }
      
      setState(() {
        _cocktails = cocktails;
        _categories = uniqueCategories.toList()..sort();
        _setupDemoItems();
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
      _searchResults = [];
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
  
  void _handleDemoItemTap(String id) {
    if (id == 'demo-loading') {
      Navigator.of(context).pushNamed(AppRoutes.loading);
    } else if (id == 'demo-error') {
      Navigator.of(context).pushNamed(AppRoutes.error);
    }
  }
  
  void _setupDemoItems() {
    bool hasLoadingItem = _cocktails.any((c) => c.id == 'demo-loading');
    bool hasErrorItem = _cocktails.any((c) => c.id == 'demo-error');
    
    if (!hasLoadingItem || !hasErrorItem) {
      Cocktail loadingDemoItem;
      Cocktail errorDemoItem;
      
      if (_cocktails.length > 1 && _cocktails[1].id != 'demo-error' && _cocktails[1].id != 'demo-loading') {
        final baseCocktail = _cocktails[1];
        loadingDemoItem = Cocktail(
          id: 'demo-loading',
          name: '.Item de Loading - ${baseCocktail.name}',
          category: 'Demo',
          instructions: 'Este é um item de loading baseado em "${baseCocktail.name}". Ao clicar, uma tela de carregamento será exibida antes de mostrar os detalhes do coquetel.',
          imageUrl: baseCocktail.imageUrl,
          ingredients: baseCocktail.ingredients,
        );
      } else {
        loadingDemoItem = Cocktail(
          id: 'demo-loading',
          name: '.Item de Loading',
          category: 'Demo',
          instructions: 'Clique neste item para navegar para uma tela dedicada de carregamento.',
          imageUrl: 'https://via.placeholder.com/400x300/2196F3/FFFFFF?text=Loading+Demo',
          ingredients: [CocktailIngredient(name: 'Demo', measure: 'N/A')],
        );
      }
      
      if (_cocktails.isNotEmpty && _cocktails[0].id != 'demo-loading' && _cocktails[0].id != 'demo-error') {
        final baseCocktail = _cocktails[0];
        errorDemoItem = Cocktail(
          id: 'demo-error',
          name: '.Item de Error - ${baseCocktail.name}',
          category: 'Demo',
          instructions: 'Este é um item de erro baseado em "${baseCocktail.name}". Ao clicar, uma tela de erro será exibida em vez dos detalhes do coquetel.',
          imageUrl: baseCocktail.imageUrl,
          ingredients: baseCocktail.ingredients,
        );
      } else {
        errorDemoItem = Cocktail(
          id: 'demo-error',
          name: '.Item de Error',
          category: 'Demo',
          instructions: 'Clique neste item para navegar para uma tela dedicada de erro.',
          imageUrl: 'https://via.placeholder.com/400x300/F44336/FFFFFF?text=Error+Demo',
          ingredients: [CocktailIngredient(name: 'Demo', measure: 'N/A')],
        );
      }
      
      setState(() {
        _cocktails.insert(0, errorDemoItem);
        _cocktails.insert(0, loadingDemoItem);
        _applyFilters();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 900;
    final cardCrossAxisCount = isLargeScreen ? 3 : 1;
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
          if (!_hasError) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: localizations.searchHint ?? "Search cocktails...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isSearching)
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _refreshTimeline();
                              },
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ),
            
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
                          Text(localizations.loadingMessage ?? "Loading..."),
                        ],
                      ),
                    )
                  : _isSearching
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text("Searching for '${_searchController.text}'..."),
                            ],
                          ),
                        )
                      : _hasError
                          ? _buildErrorWidget(context, localizations)
                          : _filteredCocktails.isEmpty
                              ? Center(
                                  child: _searchQuery.isNotEmpty || _selectedCategory != null
                                      ? Text(localizations.noMatchingResults ?? "No matching results")
                                      : Text(localizations.noResults ?? "No results"),
                                )
                              : GridView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(8.0),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: cardCrossAxisCount,
                                    childAspectRatio: isLargeScreen ? 0.85 : 0.9, // Ajustado para evitar overflow
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
                                    
                                    final cocktail = _filteredCocktails[index];
                                    
                                    return cocktail.id.startsWith('demo-')
                                        ? GestureDetector(
                                            onTap: () => _handleDemoItemTap(cocktail.id),
                                            child: CocktailCard(
                                              cocktail: cocktail,
                                              isCompact: isLargeScreen,
                                              isDemoItem: true,
                                            ),
                                          )
                                        : CocktailCard(
                                            cocktail: cocktail,
                                            isCompact: isLargeScreen,
                                          );
                                  },
                                ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}
