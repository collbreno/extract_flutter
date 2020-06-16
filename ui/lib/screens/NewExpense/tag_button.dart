import 'package:flutter/material.dart';

class TagButton extends StatelessWidget {
  TagButton({Key key, this.onTap}) : super(key: key);

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Tags"),
      onTap: onTap,
      leading: Icon(Icons.label),
      trailing: Text("Editar"),
    );
  }
}
