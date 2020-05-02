import 'package:extract_flutter/services/repositories/ExpenseRepository.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  final title = "Histórico";
  int _count = 0;
  ExpenseRepository _expenseRepository = ExpenseRepository();

  @override
  void initState() {
    super.initState();
    _fetchAmmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(tag: title.toUpperCase(), child: Text(title, textAlign: TextAlign.left, style: TextStyle(color: Colors.white, decoration: TextDecoration.none, fontSize: 20),),),
      ),
      body: Center(
        child: Text(_count.toString()),
      ),
    );
  }

  void _fetchAmmount(){
    _expenseRepository.getExpensesAmmount().then((value) => {
      setState((){
        _count = value;
      })
    });
  }
}