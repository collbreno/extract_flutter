import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/scripts/version1/category_table.dart';
import 'package:infrastructure/src/scripts/version1/expense_table.dart';

class CategoryWithValueEntity extends CategoryEntity {


  static const String tableName = '${ExpenseTableVersion1.tableName} natural join ${CategoryTableVersion1.tableName}';
  static const String colTotalValue = ExpenseTableVersion1.colValue;
  static const String colId = CategoryTableVersion1.colId;
  static const String colTitle = CategoryTableVersion1.colTitle;
  static const String colColor = CategoryTableVersion1.colColor;
  static const String colIconCodePoint = CategoryTableVersion1.colIconCodePoint;
  static const String colIconFontFamily =
      CategoryTableVersion1.colIconFontFamily;
  static const String colIconFontPackage =
      CategoryTableVersion1.colIconFontPackage;

  @override
  final int id;
  @override
  final String title;
  @override
  final int colorValue;
  @override
  final int iconCodePoint;
  @override
  final String iconFontFamily;
  @override
  final String iconFontPackage;
  final int totalValue;

  CategoryWithValueEntity({
    this.id,
    this.title,
    this.colorValue,
    this.iconCodePoint,
    this.iconFontFamily,
    this.iconFontPackage,
    this.totalValue,
  });

  CategoryWithValueEntity.fromObject(dynamic o)
      : id = o[colId] as int,
        title = o[colTitle] as String,
        colorValue = o[colColor] as int,
        totalValue = o[colTotalValue] as int,
        iconCodePoint = o[colIconCodePoint] as int,
        iconFontFamily = o[colIconFontFamily] as String,
        iconFontPackage = o[colIconFontPackage] as String;



}