import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/components/Calculator.dart';
import 'package:ui/components/PickerDialog.dart';
import 'package:ui/components/TagChip.dart';
import 'package:ui/helpers/navigator.dart';
import 'package:ui/screens/NewExpense/tag_button.dart';
import 'package:ui/screens/NewExpense/value_button.dart';

import 'category_button.dart';
import 'date_button.dart';
import 'description_text_field.dart';

class NewExpenseScreen extends StatefulWidget {
  final Expense expense;
  final void Function() onDispose;
  final bool closeOnSave;

  NewExpenseScreen({
    Key key,
    this.expense,
    this.onDispose,
    this.closeOnSave,
  }) : super(key: key);

  @override
  _NewExpenseScreenState createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ExpenseService _expenseService;
  CategoryService _categoryService;
  List<Category> _categories = List<Category>();
  TextEditingController _descriptionController = TextEditingController();
  bool _valueHasError = false;
  bool _categoryHasError = false;
  bool _descriptionHasError = false;
  Expense _expense;

  @override
  void initState() {
    super.initState();
    _expenseService = ExpenseService();
    _categoryService = CategoryService();
    _fetchCategories();
    _expense = widget.expense ??
        Expense(
          description: '',
          tags: List<Tag>(),
          date: DateTime.now(),
          value: 0,
        );
    _descriptionController.text = _expense.description;
    _descriptionController.addListener(() {
      if (_descriptionController.text.isNotEmpty) {
        setState(() {
          _descriptionHasError = false;
          _expense.description = _descriptionController.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    print('rodando dispose');
    if (widget.onDispose != null) widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Novo gasto'),
      ),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        children: <Widget>[
          ValueButton(
            value: _expense.value,
            onValueChanged: (value) {
              setState(() {
                _expense.value = value;
                _valueHasError = false;
              });
            },
            hasError: _valueHasError,
          ),
          CategoryButton(
            selectedCategory: _expense.category,
            onCategorySelected: (category) {
              setState(() {
                _expense.category = category;
                _categoryHasError = false;
              });
            },
            categories: _categories,
            onCreateCategory: _createCategory,
            hasError: _categoryHasError,
          ),
          DateButton(
            selectedDate: _expense.date,
            onDateSelected: (date) {
              setState(() {
                _expense.date = date;
              });
            },
          ),
          DescriptionTextField(
            controller: _descriptionController,
            hasError: _descriptionHasError,
          ),
          TagButton(
            onTap: _showTagScreen,
          ),
          _renderTagList(context),
          _renderSaveButton(),
        ],
      ),
    );
  }

  void _checkFieldsAndInsert() {
    setState(() {
      _expense.description = _descriptionController.text;
    });
    bool valid = true;
    if (_expense.value <= 0) {
      valid = false;
      _setValueError(true);
    }
    if (_expense.category == null) {
      valid = false;
      _setCategoryError(true);
    }
    if (_expense.date == null) {
      valid = false;
    }
    if (_expense.description.isEmpty) {
      valid = false;
      _setDescriptionError(true);
    }
    if (valid) {
      _insertExpense();
    } else {
      print('nao valido');
    }
  }

  void _setValueError(bool hasError) =>
      setState(() => _valueHasError = hasError);

  void _setCategoryError(bool hasError) =>
      setState(() => _categoryHasError = hasError);

  void _setDescriptionError(bool hasError) =>
      setState(() => _descriptionHasError = hasError);

  void _insertExpense() async {
    String keywordOnSuccess = _expense.id == null ? 'criada' : 'editada';
    String keywordOnFail = _expense.id == null ? 'criar' : 'editar';
    int response;
    try {
      if (_expense.id == null) {
        response = await _expenseService.insertExpense(_expense);
      } else {
        response = await _expenseService.updateExpense(_expense);
      }
      if (response != null && response > 0) {
        _resetFields();
        _showSnackBar("Gasto $keywordOnSuccess com sucesso");
        if (widget.closeOnSave) Navigator.pop(context);
      } else {
        _showErrorSnackBar("Algo deu errado ao $keywordOnFail gasto");
      }
    } catch (error) {
      print(error);
      _showErrorSnackBar("Algo deu errado ap $keywordOnFail gasto");
    }
  }

  void _showErrorSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _showSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget _renderSaveButton() {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: RaisedButton(
        color: Colors.blue,
        child: Text(
          "Salvar".toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: _checkFieldsAndInsert,
      ),
    );
  }

  Widget _renderTagList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: _expense.tags.map((tag) {
          return Padding(
            padding: EdgeInsets.all(2),
            child: TagChip(tag),
          );
        }).toList(),
      ),
    );
  }

  void _updateTags(List<Tag> newTags) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _expense.tags = newTags;
      });
    });
  }

  void _showTagScreen() {
    AppNavigator.pushAddTagScreen(context, _expense.tags, _updateTags);
  }

  void _resetFields() {
    setState(() {
      _expense.id = null;
      _expense.tags = List<Tag>();
      _expense.category = null;
      _expense.description = '';
      _expense.value = 0;
      _expense.date = DateTime.now();
      _descriptionController.text = '';
      _descriptionHasError = false;
      _valueHasError = false;
      _categoryHasError = false;
    });
  }

  void _createCategory() {
    Navigator.pop(context);
    AppNavigator.pushNewCategoryScreen(
      context,
      onDispose: _fetchCategories,
      closeOnSave: true,
    );
  }

  void _fetchCategories() {
    _categoryService.getCategories().then((result) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _categories = result;
        });
      });
    });
  }
}
