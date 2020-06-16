import 'package:infrastructure/infrastructure.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseTagsRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertExpenseTags(List<ExpenseTagsEntity> expenseTagsList) async {
    Database database = await _databaseHelper.database;
    int result = await database.transaction((txn) async {
      await Future.wait(expenseTagsList.map((expenseTags) async{
        return await txn.insert(
            ExpenseTagsEntity.tableName, expenseTags.toMap());
      }));
      return 1;
    });
    return result;
  }


  Future<int> deleteExpenseTagsWithExpenseId(int expenseId) async {
    Database database = await _databaseHelper.database;
    int result = await database.delete(
      ExpenseTagsEntity.tableName,
      where:
      '${ExpenseTagsEntity.colExpenseId} = ?',
      whereArgs: <int>[expenseId],
    );
    return result;
  }

  Future<int> deleteExpenseTagsWithIds(int expenseId, int tagId) async {
    Database database = await _databaseHelper.database;
    int result = await database.delete(
      ExpenseTagsEntity.tableName,
      where:
          '${ExpenseTagsEntity.colExpenseId} = ? and ${ExpenseTagsEntity.colTagId} = ?',
      whereArgs: <int>[expenseId, tagId],
    );
    return result;
  }

  Future<List<ExpenseTagsEntity>> getExpenseTags() async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> list =
        await database.query(ExpenseTagsEntity.tableName);
    return list
        .map((Map<String, dynamic> expenseTagsMap) =>
            ExpenseTagsEntity.fromObject(expenseTagsMap))
        .toList();
  }
}
