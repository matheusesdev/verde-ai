import 'package:flutter/material.dart';
import 'package:verdevivo_ia_prototype/screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/plant_details_screen.dart';
import 'models/plant_model.dart';
import 'screens/create_post_screen.dart';
import 'screens/article_details_screen.dart';

void main() {
  runApp(const VerdeVivoApp());
}

class VerdeVivoApp extends StatelessWidget {
  const VerdeVivoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VerdeVivo IA',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 1,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Theme.of(context).primaryColorDark, width: 2.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          )
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainScreen(),
        // Rotas que usam argumentos complexos são melhor tratadas em onGenerateRoute
      },
      onGenerateRoute: (settings) {
        // print("onGenerateRoute chamado para: ${settings.name}");
        // print("Argumentos recebidos: ${settings.arguments}");
        // print("Tipo dos argumentos: ${settings.arguments.runtimeType}");

        if (settings.name == '/plant_details') {
          // print("Processando rota /plant_details");
          if (settings.arguments is Map<String, dynamic>) {
            // print("Argumentos são um Map<String, dynamic>");
            final argsMap = settings.arguments as Map<String, dynamic>;
            // Verificar se a chave 'plant' existe E se o valor é do tipo Plant
            if (argsMap.containsKey('plant') && argsMap['plant'] is Plant) {
              // print("Chave 'plant' encontrada e é do tipo Plant");
              final plant = argsMap['plant'] as Plant;
              // updateCallback é opcional, então pode ser null
              final updateCallback = argsMap['updateCallback'] as Function(Plant)?;
              return MaterialPageRoute(
                builder: (context) {
                  return PlantDetailsScreen(plant: plant, updateCallback: updateCallback);
                },
              );
            } else {
              // print("ERRO: Chave 'plant' faltando ou tipo inválido. Chaves: ${argsMap.keys}, Tipo de plant: ${argsMap['plant']?.runtimeType}");
            }
          } else {
            // print("ERRO: Argumentos para /plant_details não são um Map<String, dynamic>");
          }
           // Se as verificações falharem, cai aqui:
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
        // Fallback para rotas não encontradas
        return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('Ops! Página não encontrada: ${settings.name}'))));
      },
      debugShowCheckedModeBanner: false,
    );
  }
}