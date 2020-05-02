import 'package:extract_flutter/components/PickerDialog.dart';
import 'package:extract_flutter/models/category.dart';
import 'package:extract_flutter/services/colors.dart';
import 'package:extract_flutter/services/icons.dart';
import 'package:extract_flutter/services/repositories/CategoryRepository.dart';
import 'package:flutter/material.dart';

class NewCategoryScreen extends StatefulWidget {
  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final screenTitle = "Nova Categoria";

  CategoryRepository _categoryRepository = CategoryRepository();
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.ac_unit;
  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: renderAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          children: <Widget>[
            renderTitleTextField(),
            renderIconButton(),
            renderColorButton(),
            renderSaveButton(),
          ],
        ),
      )
    );
  }

  AppBar renderAppBar(){
    return AppBar(
      automaticallyImplyLeading: true,
      title: Hero(tag: screenTitle.toUpperCase(), child: Text(screenTitle, textAlign: TextAlign.left, style: TextStyle(color: Colors.white, decoration: TextDecoration.none, fontSize: 20),),),
      backgroundColor: _selectedColor,
    );
  }

  Widget renderTitleTextField(){
    return Padding(
      padding: EdgeInsets.symmetric( horizontal: 12, vertical: 5 ),
      child: TextField(
        controller: _titleController,
        cursorColor: _selectedColor,
        decoration: InputDecoration(
          icon: Icon(Icons.edit),
          labelText: 'Nome',
          hintText: "Insira o nome da categoria",
          border: UnderlineInputBorder()
        ),
      ),
    );
  }
  
  Widget renderIconButton(){
    return ListTile(
      onTap: (){
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => PickerDialog<IconData>(
            columns: 4,
            items: materialIconList.values.toList(),
            onItemSelected: (icon){
              setState(() {
                _selectedIcon = icon; 
              });
            },
            title: "Selecione o ícone",
            renderer: (icon){
              return (Center(child: Icon(icon, color: _selectedColor,),));
            },
          )
        );
      },
      leading: Icon(Icons.image),
      trailing: Icon(_selectedIcon, color: _selectedColor,),
      title: Text("Selecione o ícone"),
    );
  }

  Widget renderColorButton(){
    return ListTile(
      onTap: (){
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => PickerDialog<Color>(
            columns: 5,
            title: "Selecione a cor",
            items: MaterialColors.getAllColorAndTones(),
            onItemSelected: (color){
              setState(() {
                _selectedColor = color; 
              });
            },
            renderer: (color){
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  child: null,
                  decoration: ShapeDecoration(
                    color: color,
                    shape: CircleBorder(side: BorderSide(width: 0.5, color: Colors.black))
                  ),
                ),
              );
            },
          )
        );
      },
      leading: Icon(Icons.color_lens),
      trailing: Container(width: 20, height: 20, decoration: ShapeDecoration(shape: CircleBorder(), color: _selectedColor),),
      title: Text("Selecione a cor"),
    );
  }

  void _insertCategory() async {
    int response = await _categoryRepository.insertCategory(Category(_titleController.text, _selectedColor, _selectedIcon));
    if (response != null && response > 0){
      _resetFields();
      SnackBar snackbar = SnackBar(content: Text("Categoria criada com sucesso"),);
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
    else {
      SnackBar snackbar = SnackBar(backgroundColor: Colors.red, content: Text("Algo deu errado ao criar categoria", style: TextStyle(color: Colors.white),),);
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  void _resetFields(){
    setState(() {
     _titleController.text = '';
     _selectedColor = Colors.blue;
     _selectedIcon = Icons.ac_unit;
    });
  }
  
  Widget renderSaveButton(){
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: RaisedButton(
        color: _selectedColor,
        onPressed: () => _insertCategory(),
        child: Text("Salvar".toUpperCase()),
      ),
    );
  }

}