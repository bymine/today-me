import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper with ChangeNotifier {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database? _database;
  static const _databaseName = "diary.db";
  static const _databaseVersion = 1;

  static const _scheduleTable = "schedules";
  static const _todoTable = "todos";
  static const _diaryTable = "diarys";

  Future<Database> get database async => _database ??= await _initDB();
  _initDB() async {
    return await openDatabase(join(await getDatabasesPath(), _databaseName),
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_scheduleTable (schedule_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, schedule_title TEXT NOT NULL, schedule_body TEXT NOT NULL ,schedule_start_date INTEGER NOT NULL, schedule_start_time TEXT NOT NULL, schedule_end_time TEXT NOT NULL, schedule_color INTEGER NOT NULL )");
    await db.execute(
        "CREATE TABLE $_todoTable (todo_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, todo_title TEXT NOT NULL, todo_notes TEXT NOT NULL, todo_create_date INTEGER NOT NULL, todo_create_time TEXT NOT NULL, todo_is_complete BOOLEAN NOT NULL, todo_color INTEGER NOT NULL)");
    await db.execute(
        "CREATE TABLE $_diaryTable (diary_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, diary_title TEXT NOT NULL, diary_body TEXT NOT NULL, diary_start_date INTEGER NOT NULL )");
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, Object?>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, Object?>>> getByDate(String table, int date) async {
    final db = await database;

    switch (table) {
      case 'schedules':
        return await db.query(_scheduleTable,
            where: 'schedule_start_date = ?', whereArgs: [date]);
      case 'todos':
        return await db.query(_todoTable,
            where: 'todo_create_date = ?', whereArgs: [date]);
      case 'diarys':
        return await db.query(_diaryTable,
            where: 'diary_start_date = ?', whereArgs: [date]);

      default:
        return [];
    }
  }

  Future update(String table, dynamic data) async {
    final db = await database;

    switch (table) {
      case 'schedules':
        return await db.update(_scheduleTable, data.toMap(),
            where: 'schedule_id = ?', whereArgs: [data.id]);
      case 'todos':
        return await db.update(_todoTable, data.toMap(),
            where: 'todo_id = ?', whereArgs: [data.id]);
      case 'diarys':
        return await db.update(_diaryTable, data.toMap(),
            where: 'diary_id = ?', whereArgs: [data.id]);
    }
  }

  Future delete(String table, dynamic data) async {
    final db = await database;

    switch (table) {
      case 'schedules':
        return await db.delete(_scheduleTable,
            where: 'schedule_id = ?', whereArgs: [data.id]);
      case 'todos':
        return await db
            .delete(_todoTable, where: 'todo_id = ?', whereArgs: [data.id]);
      case 'diarys':
        return await db
            .delete(_diaryTable, where: 'diary_id = ?', whereArgs: [data.id]);
    }
  }
}
