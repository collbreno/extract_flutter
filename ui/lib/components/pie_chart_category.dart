import 'package:business/business.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class PieChartCategory extends StatelessWidget {
  final Map<Category, int> categories;

  const PieChartCategory({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Hero(
        tag: 'pie_chart_category_hero',
        child: PieChart(
          [getSeries()],
          animate: false,
        ),
      ),
    );
  }

  Series getSeries() {
    return Series(
      data: categories.entries.toList(),
      domainFn: (entry, _) => entry.key.title,
      measureFn: (entry, _) => entry.value,
      colorFn: (entry, _) => Color(r: entry.key.color.red, b: entry.key.color.blue, g: entry.key.color.green)
    );
  }

}
