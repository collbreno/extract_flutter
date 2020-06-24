import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/components/PickerDialog.dart';

class CategoryButton extends StatelessWidget {
  CategoryButton({
    Key key,
    this.selectedCategory,
    this.onCategorySelected,
    this.hasError,
    this.categories,
    this.onCreateCategory,
  }) : super(key: key);

  final Category selectedCategory;
  final List<Category> categories;
  final void Function() onCreateCategory;
  final void Function(Category) onCategorySelected;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    if (selectedCategory == null) {
      return ListTile(
        title: Text("Selecione a categoria"),
        onTap: () => _showCategoryPicker(context),
        trailing: hasError
            ? Icon(
                Icons.error,
                color: Colors.red,
              )
            : Icon(Icons.arrow_drop_down),
      );
    }
    return ListTile(
      title: Text(selectedCategory.title),
      onTap: () => _showCategoryPicker(context),
      leading: Icon(
        selectedCategory.icon,
        color: selectedCategory.color,
      ),
      trailing: Icon(Icons.arrow_drop_down),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PickerDialog<Category>(
          title: "Selecione a categoria",
          items: categories,
          onSearch: (category, text) =>
              category.title.toUpperCase().contains(text.toUpperCase()),
          footer: ListTile(
            title: Text("Nova categoria"),
            leading: Icon(Icons.add),
            onTap: onCreateCategory,
          ),
          onItemSelected: onCategorySelected,
          renderer: (category) {
            return ListTile(
              leading: Icon(
                category.icon,
                color: category.color,
              ),
              title: Text(category.title),
            );
          },
        );
      },
    );
  }
}
