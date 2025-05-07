import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/timeline_screen.dart';
import 'l10n/app_localizations.dart';
import 'services/language_service.dart';

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
    // Ouvir alterações de idioma
    _languageService.currentLocale.addListener(() {
      setState(() {});  // Reconstruir o widget quando o idioma mudar
    });
  }

  @override
  void dispose() {
    // Limpar listeners para evitar memory leaks
    _languageService.currentLocale.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocktail Timeline',
      debugShowCheckedModeBanner: false,
      
      // Configurações de localização
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt'), // Português
        Locale('en'), // Inglês
        Locale('es'), // Espanhol
        Locale('fr'), // Francês
      ],
      
      // Usar o idioma selecionado pelo usuário
      locale: _languageService.currentLocale.value,
      
      // Fallback caso o idioma selecionado não esteja disponível
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return supportedLocales.first;
      },
      
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
      home: const TimelineScreen(),
    );
  }
}
