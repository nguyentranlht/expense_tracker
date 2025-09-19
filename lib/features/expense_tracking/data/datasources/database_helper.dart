import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../../core/constants/constants.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(Constants.databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: Constants.databaseVersion,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Create expenses table
    await db.execute('''
      CREATE TABLE ${Constants.expenseTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Create categories table
    await db.execute('''
      CREATE TABLE ${Constants.categoryTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        icon TEXT,
        color TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Create settings table
    await db.execute('''
      CREATE TABLE ${Constants.settingsTable} (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Insert default categories
    for (Map<String, dynamic> category in Constants.defaultCategories) {
      await db.insert(Constants.categoryTable, {
        'name': category['name'],
        'icon': category['icon'],
        'color': category['color'],
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // Insert default settings
    await db.insert(Constants.settingsTable, {
      'key': Constants.themeMode,
      'value': 'system',
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert(Constants.settingsTable, {
      'key': Constants.language,
      'value': 'vi',
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert(Constants.settingsTable, {
      'key': Constants.firstLaunch,
      'value': 'true',
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}