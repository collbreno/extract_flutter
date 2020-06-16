import 'package:business/business.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  CategoryButton({Key key, this.category, this.onTap, this.hasError}) : super(key: key);

  final Category category;
  final void Function() onTap;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    if (category == null) {
      return ListTile(
        title: Text("Selecione a categoria"),
        onTap: onTap,
        trailing: hasError ? Icon(Icons.error, color: Colors.red,) : Icon(Icons.arrow_drop_down),
      );
    }
    return ListTile(
      title: Text(category.title),
      onTap: onTap,
      leading: Icon(
        category.icon,
        color: category.color,
      ),
      trailing: Icon(Icons.arrow_drop_down),
    );
  }
}
