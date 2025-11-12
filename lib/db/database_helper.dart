import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/counter_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'counters.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE counters (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            value INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertCounter(CounterModel counter) async {
    final db = await database;
    return await db.insert('counters', counter.toMap());
  }

  Future<List<CounterModel>> getAllCounters() async {
    final db = await database;
    final result = await db.query('counters');
    return result.map((e) => CounterModel.fromMap(e)).toList();
  }

  Future<int> updateCounter(CounterModel counter) async {
    final db = await database;
    return await db.update(
      'counters',
      counter.toMap(),
      where: 'id = ?',
      whereArgs: [counter.id],
    );
  }

  Future<int> deleteCounter(int id) async {
    final db = await database;
    return await db.delete('counters', where: 'id = ?', whereArgs: [id]);
  }
}
