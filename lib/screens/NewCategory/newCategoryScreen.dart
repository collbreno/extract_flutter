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
  Color selectedColor = Colors.red;
  IconData selectedIcon = Icons.ac_unit;
  TextEditingController titleController = TextEditingController();

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
      backgroundColor: selectedColor,
    );
  }

  Widget renderTitleTextField(){
    return Padding(
      padding: EdgeInsets.symmetric( horizontal: 12, vertical: 5 ),
      child: TextField(
        controller: titleController,
        cursorColor: selectedColor,
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
                selectedIcon = icon; 
              });
            },
            title: "Selecione o ícone",
            renderer: (icon){
              return (Center(child: Icon(icon, color: selectedColor,),));
            },
          )
        );
      },
      leading: Icon(Icons.image),
      trailing: Icon(selectedIcon, color: selectedColor,),
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
                selectedColor = color; 
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
      trailing: Container(width: 20, height: 20, decoration: ShapeDecoration(shape: CircleBorder(), color: selectedColor),),
      title: Text("Selecione a cor"),
    );
  }
  
  Widget renderSaveButton(){
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: RaisedButton(
        color: selectedColor,
        onPressed: () async{
          int response = await _categoryRepository.insertCategory(Category(titleController.text, selectedColor, selectedIcon));
          if (response > 0) {
            showSnackbar("Categoria criada com sucesso!");
            setState(() {
              titleController.text = '';
              selectedColor = Colors.red;
              selectedIcon = Icons.ac_unit;
            });
          }
          else showSnackbar("Erro ao criar categoria.");
        },
        child: Text("Salvar".toUpperCase()),
      ),
    );
  }

  void showSnackbar(String text) {
    final snackbar = SnackBar(content: Text(text),);
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}