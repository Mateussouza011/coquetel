import 'package:flutter/material.dart';

// Classe singleton para gerenciar o idioma da aplicação
class LanguageService {
  static final LanguageService _instance = LanguageService._internal();
  
  factory LanguageService() {
    return _instance;
  }
  
  LanguageService._internal();
  
  // Observable para mudanças de idioma
  final ValueNotifier<Locale> currentLocale = ValueNotifier<Locale>(const Locale('pt'));
  
  // Método para alterar o idioma
  void changeLocale(Locale locale) {
    currentLocale.value = locale;
  }
}