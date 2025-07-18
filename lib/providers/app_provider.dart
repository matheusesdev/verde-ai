// lib/providers/app_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';

class AppProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();

  bool _isFirstLaunch = true;
  String _userName = '';
  String _userEmail = '';
  bool _notificationsEnabled = true;
  bool _isLoading = false;
  ThemeMode _themeMode = ThemeMode.light;

  // Getters
  bool get isFirstLaunch => _isFirstLaunch;
  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isLoading => _isLoading;
  ThemeMode get themeMode => _themeMode;
  bool get isLoggedIn => _userName.isNotEmpty && _userEmail.isNotEmpty;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _storageService.init();
      _loadSettings();
    } catch (e) {
      debugPrint('Erro ao inicializar AppProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadSettings() {
    _isFirstLaunch = _storageService.isFirstLaunch;
    _userName = _storageService.userName;
    _userEmail = _storageService.userEmail;
    _notificationsEnabled = _storageService.notificationsEnabled;
  }

  Future<void> completeFirstLaunch() async {
    _isFirstLaunch = false;
    await _storageService.setFirstLaunch(false);
    notifyListeners();
  }

  Future<void> setUserInfo(String name, String email) async {
    _userName = name;
    _userEmail = email;
    await _storageService.setUserName(name);
    await _storageService.setUserEmail(email);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _storageService.setNotificationsEnabled(enabled);
    notifyListeners();
  }

  Future<void> logout() async {
    _userName = '';
    _userEmail = '';
    await _storageService.clearUserData();
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Método para obter saudação baseada no horário
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bom dia';
    } else if (hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  // Método para obter nome de exibição
  String getDisplayName() {
    if (_userName.isNotEmpty) {
      return _userName.split(' ').first; // Primeiro nome
    }
    return 'Usuário';
  }
}