import 'package:business/business.dart';
import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/components/PickerDialog.dart';
import 'package:ui/helpers/colors.dart';
import 'package:ui/helpers/icons.dart';
import 'package:ui/screens/NewCategory/title_text_field.dart';

import 'color_picker_button.dart';
import 'icon_picker_button.dart';

class NewCategoryScreen extends StatefulWidget {
  const NewCategoryScreen({Key key, this.onDispose}) : super(key: key);

  final void Function() onDispose;

  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final screenTitle = "Nova Categoria";

  CategoryService _categoryService = CategoryService();
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.ac_unit;
  TextEditingController _titleController = TextEditingController();
  bool _titleHasError = false;
  bool _isColorNull = false;
  bool _isIconNull = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      if (_titleController.text.isNotEmpty) {
        setState(() {
          _titleHasError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    if (widget.onDispose != null) widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: renderAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            children: <Widget>[
              TitleTextField(
                color: _selectedColor,
                hasError: _titleHasError,
                controller: _titleController,
              ),
              IconPickerButton(
                color: _selectedColor,
                icon: _selectedIcon,
                onTap: _showIconPickerDialog,
              ),
              ColorPickerButton(
                onTap: _showColorPickerDialog,
                color: _selectedColor,
              ),
              renderSaveButton(),
            ],
          ),
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

  void _showIconPickerDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PickerDialog<MapEntry<String, IconData>>(
        columns: 4,
        items: materialIconList.entries.toList(),
        onSearch: (entry, text) => entry.key.contains(text),
        onItemSelected: (entry) {
          setState(() {
            _selectedIcon = entry.value;
          });
        },
        title: "Selecione o ícone",
        renderer: (entry) {
          return (Center(
            child: Icon(
              entry.value,
              color: _selectedColor,
            ),
          ));
        },
      ),
    );
  }

  void _showColorPickerDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PickerDialog<Color>(
        columns: 5,
        title: "Selecione a cor",
        items: MaterialColors.getAllColorAndTones(),
        onItemSelected: (color) {
          setState(() {
            _selectedColor = color;
          });
        },
        renderer: (color) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              child: null,
              decoration: ShapeDecoration(
                  color: color,
                  shape: CircleBorder(
                      side: BorderSide(width: 0.5, color: Colors.black))),
            ),
          );
        },
      ),
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
    int response = await _categoryService.insert(
      Category(
        title: _titleController.text.trim(),
        color: _selectedColor,
        icon: _selectedIcon,
      ),
    );
    if (response != null && response > 0) {
      _resetFields();
      SnackBar snackBar = SnackBar(
        content: Text("Categoria criada com sucesso"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else {
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Algo deu errado ao criar categoria",
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
