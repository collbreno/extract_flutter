import 'package:flutter/cupertino.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/entities/category_with_value_entity.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertCategory(CategoryEntity category) async {
    Database database = await _databaseHelper.database;
    int result =
        await database.insert(CategoryEntity.tableName, category.toMap());
    return result;
  }

  Future<int> updateCategory(CategoryEntity category) async {
    Database database = await _databaseHelper.database;
    int result = await database.update(
      CategoryEntity.tableName,
      category.toMap(),
      where: '${CategoryEntity.colId} = ?',
      whereArgs: <int>[category.id],
    );
    return result;
  }

  Future<int> deleteCategoryWithId(int categoryId) async {
    Database database = await _databaseHelper.database;
    int result = await database.delete(
      CategoryEntity.tableName,
      where: '${CategoryEntity.colId} = ?',
      whereArgs: <int>[categoryId],
    );
    return result;
  }

  Future<List<CategoryEntity>> getCategories() async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> list =
        await database.query(CategoryEntity.tableName);
    return list
        .map((Map<String, dynamic> categoryMap) =>
            CategoryEntity.fromObject(categoryMap))
        .toList();
  }

  Future<CategoryEntity> getCategoryWithId(int categoryId) async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> list = await database.query(
      CategoryEntity.tableName,
      where: '${CategoryEntity.colId} = ?',
      whereArgs: <int>[categoryId],
    );
    if (list.isNotEmpty) {
      return CategoryEntity.fromObject(list.first);
    }
    return null;
  }

  Future<List<CategoryWithValueEntity>> getCategoriesWithTotalValue() async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> query = await database.rawQuery(
      'select * from ${CategoryEntity.tableName} natural join ('
          'select ${CategoryEntity.colId}, '
          'sum(${ExpenseEntity.colValue}) as ${CategoryWithValueEntity.colTotalValue} '
          'from ${CategoryWithValueEntity.tableName} group by ${CategoryEntity.colId}'
          ')'
    );
    return query
        .map((Map<String, dynamic> categoryMap) =>
            CategoryWithValueEntity.fromObject(categoryMap))
        .toList();
  }

  Future<int> getUsagesOfCategory(int categoryId) async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> list = await database.rawQuery(
      'select count(*) from ${ExpenseEntity.tableName} '
      'where ${ExpenseEntity.colCategoryId} = $categoryId',
    );
    int amount = Sqflite.firstIntValue(list);
    return amount;
  }
}
