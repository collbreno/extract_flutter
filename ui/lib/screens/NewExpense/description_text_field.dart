import 'package:flutter/material.dart';

class DescriptionTextField extends StatelessWidget {
  const DescriptionTextField({Key key, this.controller, this.hasError}) : super(key: key);

  final TextEditingController controller;
  final bool hasError;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        controller: controller,
        decoration: InputDecoration(
          errorText: hasError ? 'Campo obrigatório' : null,
            labelText: "Descrição",
            suffixIcon: hasError ? Icon(Icons.error, color: Colors.red) : null,
            hintText: "Insira uma breve descrição",
            icon: Icon(Icons.edit)),
      ),
    );
  }
}
