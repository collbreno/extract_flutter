import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/components/PickerDialog.dart';
import 'package:ui/helpers/colors.dart';
import 'package:ui/helpers/icons.dart';
import 'package:ui/screens/NewCategory/title_text_field.dart';

import 'color_picker_button.dart';
import 'icon_picker_button.dart';

class NewCategoryScreen extends StatefulWidget {
  const NewCategoryScreen({
    Key key,
    this.onDispose,
    this.category,
    this.closeOnSave = false,
  }) : super(key: key);

  final void Function() onDispose;
  final Category category;
  final bool closeOnSave;

  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final screenTitle = "Nova Categoria";

  CategoryService _categoryService;
  Color _selectedColor;
  IconData _selectedIcon;
  TextEditingController _titleController;
  bool _titleHasError;
  bool _isColorNull;
  bool _isIconNull;

  @override
  void initState() {
    super.initState();
    _categoryService = CategoryService();
    _titleHasError = false;
    _isColorNull = false;
    _isIconNull = false;
    _titleController = TextEditingController();
    _titleController.addListener(() {
      if (_titleController.text.isNotEmpty) {
        setState(() {
          _titleHasError = false;
        });
      }
    });
    if (widget.category == null) {
      _selectedColor = Colors.blue;
      _selectedIcon = Icons.ac_unit;
    } else {
      _selectedColor = widget.category.color;
      _selectedIcon = widget.category.icon;
      _titleController.text = widget.category.title;
    }
  }

  @override
  void dispose() {
    if (widget.onDispose != null) widget.onDispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: renderAppBar(),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          children: <Widget>[
            TitleTextField(
              color: _selectedColor,
              hasError: _titleHasError,
              placeholder: "Insira o nome da categoria",
              controller: _titleController,
            ),
            IconPickerButton(
              color: _selectedColor,
              icon: _selectedIcon,
              onIconSelected: (IconData icon) {
                setState(() {
                  _selectedIcon = icon;
                });
              },
            ),
            ColorPickerButton(
              onColorSelected: (Color color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              color: _selectedColor,
            ),
            renderSaveButton(),
          ],
        ));
  }

  AppBar renderAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Hero(
        tag: screenTitle.toUpperCase(),
        child: Text(
          screenTitle,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20),
        ),
      ),
      backgroundColor: _selectedColor,
    );
  }

  void _checkFieldsAndInsert() {
    bool valid = true;
    if (_titleController.text.isEmpty) {
      valid = false;
      setState(() => _titleHasError = true);
    }
    if (_selectedColor == null) {
      valid = false;
    }
    if (_selectedIcon == null) {
      valid = false;
    }
    if (valid) {
      print('categoria valida');
      _insertCategory();
    } else {
      print('invalida');
    }
  }

  void _insertCategory() async {
    Category categoryToInsert = Category(
      id: widget.category?.id,
      title: _titleController.text.trim(),
      color: _selectedColor,
      icon: _selectedIcon,
    );
    String keyWordOnSuccess = categoryToInsert.id == null ? 'criada' : 'editada';
    String keyWordOnFail = categoryToInsert.id == null ? 'criar' : 'editar';
    int response;
    if (categoryToInsert.id == null) {
      response = await _categoryService.insert(categoryToInsert);
    }
    else {
      response = await _categoryService.updateCategory(categoryToInsert);
    }
    if (response != null && response > 0) {
      _resetFields();
      SnackBar snackBar = SnackBar(
        content: Text("Categoria $keyWordOnSuccess com sucesso"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      if (widget.closeOnSave) Navigator.pop(context);
    } else {
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Algo deu errado ao $keyWordOnFail categoria",
          style: TextStyle(color: Colors.white),
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void _resetFields() {
    setState(() {
      _titleController.text = '';
      _selectedColor = Colors.blue;
      _selectedIcon = Icons.ac_unit;
      _titleHasError = false;
    });
  }

  Widget renderSaveButton() {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: RaisedButton(
        color: _selectedColor,
        onPressed: _checkFieldsAndInsert,
        child: Text("Salvar".toUpperCase()),
      ),
    );
  }
}
