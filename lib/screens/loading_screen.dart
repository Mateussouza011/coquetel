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
    
    // Simula um processo de carregamento e retorna para a tela de detalhes
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Obter o segundo coquetel da lista para navegar para seus detalhes
        _navigateToSecondCocktail();
      }
    });
  }
  
  Future<void> _navigateToSecondCocktail() async {
    try {
      // Instancia o serviço de coquetéis
      final cocktailService = CocktailService();
      
      // Carrega a primeira página de coquetéis para obter o segundo item
      final cocktails = await cocktailService.getCocktails(page: 1);
      
      if (cocktails.length > 1) {
        // Usa o segundo coquetel (índice 1)
        final targetCocktail = cocktails[1];
        
        if (mounted) {
          // Navegar para detalhes deste coquetel
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.cocktailDetail,
            arguments: targetCocktail,
          );
        }
      } else {
        // Fallback caso não encontre
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.timeline);
        }
      }
    } catch (e) {
      // Em caso de erro, voltar para a timeline
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.timeline);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.loadingDemo), // Use loadingDemo em vez de loading
      ),
      body: Center(
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
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              "Por favor, aguarde...", // String fixa como solução temporária
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 50),
            LinearProgressIndicator(
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}