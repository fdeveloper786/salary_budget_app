import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salary_budget/Presentation/Widgets/chart/pie_chart_data.dart';

class PieChartContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(PieChartData(
        sections: pieChartSectionData
    ));
  }
}