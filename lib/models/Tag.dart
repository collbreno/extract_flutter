import 'package:flutter/material.dart';
import 'package:extract_flutter/services/database/tables/TagTable.dart';

class Tag {
  int _id;
  String _title;
  Color _color;
  Color _textColor;
  IconData _icon;

  Tag (this._title, this._color, this._textColor, [this._icon]);
  Tag.withId(this._id, this._title, this._color, this._textColor, [this._icon]);
  Tag.fromObject(dynamic o) {
    this._id = o[TagTable.colId];
    this._title = o[TagTable.colTitle];
    this._color = Color(o[TagTable.colColor]);
    this._textColor = Color(o[TagTable.colTextColor]);
    if (o[TagTable.colIconCodePoint] != null){
      this._icon = IconData(o[TagTable.colIconCodePoint], fontFamily: o[TagTable.colIconFontFamily], fontPackage: o[TagTable.colIconFontPackage]);
    }
  }

  int get id => _id;
  String get title => _title;
  Color get color => _color;
  Color get textColor => _textColor;
  IconData get icon => _icon;

  set id(int newId) {
    if (newId > 0) _id = newId;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[TagTable.colTitle] = _title;
    map[TagTable.colColor] = _color.value;
    map[TagTable.colTextColor] = _textColor.value;
    map[TagTable.colIconCodePoint] = _icon?.codePoint;
    map[TagTable.colIconFontFamily] = _icon?.fontFamily;
    map[TagTable.colIconFontPackage] = _icon?.fontPackage;
    if (_id != null) {
      map[TagTable.colId] = _id;
    }
    return map;
  }

  @override
  String toString() {
    return "id: $id, title: $title";
  }
}