import 'dart:io';

import 'package:business/business.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ui/helpers/navigator.dart';
import 'package:file_picker/file_picker.dart';

import 'components/HomeScreenButton.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExpenseService _expenseService = ExpenseService();
  int totalValue = 0;

  @override
  void initState() {
    super.initState();
    _expenseService.getTotalValueFromMonth().then((value) {
      setState(() {
        totalValue = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Gerenciar Categorias"),
              onTap: () {
                Navigator.pop(context);
                AppNavigator.pushCategoriesScreen(context);
              },
            ),
            ListTile(
              title: Text("Gerenciar Tags"),
              onTap: () {
                Navigator.pop(context);
                AppNavigator.pushTagsScreen(context);
              },
            ),
            ListTile(
              title: Text("Rodar script SQL"),
              leading: Icon(Icons.adb),
              onTap: () {
                Navigator.pop(context);
                AppNavigator.pushBackupScreen(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppNavigator.pushNewExpenseScreen(context);
        },
        child: Icon(Icons.add),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 42.0),
            child: Text(
              "Total gasto esse mês $totalValue",
              textAlign: TextAlign.center,
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: <Widget>[
              HomeScreenButton(
                icon: Icons.add,
                onPress: () => AppNavigator.pushNewCategoryScreen(context),
                title: "Nova Categoria",
              ),
              HomeScreenButton(
                icon: Icons.history,
                title: "Histórico",
                onPress: () => AppNavigator.pushHistoryScreen(context),
              )
            ],
          ),
        ],
      ),
    );
  }
}
