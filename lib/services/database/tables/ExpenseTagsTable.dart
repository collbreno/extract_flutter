import 'package:extract_flutter/services/database/tables/ExpenseTable.dart';
import 'package:extract_flutter/services/database/tables/TagTable.dart';

class ExpenseTagsTable {
  static const String tableName = 'expenseTags';
  static const String colExpenseId = ExpenseTable.colId;
  static const String colTagId = TagTable.colId;
  static const String fkTag = 'fk_tag';
  static const String fkExpense = 'fk_expense';
  static const String createScript = 'create table $tableName (' +
                                     '$colExpenseId integer,' +
                                     '$colTagId integer,' +
                                     'primary key ($colTagId,$colExpenseId),' +
                                     'constraint $fkExpense ' +
                                     'foreign key ($colExpenseId) ' +
                                     'references ${ExpenseTable.tableName}(${ExpenseTable.colId}), ' +
                                     'constraint $fkTag ' +
                                     'foreign key ($colTagId) ' +
                                     'references ${TagTable.tableName}(${TagTable.colId}) )' ;
}