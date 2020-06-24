import 'package:infrastructure/src/scripts/version1/version1_scripts.dart';

class CategoryEntity {
  static const String tableName = CategoryTableVersion1.tableName;
  static const String colId = CategoryTableVersion1.colId;
  static const String colTitle = CategoryTableVersion1.colTitle;
  static const String colColor = CategoryTableVersion1.colColor;
  static const String colIconCodePoint = CategoryTableVersion1.colIconCodePoint;
  static const String colIconFontFamily =
      CategoryTableVersion1.colIconFontFamily;
  static const String colIconFontPackage =
      CategoryTableVersion1.colIconFontPackage;

  final int id;
  final String title;
  final int colorValue;
  final int iconCodePoint;
  final String iconFontFamily;
  final String iconFontPackage;

  CategoryEntity({
    this.id,
    this.title,
    this.colorValue,
    this.iconCodePoint,
    this.iconFontFamily,
    this.iconFontPackage,
  });

  CategoryEntity.fromObject(dynamic o)
      : id = o[colId] as int,
        title = o[colTitle] as String,
        colorValue = o[colColor] as int,
        iconCodePoint = o[colIconCodePoint] as int,
        iconFontFamily = o[colIconFontFamily] as String,
        iconFontPackage = o[colIconFontPackage] as String;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map[colId] = id;
    }
    map[colTitle] = title;
    map[colColor] = colorValue;
    map[colIconCodePoint] = iconCodePoint;
    map[colIconFontFamily] = iconFontFamily;
    map[colIconFontPackage] = iconFontPackage;
    return map;
  }
}
