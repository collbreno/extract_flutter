import 'package:flutter/material.dart';

class TitleTextField extends StatelessWidget {
  final bool hasError;
  final Color color;
  final String placeholder;
  final TextEditingController controller;

  const TitleTextField({
    Key key,
    this.hasError,
    this.color,
    this.controller,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: TextField(
        controller: controller,
        cursorColor: color,
        decoration: InputDecoration(
            icon: Icon(Icons.edit),
            suffixIcon: hasError
                ? Icon(
                    Icons.error,
                    color: Colors.red,
                  )
                : null,
            errorText: hasError ? 'Não pode ser vazio' : null,
            labelText: 'Nome',
            hintText: placeholder,
            border: UnderlineInputBorder()),
      ),
    );
  }
}
