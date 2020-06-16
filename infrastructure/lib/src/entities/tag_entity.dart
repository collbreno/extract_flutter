import 'package:infrastructure/src/scripts/version1/version1_scripts.dart';

class TagEntity {
  static const String tableName = TagTableVersion1.tableName;
  static const String colId = TagTableVersion1.colId;
  static const String colTitle = TagTableVersion1.colTitle;
  static const String colColor = TagTableVersion1.colColor;
  static const String colTextColor = TagTableVersion1.colTextColor;
  static const String colIconCodePoint = TagTableVersion1.colIconCodePoint;
  static const String colIconFontFamily = TagTableVersion1.colIconFontFamily;
  static const String colIconFontPackage = TagTableVersion1.colIconFontPackage;

  final int id;
  final String title;
  final int colorValue;
  final int textColorValue;
  final int iconCodePoint;
  final String iconFontFamily;
  final String iconFontPackage;

  TagEntity({
    this.id,
    this.title,
    this.colorValue,
    this.textColorValue,
    this.iconCodePoint,
    this.iconFontFamily,
    this.iconFontPackage,
  });

  TagEntity.fromObject(dynamic o)
      : id = o[colId] as int,
        title = o[colTitle] as String,
        colorValue = o[colColor] as int,
        textColorValue = o[colTextColor] as int,
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
    map[colTextColor] = textColorValue;
    map[colIconCodePoint] = iconCodePoint;
    map[colIconFontFamily] = iconFontFamily;
    map[colIconFontPackage] = iconFontPackage;
    return map;
  }
}
