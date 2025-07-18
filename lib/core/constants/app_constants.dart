// lib/core/constants/app_constants.dart
class AppConstants {
  // App Info
  static const String appName = 'VerdeVivo IA';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyThemeMode = 'theme_mode';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  
  // Database
  static const String dbName = 'verdevivo.db';
  static const int dbVersion = 1;
  
  // API Endpoints (para futuras integrações)
  static const String baseUrl = 'https://api.verdevivo.com';
  static const String plantIdentificationEndpoint = '/identify';
  static const String plantDiagnosisEndpoint = '/diagnose';
  
  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 24);
  
  // Limits
  static const int maxPlantsPerUser = 100;
  static const int maxPostsPerPage = 20;
  static const int maxImageSizeMB = 5;
  
  // Default Values
  static const String defaultPlantImage = 'https://via.placeholder.com/300x300/4CAF50/FFFFFF?Text=Planta';
  static const String defaultUserAvatar = 'https://via.placeholder.com/80x80/2196F3/FFFFFF?Text=User';
}