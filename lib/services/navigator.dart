import 'package:extract_flutter/models/Tag.dart';
import 'package:extract_flutter/screens/AddTag/addTagScreen.dart';
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

  static void pushAddTagScreen(BuildContext context, {@required List<Tag> tags, @required void Function(List<Tag>) onSaveTags}){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTagScreen(tags, onSaveTags)));
  }
}