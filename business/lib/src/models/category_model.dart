import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';

class Category {
  final int id;
  final String title;
  final Color color;
  final IconData icon;

  Category({
    this.id,
    this.title,
    this.color,
    this.icon,
  });

  Category.fromEntity(CategoryEntity entity)
      : id = entity.id,
        title = entity.title,
        color = Color(entity.colorValue),
        icon = IconData(
          entity.iconCodePoint,
          fontFamily: entity.iconFontFamily,
          fontPackage: entity.iconFontPackage,
        );

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      title: title,
      colorValue: color.value,
      iconCodePoint: icon.codePoint,
      iconFontFamily: icon.fontFamily,
      iconFontPackage: icon.fontPackage,
    );
  }
}
