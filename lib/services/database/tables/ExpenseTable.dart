import 'package:extract_flutter/services/database/tables/CategoryTable.dart';

class ExpenseTable {
  static const String tableName = 'expense';
  static const String colId = 'expenseId';
  static const String colDescription = 'expenseDescription';
  static const String colDate = 'expenseDate';
  static const String colCategoryId = CategoryTable.colId;
  static const String colValue = 'expenseValue';
  static const String fkCategory = 'fk_category';
  static const String createScript = "create table $tableName(" +
                                     "$colId integer primary key," +
                                     "$colDescription text," +
                                     "$colDate date," +
                                     "$colValue integer," +
                                     "$colCategoryId integer," +
                                     "constraint $fkCategory " +
                                     "foreign key ($colCategoryId) " +
                                     "references ${CategoryTable.tableName}(${CategoryTable.colId}) " +
                                     ")";
}