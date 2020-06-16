import 'package:business/business.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = <Category>[];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() {
    _categoryService.getCategories().then((List<Category> categories) {
      setState(() {
        _categories = categories;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          Category category = _categories.elementAt(index);
          return ListTile(
            title: Text(category.title),
            leading: Icon(
              category.icon,
              color: category.color,
            ),
          );
        },
      ),
    );
  }
}
