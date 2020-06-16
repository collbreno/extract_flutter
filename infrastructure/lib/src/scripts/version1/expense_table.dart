import 'package:infrastructure/src/scripts/version1/category_table.dart';

class ExpenseTableVersion1 {
  static const String tableName = 'expense';
  static const String colId = 'expenseId';
  static const String colDescription = 'expenseDescription';
  static const String colDate = 'expenseDate';
  static const String colCategoryId = CategoryTableVersion1.colId;
  static const String colValue = 'expenseValue';
  static const String fkCategory = 'fk_category';
  static const String createScript = 'create table $tableName('
      '$colId integer primary key,'
      '$colDescription text,'
      '$colDate date,'
      '$colValue integer,'
      '$colCategoryId integer,'
      'constraint $fkCategory '
      'foreign key ($colCategoryId) '
      'references ${CategoryTableVersion1.tableName}(${CategoryTableVersion1.colId}) '
      ')';
}