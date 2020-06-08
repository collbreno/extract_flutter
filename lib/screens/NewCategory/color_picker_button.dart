import 'package:flutter/material.dart';

class ColorPickerButton extends StatelessWidget {

  final Color color;
  final void Function() onTap;

  const ColorPickerButton({Key key, this.color, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      onTap: onTap,
      leading: Icon(Icons.color_lens),
      trailing: Container(
        width: 20,
        height: 20,
        decoration:
        ShapeDecoration(shape: CircleBorder(), color: color),
      ),
      title: Text("Selecione a cor"),
    );
  }
}
