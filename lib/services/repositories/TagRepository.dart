import 'package:extract_flutter/models/Tag.dart';
import 'package:extract_flutter/services/database/tables/TagTable.dart';
import 'package:extract_flutter/services/database/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

class TagRepository {

  final DbHelper _dbHelper = DbHelper();

  Future<int> insertTag(Tag tag) async {
    Database db = await _dbHelper.database;
    var result = await db.insert(TagTable.tableName, tag.toMap());
    return result;
  }

  Future<List<Tag>> getTags() async {
    Database db = await _dbHelper.database;
    var list = await db.query(TagTable.tableName);
    return list.map((element){
      return Tag.fromObject(element);
    }).toList();
  }

  Future<int> getTagsAmmount() async {
    Database db = await _dbHelper.database;
    var count = Sqflite.firstIntValue(
      await db.rawQuery("select count (*) from ${TagTable.tableName}")
    );
    return count;
  }

}