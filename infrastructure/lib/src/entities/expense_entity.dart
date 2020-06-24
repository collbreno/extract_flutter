import 'package:infrastructure/src/scripts/version1/version1_scripts.dart';

class ExpenseEntity {
  static const String tableName = ExpenseTableVersion1.tableName;
  static const String colId = ExpenseTableVersion1.colId;
  static const String colDescription = ExpenseTableVersion1.colDescription;
  static const String colDate = ExpenseTableVersion1.colDate;
  static const String colCategoryId = ExpenseTableVersion1.colCategoryId;
  static const String colValue = ExpenseTableVersion1.colValue;

  final int id;
  final String description;
  final DateTime date;
  final int categoryId;
  final int value;

  ExpenseEntity({
    this.id,
    this.description,
    this.date,
    this.categoryId,
    this.value,
  });

  ExpenseEntity.fromObject(dynamic o)
      : id = o[colId] as int,
        value = o[colValue] as int,
        categoryId = o[colCategoryId] as int,
        date = DateTime.parse(o[colDate]),
        description = o[colDescription] as String;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map[colId] = id;
    }
    map[colDescription] = description;
    map[colDate] = date.toIso8601String();
    map[colValue] = value;
    map[colCategoryId] = categoryId;
    return map;
  }
}
