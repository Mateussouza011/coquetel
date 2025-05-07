# Cocktail Timeline Flutter App

This is a Flutter application that displays a timeline of cocktails from TheCocktailDB API.

## Important Deployment Note

This project is a **Flutter application** written in Dart, not a JavaScript/Node.js application.

The `package.json` and `index.js` files are only included to satisfy deployment systems that expect a JavaScript project. They are not part of the actual application.

## Proper Deployment Instructions

To properly deploy this Flutter application:

### For Web:
1. Install Flutter SDK
2. Run `flutter build web`
3. Deploy the contents of the `build/web` directory

### For Android:
1. Install Flutter SDK
2. Run `flutter build apk`
3. The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`

### For iOS:
1. Install Flutter SDK
2. Run `flutter build ios`
3. Use Xcode to create an IPA file

## Development

To run this project locally:
1. Install Flutter SDK
2. Run `flutter pub get`
3. Run `flutter run`
\`\`\`

```gitignore file=".gitignore"
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# The .vscode folder contains launch configuration and tasks you configure in
# VS Code which you may wish to be included in version control, so this line
# is commented out by default.
#.vscode/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Web related
lib/generated_plugin_registrant.dart

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

# Node.js related (for deployment systems)
node_modules/
