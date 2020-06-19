import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/helpers/navigator.dart';

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          AppNavigator.pushNewCategoryScreen(context, onDispose: _fetchCategories);
        },
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          Category category = _categories.elementAt(index);
          return ListTile(
            key: Key(category.id.toString()),
            title: Text(category.title),
            leading: Icon(
              category.icon,
              color: category.color,
            ),
            trailing: PopupMenuButton<String>(
              child: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: null,
              ),
              onSelected: (action) => _handleAction(
                context,
                action,
                _categories.elementAt(index),
              ),
              itemBuilder: (BuildContext context) {
                return [Actions.edit, Actions.delete]
                    .map(
                      (action) => PopupMenuItem<String>(
                        child: Text(action),
                        value: action,
                      ),
                    )
                    .toList();
              },
            ),
          );
        },
      ),
    );
  }

  void _handleAction(BuildContext context, String action, Category category) {
    if (action == Actions.delete) {
      _categoryService.deleteCategoryWithId(category.id);
      _fetchCategories();
    } else if (action == Actions.edit) {
      AppNavigator.pushNewCategoryScreen(
        context,
        category: category,
        onDispose: _fetchCategories,
        closeOnSave: true,
      );
    }
  }
}

class Actions {
  static const delete = 'Deletar';
  static const edit = 'Editar';
}
