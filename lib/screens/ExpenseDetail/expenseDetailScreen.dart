import 'package:extract_flutter/components/TagChip.dart';
import 'package:extract_flutter/models/Expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseDetailScreen extends StatelessWidget {
  ExpenseDetailScreen(this._expense);
  final Expense _expense;


  @override
  Widget build(BuildContext context) {
    var appBarTitleTheme = Theme.of(context).primaryTextTheme.title;
    var appBarIconSize = Theme.of(context).iconTheme.size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _expense.category.color,
        title: Row(
          children: <Widget>[
            Hero(tag: getHeroTag('icon'), child: Icon(_expense.category.icon, size: appBarIconSize, color: appBarTitleTheme.color,),),
            Hero(
              tag: getHeroTag('title'), 
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(_expense.category.title, style: appBarTitleTheme,),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Hero(tag: getHeroTag('value'), child: Material(type: MaterialType.transparency, child: Text(formatCash(_expense.value)))),
            ),
            ListTile(
              leading: Hero(tag: getHeroTag('date_icon'), child: Material(color: ListTileTheme.of(context).textColor, type: MaterialType.transparency, child: Icon(Icons.calendar_today )),),
              title: Hero(tag:getHeroTag('date_text'), child: Material(type: MaterialType.transparency, child: Text(DateFormat('E, dd/MM/y', 'pt_BR').format(_expense.date),)),),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(_expense.description),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Wrap(
                runSpacing: 4,
                spacing: 4,
                children: _expense.tags.map((tag){
                  return Hero(
                    tag: getHeroTag('tag_${tag.id}'),
                    child: Material(type: MaterialType.transparency, child: TagChip(tag)),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getHeroTag(String tag){
    return "${_expense.id}_$tag";
  }

  String formatCash(int value){
    return "R\$ " + (value.toDouble()/100).toStringAsFixed(2);
  }
}