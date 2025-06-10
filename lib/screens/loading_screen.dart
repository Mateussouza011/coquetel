import 'package:flutter/material.dart';
import 'dart:async';
import '../routes/app_routes.dart';
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
    // Inicia o processo de carregamento após a construção da tela
    Timer(const Duration(milliseconds: 100), _startLoading);
  }
  
  void _startLoading() {
    // Simula o processo de carregamento por 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateToSecondCocktail();
      }
    });
  }
  
  Future<void> _navigateToSecondCocktail() async {
    try {
      final cocktails = await CocktailService().getCocktails(page: 1);
      
      if (!mounted) return;
      
      if (cocktails.length > 1) {
        // Navega para os detalhes do segundo coquetel
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.cocktailDetail,
          arguments: cocktails[1],
        );
      } else {
        // Fallback para a timeline se não houver coquetéis suficientes
        Navigator.of(context).pushReplacementNamed(AppRoutes.timeline);
      }
    } catch (_) {
      // Em caso de erro, voltar para a timeline
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 5,
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