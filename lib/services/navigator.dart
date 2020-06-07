import 'package:extract_flutter/models/Expense.dart';
import 'package:extract_flutter/models/Tag.dart';
import 'package:extract_flutter/screens/AddTag/addTagScreen.dart';
import 'package:extract_flutter/screens/ExpenseDetail/expenseDetailScreen.dart';
import 'package:extract_flutter/screens/History/historyScreen.dart';
import 'package:extract_flutter/screens/NewCategory/newCategoryScreen.dart';
import 'package:extract_flutter/screens/NewExpense/newExpenseScreen.dart';
import 'package:flutter/material.dart';

class AppNavigator {
  static void pushNewExpenseScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewExpenseScreen()));
  }

  static void pushNewCategoryScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewCategoryScreen()));
  }

  static void pushHistoryScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryScreen()));
  }

  static void pushAddTagScreen(BuildContext context, List<Tag> tags, void Function(List<Tag>) onUpdate){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTagScreen(tags, onUpdate)));
  }

  static void pushDetailTagScreen(BuildContext context, Expense expense){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpenseDetailScreen(expense)));
  }
}