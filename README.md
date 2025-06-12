# Aplicativo Flutter de Coquetéis - Como Funciona

Este é um aplicativo que mostra uma lista de coquetéis com receitas e ingredientes. Vou explicar como funciona de forma simples.

## O que o app faz?

- Mostra uma lista de coquetéis em cards bonitos
- Permite pesquisar coquetéis pelo nome
- Filtra por categorias (como "Cocktail", "Shot", etc.)
- Mostra detalhes completos de cada drink
- Salva favoritos

## Como está organizado?

### 📱 Telas (screens)
- **Splash**: Tela inicial com logo
- **Timeline**: Tela principal com lista de drinks
- **Detalhes**: Mostra receita completa
- **Favoritos**: Lista dos drinks salvos
- **Loading**: Tela de carregamento
- **Erro**: Quando algo dá errado

### 🧩 Componentes (widgets)
- **CocktailCard**: Cada card de drink na lista
- **AppBottomNav**: Barra de navegação inferior

### 📊 Dados (models)
- **Cocktail**: Representa um drink com nome, foto, ingredientes, etc.

### 🌐 Serviços (services)
- **CocktailService**: Busca dados dos coquetéis na internet
- **ApiService**: Faz as requisições para a API

## De onde vêm os dados?

Os dados vêm da API TheCocktailDB (thecocktaildb.com), que é gratuita e tem milhares de receitas de drinks.

```dart
// URL da API
https://www.thecocktaildb.com/api/json/v1/1
```

# Principais aspectos do código do aplicativo Coquetel

Vou explicar as partes mais importantes do código excluindo o sistema multilinguagem:

## 1. Estrutura Geral do Projeto

O projeto segue uma arquitetura bem organizada dividida em:

- **screens**: Contém as telas principais do aplicativo
- **widgets**: Componentes reutilizáveis da UI
- **models**: Classes de dados
- **services**: Lógica de negócios e comunicação com APIs
- **config**: Configurações globais

## 2. Configuração da API

```dart
class ApiConfig {
  static const String baseUrl = 'https://www.thecocktaildb.com/api/json/v1/1';
}
```

O aplicativo utiliza a API TheCocktailDB para buscar dados de coquetéis. A configuração é centralizada para facilitar mudanças.

## 3. Design do Tema

```dart
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
  // ...outros estilos
)
```

O aplicativo implementa Material Design 3 com um esquema de cores baseado em um tom bordô/vinho (0xFF8C2B47) como cor principal, criando uma identidade visual coerente e elegante.

## 4. Sistema de Serviços

O aplicativo usa serviços separados para gerenciar diferentes aspectos:

- **CocktailService**: Responsável por buscar dados de coquetéis da API
- **ApiService**: Gerencia requisições HTTP gerais

Esta separação de responsabilidades segue boas práticas de arquitetura, facilitando a manutenção e testabilidade.

## 5. Tela Principal (TimelineScreen)

A `TimelineScreen` exibe coquetéis em formato de timeline, permitindo:
- **Pesquisa** de coquetéis por nome
- **Filtragem** por categoria
- **Carregamento infinito** (lazy loading) para obter mais itens
- **Pull-to-refresh** para atualizar os dados
- **Tratamento de erros** com feedback visual adequado
- **Layout responsivo** que se adapta a diferentes tamanhos de tela

## 6. Modelo de Dados

O modelo `Cocktail` processa os dados recebidos da API:

```dart
class Cocktail {
  final String id;
  final String name;
  final String category;
  final String instructions;
  final String imageUrl;
  final List<CocktailIngredient> ingredients;
  
  // ...construtores e métodos
  
  factory Cocktail.fromJson(Map<String, dynamic> json) {
    // Conversão do JSON para objeto
  }
}
```

Este modelo utiliza o padrão de fábrica `fromJson` para transformar os dados da API em objetos Dart utilizáveis.

## 7. Tela de Detalhes

O aplicativo possui uma tela de detalhes que mostra informações completas sobre o coquetel selecionado, incluindo:
- Imagem do coquetel
- Nome e categoria
- Lista de ingredientes com medidas
- Instruções de preparo

## 8. Tratamento de Erros

O código implementa mecanismos robustos para lidar com erros de rede ou da API:
- **Estado de loading** com indicadores visuais
- **Tela de erro** com opção de tentar novamente
- **Tratamento de casos extremos** (nenhum resultado, busca sem correspondência, etc.)

## 9. Responsividade

O aplicativo foi projetado para funcionar bem em diferentes tamanhos de tela:

```dart
// Exemplo de código responsivo
final isLargeScreen = MediaQuery.of(context).size.width > 900;
final cardCrossAxisCount = isLargeScreen ? 3 : 1;

// Usado para ajustar o layout baseado no tamanho da tela
```

Esta abordagem garante uma boa experiência tanto em dispositivos móveis quanto em tablets.

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
   git clone https://github.com/Mateussouza011/coquetel.git
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
