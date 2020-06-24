class TagTableVersion1 {
  static const String tableName = 'tag';
  static const String colId = 'tagId';
  static const String colTitle = 'tagTitle';
  static const String colColor = 'tagColor';
  static const String colTextColor = 'tagTextColor';
  static const String colIconCodePoint = 'tagIconCodePoint';
  static const String colIconFontFamily = 'tagIconFontFamily';
  static const String colIconFontPackage = 'tagIconFontPackage';
  static const String createScript = 'create table $tableName('
      '$colId integer primary key,'
      '$colTitle text,'
      '$colColor integer,'
      '$colTextColor integer,'
      '$colIconCodePoint integer,'
      '$colIconFontFamily text,'
      '$colIconFontPackage text)';
}