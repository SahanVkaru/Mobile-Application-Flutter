import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dog.dart';

class DogDatabase {
  static final DogDatabase instance = DogDatabase._init();

  static Database? _database;

  DogDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('dogmanagement.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    String path;
    if (kIsWeb) {
      path = fileName;
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, fileName);
    }

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dogs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL
      )
    ''');
  }

  Future<Dog> createDog(Dog dog) async {
    final db = await database;
    final id = await db.insert('dogs', dog.toMap());
    return Dog(id: id, name: dog.name, age: dog.age);
  }

  Future<Dog?> readDog(int id) async {
    final db = await database;
    final maps = await db.query(
      'dogs',
      columns: ['id', 'name', 'age'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Dog.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Dog>> readAllDogs() async {
    final db = await database;
    final result = await db.query('dogs', orderBy: 'id');
    return result.map((map) => Dog.fromMap(map)).toList();
  }

  Future<int> updateDog(Dog dog) async {
    final db = await database;
    return await db.update(
      'dogs',
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [dog.id],
    );
  }

  Future<int> deleteDog(int id) async {
    final db = await database;
    return await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
