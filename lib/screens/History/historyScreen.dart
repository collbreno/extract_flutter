import 'package:extract_flutter/components/ExpenseCard.dart';
import 'package:extract_flutter/models/Expense.dart';
import 'package:extract_flutter/services/repositories/ExpenseRepository.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final title = "Histórico";
  List<Expense> _expenses = List<Expense>();
  ExpenseRepository _expenseRepository = ExpenseRepository();

  @override
  void initState() {
    super.initState();
    _fetchFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: title.toUpperCase(),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 20),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          return ExpenseCard(
            expense: _expenses.elementAt(index),
            onDatabaseChange: () => _fetchFromDatabase(),
          );
        },
      ),
    );
  }

  void _fetchFromDatabase() {
    _expenseRepository.getExpenses().then((expenses) {
      setState(() {
        _expenses = expenses;
      });
    });
  }
}
