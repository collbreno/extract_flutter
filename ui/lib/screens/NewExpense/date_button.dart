import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateButton extends StatelessWidget {
  DateButton({Key key, this.onTap, this.date}) : super(key: key);

  final void Function() onTap;
  final DateTime date;

  final formatter = DateFormat('E, dd/MM/y', 'pt_BR');

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(formatter.format(date)),
      onTap: onTap,
      leading: Icon(Icons.calendar_today),
      trailing: Icon(Icons.arrow_drop_down),
    );
  }
}
