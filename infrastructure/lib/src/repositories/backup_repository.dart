import 'package:flutter/cupertino.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:sqflite/sqflite.dart';

class BackupRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();


  Future<void> runScript(String sqlCommands) async {
    Database db = await _databaseHelper.database;
    List<String> commands = sqlCommands.split(';').where((String cmd) => cmd.length > 3).toList();
    await db.transaction((Transaction txn) async {
      await Future.forEach(commands, (String sql) async => await txn.execute(sql));
    });
  }
}
