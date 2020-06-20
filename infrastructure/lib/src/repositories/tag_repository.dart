import 'package:infrastructure/infrastructure.dart';
import 'package:sqflite/sqflite.dart';

class TagRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertTag(TagEntity tag) async {
    Database database = await _databaseHelper.database;
    int result = await database.insert(TagEntity.tableName, tag.toMap());
    return result;
  }

  Future<int> updateTag(TagEntity tag) async {
    Database database = await _databaseHelper.database;
    int result = await database.update(
      TagEntity.tableName,
      tag.toMap(),
      where: '${TagEntity.colId} = ?',
      whereArgs: <int>[tag.id],
    );
    return result;
  }

  Future<int> deleteTagWithId(int tagId) async {
    Database database = await _databaseHelper.database;
    int result = await database.delete(
      TagEntity.tableName,
      where: '${TagEntity.colId} = ?',
      whereArgs: <int>[tagId],
    );
    return result;
  }

  Future<List<TagEntity>> getTags() async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> list = await database.query(TagEntity.tableName);
    return list
        .map((Map<String, dynamic> tagMap) => TagEntity.fromObject(tagMap))
        .toList();
  }

  Future<TagEntity> getTagWithId(int tagId) async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> list = await database.query(
      TagEntity.tableName,
      where: '${TagEntity.colId} = ?',
      whereArgs: <int>[tagId],
    );
    if (list.isNotEmpty) {
      return TagEntity.fromObject(list.first);
    }
    return null;
  }

  Future<List<TagEntity>> getTagsOfExpenseWithId(int expenseId) async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> list = await database.query(
      '${TagEntity.tableName} natural join ${ExpenseTagsEntity.tableName}',
      where: '${ExpenseTagsEntity.colExpenseId} = ?',
      whereArgs: <int>[expenseId],
    );
    return list
        .map((Map<String, dynamic> tagMap) => TagEntity.fromObject(tagMap))
        .toList();
  }

}
