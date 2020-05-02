import 'package:extract_flutter/models/Expense.dart';
import 'package:extract_flutter/services/database/dbHelper.dart';
import 'package:extract_flutter/services/database/tables/ExpenseTable.dart';
import 'package:extract_flutter/services/database/tables/ExpenseTagsTable.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepository {

  final DbHelper _dbHelper = DbHelper();

  Future<int> insertExpense(Expense expense) async {
    Database db = await _dbHelper.database;
    int result;
    db.transaction((txn) async{
      result = await txn.insert(ExpenseTable.tableName, expense.toMap());
      expense.id = result;
      await Future.forEach(expense.getMapWithTagIds(), (map) async {
        await txn.insert(ExpenseTagsTable.tableName, map);
      });
    });
    return result;
  }

  // Future<List<Category>> getExpenses() async {
  //   Database db = await _dbHelper.database;
  // }

  Future<int> getExpensesAmmount() async {
    Database db = await _dbHelper.database;
    var count = Sqflite.firstIntValue(
      await db.rawQuery("select count (*) from ${ExpenseTable.tableName}")
    );
    return count;
  }
  

}