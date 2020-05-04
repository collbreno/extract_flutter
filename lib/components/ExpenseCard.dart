import 'package:extract_flutter/components/TagChip.dart';
import 'package:extract_flutter/models/Expense.dart';
import 'package:extract_flutter/services/navigator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  ExpenseCard(this._expense);
  final Expense _expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: (){
          AppNavigator.pushDetailTagScreen(context, _expense);
        },
        child: Column(
          children: <Widget>[
            Container(
              height: 42,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4),)
                ),
                color: _expense.category.color
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Hero(
                        tag: getHeroTag('icon'),
                        child: Material(type: MaterialType.transparency, child: Icon(_expense.category.icon, size: 18, color: getTextColor(),))
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Hero(
                          tag: getHeroTag('title'),
                          child: Material(type: MaterialType.transparency, child: Text(_expense.category.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: getTextColor()),))
                        ),
                      ),
                    ],
                  ),
                  Hero(
                    tag:getHeroTag('value'), 
                    child: Material(type: MaterialType.transparency, child: Text(formatCash(_expense.value), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: getTextColor()),))
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: <Widget>[
                  Hero(tag: getHeroTag('date_icon'), child: Material(type: MaterialType.transparency, child: Icon(Icons.calendar_today, size: 16,))),
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Hero(
                      tag: getHeroTag('date_text'), 
                      child: Material(type: MaterialType.transparency, child: Text(DateFormat('E, dd/MM/y', 'pt_BR').format(_expense.date), style: TextStyle(fontSize: 14),))
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 26,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _expense.tags.length,
                itemBuilder: (context, index){
                  var tag = _expense.tags.elementAt(index);
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Hero(
                      tag: getHeroTag('tag_${tag.id}'),
                      child: Material(type: MaterialType.transparency, child: TagChip(tag)),
                    ),
                  );
                },
              ),
            )
          ],
        )
      ),
    );
  }

  String getHeroTag(String tag){
    return "${_expense.id}_$tag";
  }

  Color getTextColor(){
    return _expense.category.color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
  
  String formatCash(int value){
    return "R\$ " + (value.toDouble()/100).toStringAsFixed(2);
  }
}