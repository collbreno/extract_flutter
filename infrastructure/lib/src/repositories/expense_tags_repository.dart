import 'package:infrastructure/infrastructure.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseTagsRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertExpenseTags(
      List<ExpenseTagsEntity> expenseTagsList) async {
    Database database = await _databaseHelper.database;
    await database.transaction((txn) async {
      await Future.wait(expenseTagsList.map((expenseTags) async {
        return await txn.insert(
            ExpenseTagsEntity.tableName, expenseTags.toMap());
      }));
    });
  }

  Future<void> deleteExpenseTags(
      List<ExpenseTagsEntity> expenseTagsList) async {
    Database database = await _databaseHelper.database;
    await database.transaction((txn) async {
      await Future.wait(expenseTagsList.map((expenseTags) async {
        return await txn.delete(
          ExpenseTagsEntity.tableName,
          where:
              '${ExpenseTagsEntity.colExpenseId} = ? and ${ExpenseTagsEntity.colTagId} = ?',
          whereArgs: <int>[
            expenseTags.expenseId,
            expenseTags.tagId,
          ],
        );
      }));
    });
  }

  Future<int> deleteExpenseTagsWithExpenseId(int expenseId) async {
    Database database = await _databaseHelper.database;
    int result = await database.delete(
      ExpenseTagsEntity.tableName,
      where: '${ExpenseTagsEntity.colExpenseId} = ?',
      whereArgs: <int>[expenseId],
    );
    return result;
  }

  Future<int> deleteExpenseTagsWithIds(
      ExpenseTagsEntity expenseTagsEntity) async {
    Database database = await _databaseHelper.database;
    int result = await database.delete(
      ExpenseTagsEntity.tableName,
      where:
          '${ExpenseTagsEntity.colExpenseId} = ? and ${ExpenseTagsEntity.colTagId} = ?',
      whereArgs: <int>[expenseTagsEntity.expenseId, expenseTagsEntity.tagId],
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

  Future<List<ExpenseTagsEntity>> getExpenseTagsWithExpenseId(
      int expenseId) async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> list = await database.query(
      ExpenseTagsEntity.tableName,
      where: '${ExpenseTagsEntity.colExpenseId} = ?',
      whereArgs: <int>[expenseId],
    );
    return list
        .map((Map<String, dynamic> expenseTagsMap) =>
            ExpenseTagsEntity.fromObject(expenseTagsMap))
        .toList();
  }

  Future<int> getUsagesOfTag(int tagId) async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> list = await database.rawQuery(
      'select count(*)from ${ExpenseTagsEntity.tableName} '
      'where ${ExpenseTagsEntity.colTagId} = $tagId',
    );
    int amount = Sqflite.firstIntValue(list);
    return amount;
  }
}
