import 'package:flutter/material.dart';

class IconPickerButton extends StatelessWidget {

  final void Function() onTap;
  final IconData icon;
  final Color color;

  const IconPickerButton({Key key, this.onTap, this.icon, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(Icons.image),
      trailing: Icon(
        icon,
        color: color,
      ),
      title: Text("Selecione o ícone"),
    );
  }
}
