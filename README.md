# Aplicativo Flutter de Linha do Tempo de Coquetéis

Um aplicativo Flutter que exibe uma linha do tempo de coquetéis da API TheCocktailDB, com design responsivo e funcionalidade de busca.

## Funcionalidades

- Navegue por coquetéis em uma linha do tempo visualmente atraente
- Pesquise coquetéis pelo nome
- Design responsivo com 3 cards por linha em telas grandes
- Classificação alfabética de coquetéis
- Visualização detalhada para cada coquetel com instruções

## Executando o Projeto

Existem várias maneiras de executar este aplicativo, dependendo das suas necessidades e ambiente.

### Pré-requisitos

- [SDK do Flutter](https://flutter.dev/docs/get-started/install) instalado
- Uma IDE (VS Code, Android Studio ou IntelliJ)
- Git (para clonar o repositório)

## Opção 1: Executar para Desenvolvimento

A maneira mais simples de executar o projeto durante o desenvolvimento:

1. **Clone o repositório:**
   ```
   git clone https://github.com/seunome/coquetel.git
   cd coquetel
   ```

2. **Obtenha as dependências:**
   ```
   flutter pub get
   ```

3. **Execute no modo de depuração:**
   ```
   flutter run
   ```
   Se vários dispositivos estiverem conectados, você será solicitado a selecionar um:
   - Para web: `flutter run -d chrome`
   - Para um dispositivo específico: `flutter run -d id_do_dispositivo`

## Opção 2: Executar com Docker

Use o Docker para criar uma versão em contêiner da aplicação web:

1. **Construa a imagem Docker:**
   ```
   docker build -t cocktail-timeline-app .
   ```

2. **Execute o contêiner:**
   ```
   docker run -p 8080:80 cocktail-timeline-app
   ```

3. **Acesse a aplicação:**
   Abra seu navegador e navegue até http://localhost:8080

## Opção 3: Compilar para Produção

### Implantação para Android

1. **Construa o APK de depuração:**
   ```
   flutter build apk --debug
   ```

2. **Construa o APK de produção:**
   ```
   flutter build apk --release
   ```
   O APK estará disponível em `build/app/outputs/flutter-apk/app-release.apk`

3. **Construa um App Bundle (para a Play Store):**
   ```
   flutter build appbundle
   ```
   O bundle estará em `build/app/outputs/bundle/release/app-release.aab`

4. **Instale diretamente em um dispositivo conectado:**
   ```
   flutter install
   ```


## Opção 4: Executar com Servidor Web Flutter

Para testes rápidos da versão web:

1. **Construa a versão web:**
   ```
   flutter build web
   ```

2. **Sirva a compilação web:**
   ```
   # Usando dart
   dart pub global activate dhttpd
   dhttpd --path build/web
   ```
   Em seguida, acesse o aplicativo em http://localhost:8080

## Opção 5: Executar com Flutter DevTools

Para depuração e análise de desempenho:

1. **Inicie o aplicativo com DevTools:**
   ```
   flutter run --devtools
   ```

2. **Ou inicie o DevTools separadamente:**
   ```
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

## Solução de Problemas

- **Falta suporte web?** Execute: `flutter config --enable-web`
- **Dependências ausentes?** Execute: `flutter pub get`
- **Erros de compilação?** Tente: `flutter clean` e depois `flutter pub get`
- **Problemas de renderização web?** Tente: `flutter run -d chrome --web-renderer html`
- **Problemas de desempenho?** Tente: `flutter run --profile` para identificar gargalos

## Estrutura do Projeto

- `lib/` - Contém todo o código Dart
  - `main.dart` - Ponto de entrada da aplicação
  - `models/` - Modelos de dados
  - `screens/` - Telas da interface do usuário
  - `widgets/` - Componentes de UI reutilizáveis
  - `services/` - Serviços de API e dados

## Nota para Sistemas de Implantação

Este projeto é um **aplicativo Flutter** escrito em Dart, não um aplicativo JavaScript/Node.js. Quaisquer arquivos `package.json` e `index.js` são incluídos apenas para satisfazer sistemas de implantação que esperam um projeto JavaScript.

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
