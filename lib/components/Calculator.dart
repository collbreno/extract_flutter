import 'package:extract_flutter/services/calculator.dart';
import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  Calculator({@required this.onSubmit});
  final void Function(int) onSubmit;

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  String result = "";
  bool invalid = false;
  final List<String> buttons = ["CE", "(", ")", "back", "7", "8", "9", "/", "4", "5", "6", "*", "1", "2", "3", "-", "0", ".", "=", "+"];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Column( 
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerRight,
                height: 80,
                child: Text(result, style: TextStyle(fontSize: 20, color: invalid? Colors.red[700]:Colors.black87)),
              ),
              Positioned(
                right: 12,
                bottom: 4,
                child: Text(invalid?"Expressão inválida":"", style: TextStyle(color: Colors.red[700]),),
              )
            ],
          ),
          
          Container(
            height: 350,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context, index) => renderButton(index),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text("Cancelar".toUpperCase(), style: TextStyle(color: Colors.blue),),
        ),
        FlatButton(
          onPressed: (){
            if (calculateExpression()) {
              widget.onSubmit( times100AndCastToInt(result) );
              Navigator.pop(context);
            }
          },
          child: Text("Ok".toUpperCase(), style: TextStyle(color: Colors.blue),),
        ),
      ],
    );
  }

  Widget renderButton(int buttonIndex){
    bool rightColumnButton = (buttonIndex+1)%4 == 0;
    String buttonText = buttons.elementAt(buttonIndex);
    Color textColor = rightColumnButton? Colors.white : Colors.black87;
    return FlatButton(
      shape: BeveledRectangleBorder(),
      onLongPress: (){
        onLongPress(buttonText);
      },
      onPressed: (){
        onButtonPressed(buttonText);
      },
      color: rightColumnButton?Colors.blue:Colors.white,
      child: Center(
        child: renderButtonText(buttonText, textColor)
      ),
    );
  }

  Widget renderButtonText(String button, Color textColor){
    if (button == "back") {
      return Icon(Icons.backspace, color: textColor, size: 18,);
    }
    else if (button == '*') {
      return Icon(Icons.close, color: textColor, size: 18,);
    }
    else if (button == '+') {
      return Icon(Icons.add, color: textColor, size: 18,);
    }
    return Text(
      button,
      style: TextStyle(fontSize: 16, color: textColor),
    );
  }

  bool calculateExpression(){
    if (double.tryParse(result) != null) {
      return true;
    }
    try {
      String newResult = calculate(result);
      setState(() {
        result = newResult; 
      });
      return true;
    } 
    catch(e) {
      setState(() {
        invalid = true;
      });
      return false;
    }
  }

  void onButtonPressed(String button){
    setState(() {
      invalid = false;
    });
    if (button == 'back') {
      if (result.length > 0){
        setState(() {
        result = result.substring(0, result.length-1); 
        });
      }
    }
    else if ((button == '*' || button == '+' || button == '/') && (result.endsWith("+") || result.endsWith("-") || result.endsWith("/") || result.endsWith("*"))) {
      setState(() {
        result =  result.substring(0, result.length-1) + button;
      });
    }
    else if (button == '=') {
      calculateExpression();
    }
    else {
      setState(() {
        result = result+button; 
      });
    }
  }

  int times100AndCastToInt(String s){
    if (s.contains('.')) {
      int indexOfDot = s.indexOf(".");
      String integer = s.substring(0, indexOfDot);
      String fractionary = s.substring(indexOfDot+1)+"00";
      return int.tryParse(integer+fractionary.substring(0,2));
    }
    else {
      return int.tryParse( s+"00" );
    }
  }

  void onLongPress(String button){
    setState(() {
     invalid = false; 
    });
    if (button == 'back') {
      setState(() {
       result = ''; 
      });
    }
  }
}