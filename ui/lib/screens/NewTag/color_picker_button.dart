import 'package:flutter/material.dart';
import 'package:ui/components/PickerDialog.dart';
import 'package:ui/helpers/colors.dart';

class ColorPickerButton extends StatelessWidget {
  final void Function(Color) onColorSelected;
  final String title;
  final Icon leading;

  const ColorPickerButton({
    Key key,
    this.onColorSelected,
    this.title,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _showColorPickerDialog(context),
      leading: leading,
      trailing: Icon(Icons.arrow_drop_down),
      title: Text(title),
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PickerDialog<Color>(
        columns: 5,
        title: "Selecione a cor",
        items: MaterialColors.getAllColorAndTones(),
        onItemSelected: (color) => onColorSelected(color),
        renderer: (color) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              child: null,
              decoration: ShapeDecoration(
                color: color,
                shape: CircleBorder(
                  side: BorderSide(width: 0.5, color: Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
