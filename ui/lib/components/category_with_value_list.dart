import 'package:flutter/material.dart';
import 'package:business/business.dart';
import 'package:ui/helpers/money_helper.dart';

class CategoryWithValueList extends StatelessWidget {
  CategoryWithValueList({
    Map<Category, int> categories,
    this.primary = true,
  }) : this.categories = categories.entries.toList();

  final List<MapEntry<Category, int>> categories;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: primary,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        var entry = categories.elementAt(index);
        return Hero(
          tag: '${entry.key.id}_category_list_item',
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              title: Text(entry.key.title),
              leading: Icon(
                entry.key.icon,
                color: entry.key.color,
              ),
              trailing: Text(MoneyHelper.formatCash(entry.value), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),),
            ),
          ),
        );
      },
    );
  }
}
