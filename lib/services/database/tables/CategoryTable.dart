class CategoryTable {
  static const String tableName = 'category';
  static const String colId = 'categoryId';
  static const String colTitle = 'categoryTitle';
  static const String colColor = 'categoryColor';
  static const String colIconCodePoint = 'categoryIconCodePoint';
  static const String colIconFontFamily = 'categoryIconFontFamily';
  static const String colIconFontPackage = 'categoryIconFontPackage';
  static const String createScript = "create table $tableName(" +
                                     "$colId integer primary key," +
                                     "$colTitle text," +
                                     "$colColor integer," +
                                     "$colIconCodePoint integer," +
                                     "$colIconFontFamily text," +
                                     "$colIconFontPackage text)";
}