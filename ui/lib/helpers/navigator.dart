import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/screens/AddTag/addTagScreen.dart';
import 'package:ui/screens/AddTag/newTagDialog.dart';
import 'package:ui/screens/Categories/categories_screen.dart';
import 'package:ui/screens/ExpenseDetail/expenseDetailScreen.dart';
import 'package:ui/screens/History/historyScreen.dart';
import 'package:ui/screens/NewCategory/new_category_screen.dart';
import 'package:ui/screens/NewExpense/newExpenseScreen.dart';
import 'package:ui/screens/NewTag/new_tag_screen.dart';
import 'package:ui/screens/Tags/tags_screen.dart';

class AppNavigator {
  static void pushNewExpenseScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NewExpenseScreen()));
  }

  static void pushNewCategoryScreen(
    BuildContext context, {
    void Function() onDispose,
    Category category,
    bool closeOnSave = false,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewCategoryScreen(
          onDispose: onDispose,
          category: category,
          closeOnSave: closeOnSave,
        ),
      ),
    );
  }

  static void pushNewTagScreen(
    BuildContext context, {
    void Function() onDispose,
    Tag tag,
    bool closeOnSave = false,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewTagScreen(
          onDispose: onDispose,
          tag: tag,
          closeOnSave: closeOnSave,
        ),
      ),
    );
  }

  static void pushHistoryScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HistoryScreen()));
  }

  static void pushAddTagScreen(
      BuildContext context, List<Tag> tags, void Function(List<Tag>) onUpdate) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AddTagScreen(tags, onUpdate)));
  }

  static void pushDetailTagScreen(
    BuildContext context, {
    Expense expense,
    void Function() onDatabaseChange,
  }) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ExpenseDetailScreen(
              expense: expense,
              onDatabaseChange: onDatabaseChange,
            )));
  }

  static void pushCategoriesScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CategoriesScreen()));
  }

  static void pushTagsScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => TagsScreen()));
  }
}
