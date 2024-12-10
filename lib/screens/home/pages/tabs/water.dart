import 'package:aquafusion/screens/home/components/gauges/turbidityGauge.dart';
import 'package:aquafusion/screens/home/components/gauges/oxygenGauge.dart';
import 'package:aquafusion/screens/home/components/gauges/salinityGauge.dart';
import 'package:aquafusion/screens/home/components/gauges/tempGauge.dart';
import 'package:aquafusion/services/providers/dO_provider.dart';
import 'package:aquafusion/services/providers/pH_provider.dart';
import 'package:aquafusion/services/providers/salinity_provider.dart';
import 'package:aquafusion/services/providers/temp_provider.dart';
import 'package:aquafusion/services/providers/turbidity_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:aquafusion/services/mqtt_service.dart';
import 'package:aquafusion/screens/home/components/gauges/pHGauge.dart';
import 'package:aquafusion/screens/home/components/linegraphs/pHLineGraph.dart';

class Water extends StatefulWidget {
  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize MQTT client
    final mqttWrapper = Provider.of<MQTTClientWrapper>(context, listen: false);
    mqttWrapper.prepareMqttClient(); // Prepare MQTT client
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Water Quality Trends"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.show_chart), text: "Line Graph"),
            Tab(icon: Icon(Icons.speed), text: "Gauges"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLineGraphTab(),
          _buildGaugesTab(),
        ],
      ),
    );
  }

  // Updated _buildLineGraphTab function
  Widget _buildLineGraphTab() {
    final mqttWrapper = Provider.of<MQTTClientWrapper>(context);

    return StreamBuilder<List<FlSpot>>(
      stream: mqttWrapper.trendStream, // Listen to the trendStream (List<FlSpot>)
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No data available."));
        }

        final data = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: data, // Use the FlSpot data from the stream
                  isCurved: true,
                  color: (Colors.blue),
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              borderData: FlBorderData(show: true),
              gridData: FlGridData(show: true),
            ),
          ),
        );
      },
    );
  }
  Widget _buildGaugesTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          PHGauge(pH: 7.2, optimumMin: 6.5, optimumMax: 9.0), // Example gauge
          // Add other gauges as needed
        ],
      ),
    );
  }
}