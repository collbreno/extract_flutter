import 'package:extract_flutter/models/Expense.dart';
import 'package:extract_flutter/models/Tag.dart';
import 'package:extract_flutter/services/database/dbHelper.dart';
import 'package:extract_flutter/services/database/tables/CategoryTable.dart';
import 'package:extract_flutter/services/database/tables/ExpenseTable.dart';
import 'package:extract_flutter/services/database/tables/ExpenseTagsTable.dart';
import 'package:extract_flutter/services/database/tables/TagTable.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepository {

  final DbHelper _dbHelper = DbHelper();

  Future<int> insertExpense(Expense expense) async {
    Database db = await _dbHelper.database;
    int result;
    await db.transaction((txn) async{
      result = await txn.insert(ExpenseTable.tableName, expense.toMap());
      print('insert expense => '+result.toString());
      expense.id = result;
      await Future.forEach(expense.getMapWithTagIds(), (map) async {
        await txn.insert(ExpenseTagsTable.tableName, map);
      });
    });
    return result;
  }

  Future<List<Expense>> getExpenses() async {
    Database db = await _dbHelper.database;
    var mapList = await db.rawQuery(
      "select * from ${ExpenseTable.tableName} natural join ${CategoryTable.tableName}"
    );
    var expenseList = mapList.map((object){
      print(object);
      return Expense.fromObjectWithCategory(object);
    }).toList();

    var mapWithTagsList = await db.rawQuery(
      "select * from ${ExpenseTable.tableName} natural join ${TagTable.tableName} natural join ${ExpenseTagsTable.tableName}"
    );
    await Future.forEach(mapWithTagsList, (mapWithTag) {
      var tag = Tag.fromObject(mapWithTag);
      int expenseId = mapWithTag[ExpenseTable.colId];
      expenseList.firstWhere((expense) => expense.id == expenseId).tags.add(tag);
    });
    return expenseList;
  }

  Future<int> getExpensesAmmount() async {
    Database db = await _dbHelper.database;
    var count = Sqflite.firstIntValue(
      await db.rawQuery("select count (*) from ${ExpenseTable.tableName}")
    );
    return count;
  }
  

}