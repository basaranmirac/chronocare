import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chronocare.db');
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

    // 1. Kullanıcılar Tablosu
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    // 2. Saatler Tablosu
    await db.execute('''
      CREATE TABLE watches (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        brand TEXT NOT NULL,
        modelName TEXT NOT NULL,
        ownerId INTEGER NOT NULL,
        caliber TEXT NOT NULL,
        FOREIGN KEY (ownerId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 3. Servis Kayıtları Tablosu
    await db.execute('''
      CREATE TABLE services (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        watchId INTEGER NOT NULL,
        issue TEXT NOT NULL,
        status TEXT NOT NULL,
        estimatedDays INTEGER NOT NULL,
        cost REAL NOT NULL,
        FOREIGN KEY (watchId) REFERENCES watches (id) ON DELETE CASCADE
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}