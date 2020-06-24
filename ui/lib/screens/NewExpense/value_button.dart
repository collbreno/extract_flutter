import 'package:flutter/material.dart';
import 'package:ui/components/Calculator.dart';
import 'package:ui/helpers/money_helper.dart';

class ValueButton extends StatelessWidget {
  ValueButton({Key key, this.value, this.onValueChanged, this.hasError}) : super(key: key);

  final int value;
  final void Function(int) onValueChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(MoneyHelper.formatCash(value)),
      leading: Icon(Icons.attach_money),
      trailing: hasError ? Icon(Icons.error, color: Colors.red,) : null,
      onTap: () => _showCalculator(context),
    );
  }


  void _showCalculator(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Calculator(
          onSubmit: onValueChanged,
        );
      },
    );
  }
}
