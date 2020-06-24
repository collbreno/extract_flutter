import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/components/category_with_value_list.dart';
import 'package:ui/components/pie_chart_category.dart';

class CategoryChartScreen extends StatefulWidget {
  final Map<Category, int> categories;

  const CategoryChartScreen({Key key, this.categories}) : super(key: key);
  @override
  _CategoryChartScreenState createState() => _CategoryChartScreenState();
}

class _CategoryChartScreenState extends State<CategoryChartScreen> {


  CategoryService _categoryService;
  Map<Category, int> categories;

  @override
  void initState() {
    _categoryService = CategoryService();
    categories = widget.categories ?? {};
    _fetchCategories();
    super.initState();
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
        title: Text("Resumo"),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchCategories,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          children: <Widget>[
            Container(
              height: 300,
              child: PieChartCategory(categories: categories,),
            ),
            Material(
              child: CategoryWithValueList(
                categories: categories,
                primary: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
