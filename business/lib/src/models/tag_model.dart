import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';

class Tag {
  int id;
  final String title;
  final Color color;
  final Color textColor;
  final IconData icon;

  Tag({
    this.id,
    this.title,
    this.color,
    this.textColor,
    this.icon,
  });

  Tag.fromEntity(TagEntity entity)
      : id = entity.id,
        title = entity.title,
        color = Color(entity.colorValue),
        textColor = Color(entity.textColorValue),
        icon = entity.iconCodePoint != null
            ? IconData(
                entity.iconCodePoint,
                fontPackage: entity.iconFontPackage,
                fontFamily: entity.iconFontFamily,
              )
            : null;

  TagEntity toEntity() {
    return TagEntity(
        id: id,
        title: title,
        colorValue: color.value,
        textColorValue: textColor.value,
        iconCodePoint: icon?.codePoint,
        iconFontFamily: icon?.fontFamily,
        iconFontPackage: icon?.fontPackage);
  }
}
