import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateButton extends StatelessWidget {
  DateButton({
    Key key,
    this.onDateSelected,
    this.selectedDate,
  }) : super(key: key);

  final void Function(DateTime) onDateSelected;
  final DateTime selectedDate;

  final formatter = DateFormat('E, dd/MM/y', 'pt_BR');

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(formatter.format(selectedDate)),
      onTap: () => _showDatePicker(context),
      leading: Icon(Icons.calendar_today),
      trailing: Icon(Icons.arrow_drop_down),
    );
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    ).then((date) {
      if (date != null) {
        onDateSelected(date);
      }
    });
  }
}
