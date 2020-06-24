import 'package:flutter/material.dart';
import 'package:ui/components/PickerDialog.dart';
import 'package:ui/helpers/icons.dart';

class IconPickerButton extends StatelessWidget {
  final void Function(IconData) onIconSelected;
  final Color color;
  final Color textColor;

  const IconPickerButton({
    Key key,
    this.onIconSelected,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _showIconPickerDialog(context),
      leading: Icon(Icons.image),
      trailing: Icon(Icons.arrow_drop_down),
      title: Text("Selecione o ícone"),
    );
  }

  void _showIconPickerDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PickerDialog<MapEntry<String, IconData>>(
        columns: 4,
        items: materialIconList.entries.toList(),
        onSearch: (entry, text) => entry.key.toUpperCase().contains(text.toUpperCase()),
        onItemSelected: (entry) => onIconSelected(entry.value),
        onRemove: () => onIconSelected(null),
        title: "Selecione o ícone",
        renderer: (entry) {
          return Tooltip(
            message: entry.key,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  entry.value,
                  color: textColor,
                ),
              ),
              decoration: ShapeDecoration(
                color: color,
                shape: CircleBorder(),
              ),
            ),
          );
        },
      ),
    );
  }
}
