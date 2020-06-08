import 'package:extract_flutter/models/Category.dart';
import 'package:extract_flutter/services/database/tables/CategoryTable.dart';
import 'package:extract_flutter/services/database/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepository {

  final DbHelper _dbHelper = DbHelper();

  Future<int> insertCategory(Category category) async {
    Database db = await _dbHelper.database;
    var result = await db.insert(CategoryTable.tableName, category.toMap());
    return result;
  }

  Future<List<Category>> getCategories() async {
    Database db = await _dbHelper.database;
    var list = await db.query(CategoryTable.tableName);
    return list.map((element){
      return Category.fromObject(element);
    }).toList();
  }

  Future<int> getCategoriesAmount() async {
    Database db = await _dbHelper.database;
    var count = Sqflite.firstIntValue(
      await db.rawQuery("select count (*) from ${CategoryTable.tableName}")
    );
    return count;
  }
  

}