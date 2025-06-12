import 'package:flutter/material.dart';
import 'dart:async';
import '../core/app_core.dart';
import '../l10n/app_localizations.dart';
import '../services/cocktail_service.dart';
import '../models/cocktail.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 100), _loadDataAndNavigate);
  }
  
  void _loadDataAndNavigate() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      
      final cocktails = await CocktailService().getCocktails(page: 1);
      
      if (!mounted) return;
      
      if (cocktails.length > 1) {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.cocktailDetail,
          arguments: cocktails[1],
        );
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.timeline);
      }
    } catch (_) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.timeline);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.loadingDemo),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 40),
              Text(
                localizations.loadingMessage ?? "Carregando conteúdo...",
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "Por favor, aguarde...",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              LinearProgressIndicator(
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}