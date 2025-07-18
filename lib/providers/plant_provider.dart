// lib/providers/plant_provider.dart
import 'package:flutter/foundation.dart';
import '../models/plant_model.dart';
import '../core/database/database_helper.dart';
import '../core/services/storage_service.dart';

class PlantProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final StorageService _storageService = StorageService();

  List<Plant> _plants = [];
  List<Plant> _filteredPlants = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _error;

  // Getters
  List<Plant> get plants => _filteredPlants.isEmpty && _searchQuery.isEmpty 
      ? _plants 
      : _filteredPlants;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get error => _error;
  int get plantsCount => _plants.length;
  
  // Plantas que precisam de cuidados (exemplo: com diagnóstico)
  List<Plant> get plantsNeedingCare => _plants.where((plant) => 
      plant.diagnosis != null && plant.diagnosis!.isNotEmpty).toList();

  Future<void> loadPlants() async {
    _setLoading(true);
    _error = null;
    
    try {
      _plants = await _databaseHelper.getAllPlants();
      _applySearch();
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar plantas: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addPlant(Plant plant) async {
    _setLoading(true);
    _error = null;
    
    try {
      await _databaseHelper.insertPlant(plant);
      _plants.add(plant);
      _applySearch();
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao adicionar planta: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePlant(Plant plant) async {
    _setLoading(true);
    _error = null;
    
    try {
      await _databaseHelper.updatePlant(plant);
      final index = _plants.indexWhere((p) => p.id == plant.id);
      if (index != -1) {
        _plants[index] = plant;
        _applySearch();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Erro ao atualizar planta: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePlant(String plantId) async {
    _setLoading(true);
    _error = null;
    
    try {
      await _databaseHelper.deletePlant(plantId);
      _plants.removeWhere((plant) => plant.id == plantId);
      _applySearch();
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao deletar planta: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  void searchPlants(String query) {
    _searchQuery = query.toLowerCase();
    _applySearch();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredPlants.clear();
    notifyListeners();
  }

  Plant? getPlantById(String id) {
    try {
      return _plants.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredPlants.clear();
    } else {
      _filteredPlants = _plants.where((plant) =>
          plant.name.toLowerCase().contains(_searchQuery) ||
          plant.careInstructions.toLowerCase().contains(_searchQuery) ||
          plant.commonProblems.toLowerCase().contains(_searchQuery)
      ).toList();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Método para obter estatísticas
  Map<String, int> getStatistics() {
    return {
      'total': _plants.length,
      'needingCare': plantsNeedingCare.length,
      'withReminders': _plants.where((p) => 
          p.reminderNote != null && p.reminderNote!.isNotEmpty).length,
    };
  }
}