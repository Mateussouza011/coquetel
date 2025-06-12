import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../core/app_core.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key, this.errorMessage}) : super(key: key);
  
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final message = errorMessage ?? localizations.genericErrorMessage ?? "Something went wrong";
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.error ?? "Error"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text(localizations.tryAgain ?? "Try Again"),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.timeline);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.home),
                label: Text(localizations.backToHome ?? "Back to Home"),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.timeline,
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}