import 'package:extract_flutter/components/Calculator.dart';
import 'package:extract_flutter/components/PickerDialog.dart';
import 'package:extract_flutter/components/TagChip.dart';
import 'package:extract_flutter/models/Expense.dart';
import 'package:extract_flutter/models/Tag.dart';
import 'package:extract_flutter/models/category.dart';
import 'package:extract_flutter/services/navigator.dart';
import 'package:extract_flutter/services/repositories/CategoryRepository.dart';
import 'package:extract_flutter/services/repositories/ExpenseRepository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class NewExpenseScreen extends StatefulWidget {
  @override
  _NewExpenseScreenState createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {

  
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ExpenseRepository _expenseReporitory = ExpenseRepository();
  CategoryRepository _categoryRepository = CategoryRepository();
  List<Tag> _selectedTags = List<Tag>();
  List<Category> _categories;
  Category _selectedCategory;
  TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR');
    if (_categories == null) {
      _categories = List<Category>();
      getData();
    }
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Novo gasto'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              renderValueButton(),
              renderCategoryButton(),
              renderDateButton(),
              renderDescriptionText(),
              renderTagButton(context),
              renderTagList(context),
              renderSaveButton(),
            ],
          ),
        ) 
      ),
    );
  }

  void _insertCategory() async {
    var expenseToInsert = Expense(_value, _selectedDate, _descriptionController.text, _selectedCategory, _selectedTags);
    var result = await _expenseReporitory.insertExpense(expenseToInsert);
    if (result != null && result > 0){
      resetFields();
      SnackBar snackbar = SnackBar(content: Text("Gasto criado com sucesso"),);
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
    else {
      SnackBar snackbar = SnackBar(backgroundColor: Colors.red, content: Text("Algo deu errado ao criar gasto", style: TextStyle(color: Colors.white),),);
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  Widget renderSaveButton(){
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 50),
        child: RaisedButton(
          color: Colors.blue,
          child: Text("Salvar".toUpperCase(), style: TextStyle(color: Colors.white),),
          onPressed: () => _insertCategory(),
        ),
      ),
    );
  }

  Widget renderDescriptionText(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _descriptionController,
        decoration: InputDecoration(
          labelText: "Descrição",
          hintText: "Insira uma breve descrição",
          icon: Icon(Icons.edit)
        ),
      ),
    );
  }

  Widget renderTagList(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: _selectedTags.map((tag){
          return Padding(
            padding: EdgeInsets.all(2),
            child: TagChip(
                title: tag.title,
                color: tag.color,
                textColor: tag.textColor,
                icon: tag.icon,
            ),
          );
        }).toList(),
      ),
    );
  }

  String formatCash(int value){
    return "R\$ " + (value.toDouble()/100).toStringAsFixed(2);
  }

  Widget renderValueButton(){
    return ListTile(
      title: Text(formatCash(_value)),
      leading: Icon(Icons.attach_money),
      onTap: (){
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context){
            return Calculator(
              onSubmit: (result){
                setState(() {
                 _value = result; 
                });
              },
            );
          }
        );
      },
    );
  }

  Widget renderTagButton(BuildContext context) {
    return ListTile(
      title: Text("Tags"),
      onTap: () => AppNavigator.pushAddTagScreen(context, _selectedTags),
      leading: Icon(Icons.label),
      trailing: Text("Editar"),
    );
  }

  Widget renderCategoryButton(){
    if (_selectedCategory == null){
      return ListTile(
        title: Text("Selecione a categoria"),
        onTap: () => showCategoryPicker(),
        trailing: Icon(Icons.arrow_drop_down),
      );
    }
    return ListTile(
      title: Text(_selectedCategory.title),
      onTap: () => showCategoryPicker(),
      leading: Icon(_selectedCategory.icon, color: _selectedCategory.color,),
      trailing: Icon(Icons.arrow_drop_down),
    );
  }

  Widget renderDateButton(){
    var formatter = DateFormat('E, dd/MM/y', 'pt_BR');
    return ListTile(
      title: Text(formatter.format(_selectedDate)),
      onTap: () => _showDatePicker(),
      leading: Icon(Icons.calendar_today),
        trailing: Icon(Icons.arrow_drop_down),
    );
  }

  void resetFields(){
    setState(() {
      _value = 0;
     _descriptionController.text = '';
     _selectedCategory = null;
     _selectedTags = List<Tag>();
     _selectedDate = DateTime.now(); 
    });
  }

  void _showDatePicker(){
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    )
      .then((date){
        if (date != null){
          setState(() {
            _selectedDate = date;
          });
        }
      });
  }

  void showCategoryPicker(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PickerDialog<Category>(
        title: "Selecione a categoria",
        items: _categories,
        onItemSelected: (category){
          setState(() {
           _selectedCategory = category; 
          });
        },
        renderer: (category){
          return ListTile(
            leading: Icon(category.icon, color: category.color,),
            title: Text(category.title),
          );
        },
      )
    );
  }

  void getData() {
    _categoryRepository.getCategories()
      .then((result){
        setState(() {
          _categories = result;
        });
      });
  }
}