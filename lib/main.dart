// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'providers/plant_provider.dart';
import 'package:verdevivo_ia_prototype/screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/plant_details_screen.dart';
import 'models/plant_model.dart';
import 'screens/create_post_screen.dart';
import 'screens/article_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VerdeVivoApp());
}

class VerdeVivoApp extends StatelessWidget {
  const VerdeVivoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => PlantProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'VerdeVivo IA',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const AppInitializer(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/main': (context) => const MainScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/plant_details') {
                if (settings.arguments is Map<String, dynamic>) {
                  final argsMap = settings.arguments as Map<String, dynamic>;
                  if (argsMap.containsKey('plant')) {
                    final plant = argsMap['plant'] as Plant;
                    final updateCallback = argsMap['updateCallback'] as Function(Plant)?;
                    return MaterialPageRoute(
                      builder: (context) {
                        return PlantDetailsScreen(plant: plant, updateCallback: updateCallback);
                      },
                    );
                  }
                }
                return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Erro: Argumentos inválidos para detalhes da planta'))));
              }
              if (settings.name == '/create_post') {
                final arguments = settings.arguments as Map<String, dynamic>?;
                if (arguments != null && arguments.containsKey('onPostCreated')) {
                  final onPostCreatedCallback = arguments['onPostCreated'] as Function(Map<String, dynamic>);
                  return MaterialPageRoute(
                    builder: (context) => CreatePostScreen(onPostCreated: onPostCreatedCallback),
                  );
                }
                return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child:Text('Erro: Argumentos faltando para /create_post'))));
              }
              if (settings.name == '/article_details') {
                if (settings.arguments is Article) {
                  final article = settings.arguments as Article;
                  return MaterialPageRoute(
                    builder: (context) {
                      return ArticleDetailsScreen(article: article);
                    },
                  );
                }
                return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Erro: Argumento inválido para detalhes do artigo'))));
              }
              return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('Ops! Página não encontrada: ${settings.name}'))));
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    
    // Inicializar providers
    await appProvider.init();
    await plantProvider.loadPlants();
    
    // Navegar para a tela apropriada
    if (mounted) {
      if (appProvider.isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.leaf_arrow_circlepath,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'VerdeVivo IA',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Seu assistente inteligente de jardinagem',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}