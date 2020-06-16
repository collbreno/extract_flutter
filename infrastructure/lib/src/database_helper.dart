import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'scripts/version1/version1_scripts.dart';

class DatabaseHelper {
  static final DatabaseHelper _dbHelper = DatabaseHelper._internal();
  static Database _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _dbHelper;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String dirPath = await getDatabasesPath();
    String path = dirPath + '/extract.db';
    Database appDatabase = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return appDatabase;
  }

  void _createDatabase(Database db, int version) async {
    if (version >= 1) {
      await db.execute(CategoryTableVersion1.createScript);
      await db.execute(ExpenseTableVersion1.createScript);
      await db.execute(TagTableVersion1.createScript);
      await db.execute(ExpenseTagsTableVersion1.createScript);
    }
  }
}
