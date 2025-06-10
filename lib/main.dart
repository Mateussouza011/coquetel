import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/timeline_screen.dart';
import 'screens/cocktail_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/error_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/loading_screen.dart'; // Importar a nova tela
import 'l10n/app_localizations.dart';
import 'services/language_service.dart';
import 'routes/app_routes.dart';
import 'models/cocktail.dart';
import 'providers/favorites_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LanguageService _languageService = LanguageService();

  @override
  void initState() {
    super.initState();
    _languageService.currentLocale.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _languageService.currentLocale.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'Cocktail Timeline',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt'),
          Locale('en'),
          Locale('es'),
          Locale('fr'),
        ],
        locale: _languageService.currentLocale.value,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8C2B47),
            brightness: Brightness.light,
          ),
          cardTheme: CardTheme(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
            titleMedium: TextStyle(fontWeight: FontWeight.w600),
            bodyLarge: TextStyle(height: 1.5),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF8C2B47),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.timeline: (context) => const TimelineScreen(),
          AppRoutes.favorites: (context) => const FavoritesScreen(),
          AppRoutes.error: (context) => const ErrorScreen(),
          AppRoutes.loading: (context) => const LoadingScreen(), // Nova rota
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.cocktailDetail) {
            final cocktail = settings.arguments as Cocktail;
            return MaterialPageRoute(
              builder: (context) => CocktailDetailScreen(cocktail: cocktail),
            );
          }
          return null;
        },
      ),
    );
  }
}
