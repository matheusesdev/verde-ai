// lib/core/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Getters
  bool get isFirstLaunch => _prefs?.getBool(AppConstants.keyFirstLaunch) ?? true;
  String get userName => _prefs?.getString(AppConstants.keyUserName) ?? '';
  String get userEmail => _prefs?.getString(AppConstants.keyUserEmail) ?? '';
  bool get notificationsEnabled => _prefs?.getBool(AppConstants.keyNotificationsEnabled) ?? true;

  // Setters
  Future<void> setFirstLaunch(bool value) async {
    await _prefs?.setBool(AppConstants.keyFirstLaunch, value);
  }

  Future<void> setUserName(String value) async {
    await _prefs?.setString(AppConstants.keyUserName, value);
  }

  Future<void> setUserEmail(String value) async {
    await _prefs?.setString(AppConstants.keyUserEmail, value);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs?.setBool(AppConstants.keyNotificationsEnabled, value);
  }

  // Método para limpar dados do usuário
  Future<void> clearUserData() async {
    await _prefs?.remove(AppConstants.keyUserName);
    await _prefs?.remove(AppConstants.keyUserEmail);
  }

  // Método para limpar todos os dados
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}