import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../services/api_service.dart';
import '../widgets/cocktail_card.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final ApiService _apiService = ApiService();
  final List<Cocktail> _cocktails = [];
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  
  @override
  void initState() {
    super.initState();
    _loadMoreCocktails();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent * 0.8 &&
          !_isLoading &&
          _hasMore) {
        _loadMoreCocktails();
      }
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  Future<void> _loadMoreCocktails() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final newCocktails = await _apiService.getCocktails(page: _currentPage);
      
      setState(() {
        if (newCocktails.isEmpty) {
          _hasMore = false;
        } else {
          _cocktails.addAll(newCocktails);
          _currentPage++;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading cocktails: $e')),
      );
    }
  }
  
  Future<void> _refreshTimeline() async {
    setState(() {
      _cocktails.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    await _loadMoreCocktails();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cocktail Timeline'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTimeline,
        child: _cocktails.isEmpty && _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _cocktails.isEmpty
                ? const Center(child: Text('No cocktails found'))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _cocktails.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _cocktails.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      
                      return CocktailCard(cocktail: _cocktails[index]);
                    },
                  ),
      ),
    );
  }
}
