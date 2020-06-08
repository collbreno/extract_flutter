import 'package:flutter/material.dart';

class ValueButton extends StatelessWidget {
  ValueButton({Key key, this.value, this.onTap, this.hasError}) : super(key: key);

  final int value;
  final void Function() onTap;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(formatCash(value)),
      leading: Icon(Icons.attach_money),
      trailing: hasError ? Icon(Icons.error, color: Colors.red,) : null,
      onTap: onTap,
    );
  }

  String formatCash(int value) {
    return "R\$ " + (value.toDouble() / 100).toStringAsFixed(2);
  }
}
