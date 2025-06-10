import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../routes/app_routes.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  
  const AppBottomNav({Key? key, required this.currentIndex}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            if (currentIndex != 0) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.timeline);
            }
            break;
          case 1:
            if (currentIndex != 1) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.favorites);
            }
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: localizations.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: localizations.favorites,
        ),
      ],
    );
  }
}