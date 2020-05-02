import 'package:extract_flutter/screens/Home/components/HomeScreenButton.dart';
import 'package:extract_flutter/services/navigator.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            AppNavigator.pushNewExpenseScreen(context);
          },
          child: Icon(Icons.add),
        ),
        body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: GridView.count(
          crossAxisCount: 2,
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
      ),
      );
  }
}