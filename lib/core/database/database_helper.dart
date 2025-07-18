// lib/core/database/database_helper.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';
import '../../models/plant_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.dbName);
    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de plantas
    await db.execute('''
      CREATE TABLE plants (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        imageUrl TEXT,
        imagePath TEXT,
        careInstructions TEXT NOT NULL,
        commonProblems TEXT NOT NULL,
        diagnosis TEXT,
        treatmentSuggestion TEXT,
        reminderNote TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    // Tabela de lembretes
    await db.execute('''
      CREATE TABLE reminders (
        id TEXT PRIMARY KEY,
        plantId TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        reminderType TEXT NOT NULL,
        scheduledTime INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL,
        FOREIGN KEY (plantId) REFERENCES plants (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de diário de cuidados
    await db.execute('''
      CREATE TABLE care_logs (
        id TEXT PRIMARY KEY,
        plantId TEXT NOT NULL,
        careType TEXT NOT NULL,
        notes TEXT,
        imageUrl TEXT,
        logDate INTEGER NOT NULL,
        createdAt INTEGER NOT NULL,
        FOREIGN KEY (plantId) REFERENCES plants (id) ON DELETE CASCADE
      )
    ''');

    // Índices para melhor performance
    await db.execute('CREATE INDEX idx_plants_name ON plants (name)');
    await db.execute('CREATE INDEX idx_reminders_plant ON reminders (plantId)');
    await db.execute('CREATE INDEX idx_reminders_time ON reminders (scheduledTime)');
    await db.execute('CREATE INDEX idx_care_logs_plant ON care_logs (plantId)');
    await db.execute('CREATE INDEX idx_care_logs_date ON care_logs (logDate)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementar migrações futuras aqui
  }

  // CRUD para Plantas
  Future<String> insertPlant(Plant plant) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    await db.insert('plants', {
      'id': plant.id,
      'name': plant.name,
      'imageUrl': plant.imageUrl,
      'imagePath': plant.imagePath,
      'careInstructions': plant.careInstructions,
      'commonProblems': plant.commonProblems,
      'diagnosis': plant.diagnosis,
      'treatmentSuggestion': plant.treatmentSuggestion,
      'reminderNote': plant.reminderNote,
      'createdAt': now,
      'updatedAt': now,
    });
    
    return plant.id;
  }

  Future<List<Plant>> getAllPlants() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plants',
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return Plant(
        id: maps[i]['id'],
        name: maps[i]['name'],
        imageUrl: maps[i]['imageUrl'],
        imagePath: maps[i]['imagePath'],
        careInstructions: maps[i]['careInstructions'],
        commonProblems: maps[i]['commonProblems'],
        diagnosis: maps[i]['diagnosis'],
        treatmentSuggestion: maps[i]['treatmentSuggestion'],
        reminderNote: maps[i]['reminderNote'],
      );
    });
  }

  Future<Plant?> getPlant(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Plant(
        id: maps[0]['id'],
        name: maps[0]['name'],
        imageUrl: maps[0]['imageUrl'],
        imagePath: maps[0]['imagePath'],
        careInstructions: maps[0]['careInstructions'],
        commonProblems: maps[0]['commonProblems'],
        diagnosis: maps[0]['diagnosis'],
        treatmentSuggestion: maps[0]['treatmentSuggestion'],
        reminderNote: maps[0]['reminderNote'],
      );
    }
    return null;
  }

  Future<void> updatePlant(Plant plant) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    await db.update(
      'plants',
      {
        'name': plant.name,
        'imageUrl': plant.imageUrl,
        'imagePath': plant.imagePath,
        'careInstructions': plant.careInstructions,
        'commonProblems': plant.commonProblems,
        'diagnosis': plant.diagnosis,
        'treatmentSuggestion': plant.treatmentSuggestion,
        'reminderNote': plant.reminderNote,
        'updatedAt': now,
      },
      where: 'id = ?',
      whereArgs: [plant.id],
    );
  }

  Future<void> deletePlant(String id) async {
    final db = await database;
    await db.delete(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para busca
  Future<List<Plant>> searchPlants(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plants',
      where: 'name LIKE ? OR careInstructions LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return Plant(
        id: maps[i]['id'],
        name: maps[i]['name'],
        imageUrl: maps[i]['imageUrl'],
        imagePath: maps[i]['imagePath'],
        careInstructions: maps[i]['careInstructions'],
        commonProblems: maps[i]['commonProblems'],
        diagnosis: maps[i]['diagnosis'],
        treatmentSuggestion: maps[i]['treatmentSuggestion'],
        reminderNote: maps[i]['reminderNote'],
      );
    });
  }

  // Método para limpar o banco (útil para testes)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('care_logs');
    await db.delete('reminders');
    await db.delete('plants');
  }
}