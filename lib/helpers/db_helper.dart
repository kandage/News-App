import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      return openDatabase(
        join(dbPath, 'notes.db'),
        onCreate: (db, version) async {
          await db.execute(
            "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT)",
          );
        },
        version: 1,
      );
    } catch (e) {
      print("Database initialization error: $e");
      rethrow;
    }
  }


  Future<void> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    await db.insert('notes', note);
  }

  Future<List<Map<String, dynamic>>> fetchNotes() async {
    final db = await database;
    return db.query('notes');
  }

  Future<void> updateNote(int id, Map<String, dynamic> note) async {
    final db = await database;
    await db.update('notes', note, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
