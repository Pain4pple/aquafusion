import 'package:aquafusion/services/providers/dO_provider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';

class oxygenLineGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<oxygenProvider>(
      builder: (context, provider, child) {
        return SfCartesianChart(
          primaryXAxis: DateTimeAxis(),
          series: <LineSeries<ChartData, DateTime>>[
            LineSeries<ChartData, DateTime>(
              dataSource: provider.oxygenHistory,
              xValueMapper: (ChartData data, _) => data.time,
              yValueMapper: (ChartData data, _) => data.value,
            ),
          ],
        );
      },
    );
  }
}

class ChartData {
  final DateTime time;
  final double value;
  ChartData(this.time, this.value);
}
