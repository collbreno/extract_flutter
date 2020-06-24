import 'package:flutter/material.dart';
import 'package:ui/components/PickerDialog.dart';
import 'package:ui/helpers/icons.dart';

class IconPickerButton extends StatelessWidget {

  final void Function(IconData) onIconSelected;
  final IconData icon;
  final Color color;

  const IconPickerButton({Key key, this.onIconSelected, this.icon, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _showIconPickerDialog(context),
      leading: Icon(Icons.image),
      trailing: Icon(
        icon,
        color: color,
      ),
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
        title: "Selecione o ícone",
        renderer: (entry) {
          return Tooltip(
            message: entry.key,
            child: Center(
              child: Icon(
                entry.value,
                color: color,
              ),
            ),
          );
        },
      ),
    );
  }

}
