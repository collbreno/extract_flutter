import 'dart:io';

import 'package:business/business.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui/components/category_with_value_list.dart';
import 'package:ui/components/pie_chart_category.dart';
import 'package:ui/helpers/money_helper.dart';
import 'package:ui/helpers/navigator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ui/screens/CategoryChart/category_chart_screen.dart';

import 'components/HomeScreenButton.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ExpenseService _expenseService;
  CategoryService _categoryService;
  PageController _cardPageController;

  int totalValue;
  Map<Category, int> categories;

  @override
  void initState() {
    _expenseService = ExpenseService();
    _categoryService = CategoryService();
    _cardPageController = PageController(
      initialPage: 0,
    );

    totalValue = 0;
    categories = {};
    super.initState();
    _fetchValue();
    _fetchCategories();
  }

  Future<void> _fetchValue() async {
    int result = await _expenseService.getTotalValueFromMonth();
    setState(() {
      totalValue = result ?? 0;
    });
  }

  Future<void> _fetchCategories() async {
    var result = await _categoryService.getCategoriesWithTotalValue();
    setState(() {
      categories = result;
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
            // ListTile(
            //   title: Text("Rodar script SQL"),
            //   leading: Icon(Icons.adb),
            //   onTap: () {
            //     Navigator.pop(context);
            //     AppNavigator.pushBackupScreen(context);
            //   },
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppNavigator.pushNewExpenseScreen(context);
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([_fetchValue(), _fetchCategories()]),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Total gasto esse mês:",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    MoneyHelper.formatCash(totalValue),
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
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
            Container(height: 50),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 50,
                maxHeight: 200,
              ),
              child: Card(
                child: InkWell(
                  onTap: () {
                    print('apertei');
                    AppNavigator.push(
                      context,
                      CategoryChartScreen(
                        categories: categories,
                      ),
                    );
                  },
                  child: PageView(
                    controller: _cardPageController,
                    children: <Widget>[
                      PieChartCategory(
                        categories: categories,
                      ),
                      CategoryWithValueList(
                        categories: categories,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
