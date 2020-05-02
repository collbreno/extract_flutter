import 'package:flutter/material.dart';
import 'package:extract_flutter/services/database/tables/CategoryTable.dart';

class Category {
  int _id;
  String _title;
  Color _color;
  IconData _icon;

  Category (this._title, this._color, this._icon);
  Category.withId(this._id, this._title, this._color, this._icon);
  Category.fromObject(dynamic o) {
    this._id = o[CategoryTable.colId];
    this._title = o[CategoryTable.colTitle];
    this._color = Color(o[CategoryTable.colColor]);
    this._icon = IconData(o[CategoryTable.colIconCodePoint], fontFamily: o[CategoryTable.colIconFontFamily], fontPackage: o[CategoryTable.colIconFontPackage]);
  }

  int get id => _id;
  String get title => _title;
  Color get color => _color;
  IconData get icon => _icon;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[CategoryTable.colTitle] = _title;
    map[CategoryTable.colColor] = _color.value;
    map[CategoryTable.colIconCodePoint] = _icon.codePoint;
    map[CategoryTable.colIconFontFamily] = _icon.fontFamily;
    map[CategoryTable.colIconFontPackage] = _icon.fontPackage;
    if (_id != null) {
      map[CategoryTable.colId] = _id;
    }
    return map;
  }

  

}