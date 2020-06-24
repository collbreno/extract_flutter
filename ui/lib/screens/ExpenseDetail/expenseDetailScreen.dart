import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui/components/TagChip.dart';
import 'package:ui/helpers/money_helper.dart';
import 'package:ui/helpers/navigator.dart';

class ExpenseDetailScreen extends StatefulWidget {
  ExpenseDetailScreen({
    this.expense,
    this.onDatabaseChange,
  });

  final Expense expense;
  final void Function() onDatabaseChange;

  @override
  _ExpenseDetailScreenState createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {

  final ExpenseService _expenseService = ExpenseService();
  Expense expense;

  @override
  void initState() {
    expense = widget.expense;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appBarTitleTheme = Theme.of(context).primaryTextTheme.title;
    var appBarIconSize = Theme.of(context).iconTheme.size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: expense.category.color,
        title: Row(
          children: <Widget>[
            Hero(
              tag: getHeroTag('icon'),
              child: Icon(
                expense.category.icon,
                size: appBarIconSize,
                color: appBarTitleTheme.color,
              ),
            ),
            Hero(
              tag: getHeroTag('title'),
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  expense.category.title,
                  style: appBarTitleTheme,
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (action) => _handleAction(context, action),
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return [Actions.edit, Actions.delete]
                  .map((action) => PopupMenuItem<String>(
                        child: Text(action),
                        value: action,
                      ))
                  .toList();
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchExpense,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Hero(
                  tag: getHeroTag('value'),
                  child: Material(
                      type: MaterialType.transparency,
                      child: Text(MoneyHelper.formatCash(expense.value)))),
            ),
            ListTile(
              leading: Hero(
                tag: getHeroTag('date_icon'),
                child: Material(
                    color: ListTileTheme.of(context).textColor,
                    type: MaterialType.transparency,
                    child: Icon(Icons.calendar_today)),
              ),
              title: Hero(
                tag: getHeroTag('date_text'),
                child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      DateFormat('E, dd/MM/y', 'pt_BR').format(expense.date),
                    )),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(expense.description),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 15.0,
              ),
              child: Wrap(
                runSpacing: 4,
                spacing: 4,
                children: expense.tags.map((tag) {
                  return Hero(
                    tag: getHeroTag('tag_${tag.id}'),
                    child: Material(
                        type: MaterialType.transparency, child: TagChip(tag)),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _fetchExpense() async {
    Expense newExpense = await _expenseService.getExpenseWithId(expense.id);
    setState(() {
      expense = newExpense.copy();
    });
  }

  void _handleAction(BuildContext context, String action) async {
    if (action == Actions.delete) {
      _expenseService.deleteExpenseWithId(expense.id);
      widget.onDatabaseChange();
      Navigator.pop(context);
    } else if (action == Actions.edit) {
      AppNavigator.pushNewExpenseScreen(
        context,
        onDispose: () {
          _fetchExpense();
          widget.onDatabaseChange();
        },
        closeOnSave: true,
        expense: expense.copy(),
      );
    }
  }

  String getHeroTag(String tag) {
    return "${expense.id}_$tag";
  }

}

class Actions {
  static const delete = "Deletar";
  static const edit = 'Editar';
}
