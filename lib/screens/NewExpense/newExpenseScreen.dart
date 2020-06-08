import 'package:extract_flutter/components/Calculator.dart';
import 'package:extract_flutter/components/PickerDialog.dart';
import 'package:extract_flutter/components/TagChip.dart';
import 'package:extract_flutter/models/Expense.dart';
import 'package:extract_flutter/models/Tag.dart';
import 'package:extract_flutter/models/Category.dart';
import 'package:extract_flutter/screens/NewExpense/category_button.dart';
import 'package:extract_flutter/screens/NewExpense/date_button.dart';
import 'package:extract_flutter/screens/NewExpense/description_text_field.dart';
import 'package:extract_flutter/screens/NewExpense/tag_button.dart';
import 'package:extract_flutter/screens/NewExpense/value_button.dart';
import 'package:extract_flutter/services/navigator.dart';
import 'package:extract_flutter/services/repositories/CategoryRepository.dart';
import 'package:extract_flutter/services/repositories/ExpenseRepository.dart';
import 'package:flutter/material.dart';

class NewExpenseScreen extends StatefulWidget {
  @override
  _NewExpenseScreenState createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ExpenseRepository _expenseRepository = ExpenseRepository();
  CategoryRepository _categoryRepository = CategoryRepository();
  List<Tag> _selectedTags = List<Tag>();
  List<Category> _categories = List<Category>();
  Category _selectedCategory;
  TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _value = 0;
  bool _valueHasError = false;
  bool _categoryHasError = false;
  bool _descriptionHasError = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _descriptionController.addListener(() {
      if (_descriptionController.text.isNotEmpty) {
        setState(() {
          _descriptionHasError = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Novo gasto'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        children: <Widget>[
          ValueButton(
            value: _value,
            onTap: _showCalculator,
            hasError: _valueHasError,
          ),
          CategoryButton(
            category: _selectedCategory,
            onTap: _showCategoryPicker,
            hasError: _categoryHasError,
          ),
          DateButton(
            date: _selectedDate,
            onTap: _showDatePicker,
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
    bool valid = true;
    if (_value <= 0) {
      valid = false;
      _setValueError(true);
    }
    if (_selectedCategory == null) {
      valid = false;
      _setCategoryError(true);
    }
    if (_selectedDate == null) {
      valid = false;
    }
    if (_descriptionController.text.isEmpty) {
      valid = false;
      _setDescriptionError(true);
    }
    if (valid) {
      _insertCategory();
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

  void _insertCategory() async {
    var expenseToInsert = Expense(_value, _selectedDate,
        _descriptionController.text.trim(), _selectedCategory, _selectedTags);
    var result = await _expenseRepository.insertExpense(expenseToInsert);
    if (result != null && result > 0) {
      _resetFields();
      SnackBar snackBar = SnackBar(
        content: Text("Gasto criado com sucesso"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else {
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Algo deu errado ao criar gasto",
          style: TextStyle(color: Colors.white),
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Widget _renderSaveButton() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 50),
        child: RaisedButton(
          color: Colors.blue,
          child: Text(
            "Salvar".toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
          onPressed: _checkFieldsAndInsert,
        ),
      ),
    );
  }

  Widget _renderTagList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: _selectedTags.map((tag) {
          return Padding(
            padding: EdgeInsets.all(2),
            child: TagChip(tag),
          );
        }).toList(),
      ),
    );
  }

  void _showCalculator() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Calculator(
          onSubmit: (result) {
            setState(() {
              if (result > 0) {
                _valueHasError = false;
              }
              _value = result;
            });
          },
        );
      },
    );
  }

  void _updateTags(List<Tag> newTags) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedTags = newTags;
      });
    });
  }

  void _showTagScreen() {
    AppNavigator.pushAddTagScreen(context, _selectedTags, _updateTags);
  }

  void _resetFields() {
    setState(() {
      _value = 0;
      _descriptionController.text = '';
      _selectedCategory = null;
      _selectedTags = List<Tag>();
      _selectedDate = DateTime.now();
      _descriptionHasError = false;
      _valueHasError = false;
      _categoryHasError = false;
    });
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    ).then((date) {
      if (date != null) {
        setState(() {
          _selectedDate = date;
        });
      }
    });
  }

  void _showCategoryPicker() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PickerDialog<Category>(
          title: "Selecione a categoria",
          items: _categories,
          onSearch: (category, text) => category.title.contains(text),
          footer: ListTile(
            title: Text("Nova categoria"),
            leading: Icon(Icons.add),
            onTap: _createCategory,
          ),
          onItemSelected: (category) {
            setState(() {
              _categoryHasError = false;
              _selectedCategory = category;
            });
          },
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

  void _createCategory() {
    Navigator.pop(context);
    AppNavigator.pushNewCategoryScreen(context, onDispose: _fetchCategories);
  }

  void _fetchCategories() {
    _categoryRepository.getCategories().then((result) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _categories = result;
        });
      });
    });
  }
}
