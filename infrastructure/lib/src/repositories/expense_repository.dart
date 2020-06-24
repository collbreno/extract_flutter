import 'package:infrastructure/infrastructure.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertExpense(ExpenseEntity expense) async {
    Database database = await _databaseHelper.database;
    int result =
        await database.insert(ExpenseEntity.tableName, expense.toMap());
    return result;
  }

  Future<int> updateExpense(ExpenseEntity expense) async {
    Database database = await _databaseHelper.database;
    int result = await database.update(
      ExpenseEntity.tableName,
      expense.toMap(),
      where: '${ExpenseEntity.colId} = ?',
      whereArgs: <int>[expense.id],
    );
    return result;
  }

  Future<int> deleteExpenseWithId(int expenseId) async {
    Database database = await _databaseHelper.database;
    int result = await database.delete(
      ExpenseEntity.tableName,
      where: '${ExpenseEntity.colId} = ?',
      whereArgs: <int>[expenseId],
    );
    return result;
  }

  Future<List<ExpenseEntity>> getExpenses() async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> list = await database.query(
        ExpenseEntity.tableName,
        orderBy: '${ExpenseEntity.colDate} desc');
    return list
        .map((Map<String, dynamic> expenseMap) =>
            ExpenseEntity.fromObject(expenseMap))
        .toList();
  }

  Future<ExpenseEntity> getExpenseWithId(int expenseId) async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> list = await database.query(
      ExpenseEntity.tableName,
      where: '${ExpenseEntity.colId} = ?',
      whereArgs: <int>[expenseId],
    );
    if (list.isNotEmpty) {
      return ExpenseEntity.fromObject(list.first);
    }
    return null;
  }

  Future<int> getTotalValueFromMonth() async {
    Database database = await _databaseHelper.database;
    var result = await database.rawQuery(
      'select sum(${ExpenseEntity.colValue}) '
          'from ${ExpenseEntity.tableName} '
          'where strftime("%m", ${ExpenseEntity.colDate}) = '
          'strftime("%m", "${DateTime.now().toIso8601String()}")',
    );
    return Sqflite.firstIntValue(result);
  }
}
