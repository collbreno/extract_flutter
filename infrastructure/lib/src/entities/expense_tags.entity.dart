import 'package:infrastructure/src/scripts/version1/version1_scripts.dart';

class ExpenseTagsEntity {
  static const String tableName = ExpenseTagsTableVersion1.tableName;
  static const String colExpenseId = ExpenseTagsTableVersion1.colExpenseId;
  static const String colTagId = ExpenseTagsTableVersion1.colTagId;

  final int expenseId;
  final int tagId;

  ExpenseTagsEntity({
    this.expenseId,
    this.tagId,
  });

  ExpenseTagsEntity.fromObject(dynamic o)
      : expenseId = o[colExpenseId] as int,
        tagId = o[colTagId] as int;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      colExpenseId: expenseId,
      colTagId: tagId,
    };
    return map;
  }
}
