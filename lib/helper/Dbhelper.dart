import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'dynamic_example.db');
    return await openDatabase(
      path,
      version: 1,
    );
  }

  Future<void> createTable(
      String tableName, Map<String, String> columns) async {
    final db = await database;

    String columnsSQL = columns.entries
        .map((entry) => '${entry.key} ${entry.value}')
        .join(', ');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnsSQL
      )
    ''');
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'todolist.db');
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      // Membuat tabel 'app_todolist' jika belum ada
      await db.execute('''CREATE TABLE IF NOT EXISTS app_todolist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title VARCHAR(50) NOT NULL,
        notes TEXT,
        status VARCHAR(150) NOT NULL,
        dari VARCHAR(150) NOT NULL,
        sampai VARCHAR(150) NOT NULL
      )''');
    });
  }

  Future<int> insert(String tableName, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> read(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<int> update(
      String tableName, int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      tableName,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String tableName, int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll(String tableName) async {
    final db = await database;
    return await db.delete(tableName);
  }
}
