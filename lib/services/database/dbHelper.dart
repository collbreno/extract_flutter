import 'dart:async';
import 'package:extract_flutter/services/database/tables/CategoryTable.dart';
import 'package:extract_flutter/services/database/tables/ExpenseTable.dart';
import 'package:extract_flutter/services/database/tables/ExpenseTagsTable.dart';
import 'package:extract_flutter/services/database/tables/TagTable.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  static Database _database;

  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }
    return _database;
  }

  Future<Database> _initializeDb() async {
    String dirPath = await getDatabasesPath();
    String path = dirPath + "/extract.db";
    var extractDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return extractDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(TagTable.createScript);
    await db.execute(CategoryTable.createScript);
    await db.execute(ExpenseTable.createScript);
    await db.execute(ExpenseTagsTable.createScript);
  }
}
