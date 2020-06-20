import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/helpers/navigator.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryService _categoryService = CategoryService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Category> _categories = <Category>[];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    var categories = await _categoryService.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Categorias"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          AppNavigator.pushNewCategoryScreen(context,
              onDispose: _fetchCategories);
        },
      ),
      body: RefreshIndicator(
        onRefresh: _fetchCategories,
        child: Scrollbar(
          child: ListView.builder(
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
        ),
      ),
    );
  }

  void _showConfirmationDialog(Category category, int amount) {
    String text = amount == 1 ? 'gasto' : 'gastos';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Categoria em uso"),
          content: Text(
            "A categoria está sendo usada por $amount $text. Você quer apagar todos os gastos que utilizam esta categoria?",
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar".toUpperCase()),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Deletar".toUpperCase()),
              onPressed: () {
                Navigator.pop(context);
                _deleteCategory(category);
              },
            )
          ],
        );
      },
    );
  }

  void _showSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _showErrorSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _handleAction(BuildContext context, String action, Category category) {
    if (action == Actions.delete) {
      _tryToDeleteCategory(category);
    } else if (action == Actions.edit) {
      _editCategory(category);
    }
  }

  void _tryToDeleteCategory(Category category) async {
    try {
      int usages = await _categoryService.getUsagesOfCategory(category.id);
      if (usages > 0)
        _showConfirmationDialog(category, usages);
      else
        _deleteCategory(category);
    } catch (e) {
      print(e);
      _showErrorSnackBar('Algo deu errado');
    }
  }

  void _deleteCategory(Category category) async {
    try {
      await _categoryService.deleteCategoryWithId(category.id);
      _showSnackBar("Categoria deletada com sucesso");
      _fetchCategories();
    } catch (e) {
      print(e);
      _showErrorSnackBar("Algo deu errado");
    }
  }

  void _editCategory(Category category) {
    AppNavigator.pushNewCategoryScreen(
      context,
      category: category,
      onDispose: _fetchCategories,
      closeOnSave: true,
    );
  }
}

class Actions {
  static const delete = 'Deletar';
  static const edit = 'Editar';
}
