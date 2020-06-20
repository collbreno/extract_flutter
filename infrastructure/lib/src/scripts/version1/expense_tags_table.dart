import 'package:infrastructure/src/scripts/version1/expense_table.dart';
import 'package:infrastructure/src/scripts/version1/tag_table.dart';

class ExpenseTagsTableVersion1 {
  static const String tableName = 'expenseTags';
  static const String colExpenseId = ExpenseTableVersion1.colId;
  static const String colTagId = TagTableVersion1.colId;
  static const String fkTag = 'fk_tag';
  static const String fkExpense = 'fk_expense';
  static const String createScript = 'create table $tableName ('
      '$colExpenseId integer,'
      '$colTagId integer,'
      'primary key ($colTagId,$colExpenseId),'
      'constraint $fkExpense '
      'foreign key ($colExpenseId) '
      'references ${ExpenseTableVersion1.tableName}(${ExpenseTableVersion1.colId}) '
      'on update cascade '
      'on delete cascade, '
      'constraint $fkTag '
      'foreign key ($colTagId) '
      'references ${TagTableVersion1.tableName}(${TagTableVersion1.colId}) '
      'on update cascade '
      'on delete cascade '
      ')' ;
}