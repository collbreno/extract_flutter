import 'package:extract_flutter/models/Category.dart';
import 'package:extract_flutter/models/Tag.dart';
import 'package:extract_flutter/services/database/tables/ExpenseTable.dart';
import 'package:extract_flutter/services/database/tables/ExpenseTagsTable.dart';

class Expense {
  int _id;
  int _value;
  String _description;
  DateTime _date;
  Category _category;
  List<Tag> _tags;

  Expense(this._value, this._date, this._description, this._category, this._tags);
  Expense.withId(this._id, this._value, this._date, this._description, this._category, this._tags);
  Expense.fromObject(dynamic o){
    _id = o[ExpenseTable.colCategoryId];
    _value = o[ExpenseTable.colValue];
    _description = o[ExpenseTable.colDescription];
    _date = DateTime.parse(o[ExpenseTable.colDate]);
    _tags = List<Tag>();
  }

  Expense.fromObjectWithCategory(dynamic o){
    _id = o[ExpenseTable.colId];
    _value = o[ExpenseTable.colValue];
    _description = o[ExpenseTable.colDescription];
    _date = DateTime.parse(o[ExpenseTable.colDate]);
    _category = Category.fromObject(o);
    _tags = List<Tag>();
  }

  int get id => _id;
  int get value => _value;
  String get description => _description;
  DateTime get date => _date;
  Category get category => _category;
  List<Tag> get tags => _tags;

  set id(int newId) {
    if (newId > 0) _id = newId;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String, dynamic>();
    map[ExpenseTable.colValue] = _value;
    map[ExpenseTable.colDescription] = _description;
    map[ExpenseTable.colDate] = _date.toIso8601String();
    map[ExpenseTable.colCategoryId] = _category.id;
    if (_id != null){
      map[ExpenseTable.colId] = _id;
    }
    return map;
  }

  List<int> getTagIds(){
    return _tags.map((tag) => tag.id).toList();
  }

  List<Map<String,int>> getMapWithTagIds(){
    return _tags.map((tag){
      var map = Map<String, int>();
      map[ExpenseTagsTable.colExpenseId] = _id;
      map[ExpenseTagsTable.colTagId] = tag.id;
      return map;
    }).toList();
  }

}