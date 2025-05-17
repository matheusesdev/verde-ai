// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
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
    const Color primaryGreen = Color(0xFF28A745);
    const Color accentGreen = Color(0xFF208538);
    const Color lightBackground = Color(0xFFF9F9F9); // Para BottomNav e fundos de input
    const Color darkText = Color(0xFF1C1C1E);
    const Color secondaryText = Color(0xFF8A8A8E);
    const Color dividerColor = Color(0xFFE5E5EA);

    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    return MaterialApp(
      title: 'VerdeVivo IA',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: baseTextTheme.bodyLarge?.fontFamily,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: darkText,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: primaryGreen),
          actionsIconTheme: const IconThemeData(color: primaryGreen),
          titleTextStyle: baseTextTheme.titleLarge?.copyWith(
            color: darkText,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: lightBackground,
          selectedItemColor: primaryGreen,
          unselectedItemColor: secondaryText,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: baseTextTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 10),
          unselectedLabelStyle: baseTextTheme.bodySmall?.copyWith(fontSize: 10),
        ),
        cardTheme: CardTheme(
          elevation: 0.0,
          margin: EdgeInsets.zero, // Margem será controlada pelo Padding da lista/item
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightBackground,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: primaryGreen, width: 1.5),
          ),
          hintStyle: baseTextTheme.bodyMedium?.copyWith(color: secondaryText.withOpacity(0.8)),
          labelStyle: baseTextTheme.bodyMedium?.copyWith(color: secondaryText),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            textStyle: baseTextTheme.labelLarge?.copyWith(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white),
            elevation: 0,
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return accentGreen.withOpacity(0.2);
                }
                return null;
              },
            ),
          )
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryGreen,
            textStyle: baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          )
        ),
        dividerTheme: const DividerThemeData(
          color: dividerColor,
          thickness: 0.5, // Muito fino
          space: 0.5,     // Sem espaço extra
        ),
        listTileTheme: ListTileThemeData(
          iconColor: secondaryText,
          tileColor: Colors.white,
          dense: false,
          horizontalTitleGap: 12.0,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding para ListTiles
        ),
        iconTheme: const IconThemeData(
          color: secondaryText,
          size: 24,
        ),
        textTheme: baseTextTheme.copyWith(
          displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: darkText, letterSpacing: -0.5),
          headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w600, color: darkText),
          titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600, color: darkText),
          titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 17, fontWeight: FontWeight.w600, color: darkText),
          bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16, color: darkText, height: 1.5),
          bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, color: darkText.withOpacity(0.85), height: 1.4), // Um pouco mais escuro que secondaryText
          bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, color: secondaryText, height: 1.3),
          labelLarge: baseTextTheme.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: primaryGreen),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          brightness: Brightness.light,
          background: Colors.white,
          surface: Colors.white,
          onSurface: darkText,
        ).copyWith(error: CupertinoColors.systemRed.resolveFrom(context)),
        cupertinoOverrideTheme: const CupertinoThemeData( // Aplicar tema Cupertino para widgets Cupertino
            brightness: Brightness.light,
            primaryColor: primaryGreen,
            // Outras personalizações Cupertino aqui se necessário
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
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
  }
}