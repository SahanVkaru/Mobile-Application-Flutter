import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/dog.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dogs_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE dogs (
  id $idType,
  name $textType,
  age $integerType,
  breed $textType
  )
''');
  }

  // Create
  Future<Dog> create(Dog dog) async {
    final db = await instance.database;
    final id = await db.insert('dogs', dog.toMap());
    return Dog(id: id, name: dog.name, age: dog.age, breed: dog.breed);
  }

  // Read all
  Future<List<Dog>> readAllDogs() async {
    final db = await instance.database;
    final orderBy = 'id ASC';
    final result = await db.query('dogs', orderBy: orderBy);
    return result.map((json) => Dog.fromMap(json)).toList();
  }

  // Read one
  Future<Dog?> readDog(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'dogs',
      columns: ['id', 'name', 'age', 'breed'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Dog.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Update
  Future<int> update(Dog dog) async {
    final db = await instance.database;
    return db.update(
      'dogs',
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [dog.id],
    );
  }

  // Delete
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
