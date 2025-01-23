import 'package:aquafusion/screens/home/components/chart_data.dart';
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

class Water extends StatefulWidget {
  final String? species;  // Define species here

  Water({required this.species});

  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize MQTT client using provider
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final mqttWrapper = Provider.of<MQTTClientWrapper>(context, listen: false);
    //   mqttWrapper.prepareMqttClient(); // Prepare MQTT client
    // });
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
          _buildGaugesTab(),
          _buildLineGraphTab(),
        ],
      ),
    );
  }

    // Updated _buildLineGraphTab function
Widget _buildLineGraphTab() {
  return Consumer<pHProvider>( // Ensure the Consumer listens to each provider
    builder: (context, pHProvider, child) {
      return Consumer<turbidityProvider>(
        builder: (context, turbidityProvider, child) {
          return Consumer<oxygenProvider>(
            builder: (context, oxygenProvider, child) {
              return Consumer<tempProvider>(
                builder: (context, tempProvider, child) {
                  return Consumer<salinityProvider>(
                    builder: (context, salinityProvider, child) {
                      return StreamBuilder<List<FlSpot>>(
                        stream: _combineDataForGraph(
                          pHProvider.phHistory,
                          turbidityProvider.turbidityHistory,
                          oxygenProvider.oxygenHistory,
                          tempProvider.tempHistory,
                          salinityProvider.salinityHistory,
                        ),
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
                                    color: Colors.blue,
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
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}

// Combine all the data for the line graph
Stream<List<FlSpot>> _combineDataForGraph(
  List<ChartData> pHHistory,
  List<ChartData> turbidityHistory,
  List<ChartData> oxygenHistory,
  List<ChartData> tempHistory,
  List<ChartData> salinityHistory,
) async* {
  final combinedData = <FlSpot>[];

  // Ensure all lists have the same length or are truncated to the shortest one
  final minLength = [
    pHHistory.length,
    turbidityHistory.length,
    oxygenHistory.length,
    tempHistory.length,
    salinityHistory.length,
  ].reduce((value, element) => value < element ? value : element);

  // Combine the data based on the date and value
  for (int i = 0; i < minLength; i++) {
    // pH
    combinedData.add(
      FlSpot(
        pHHistory[i].date.millisecondsSinceEpoch.toDouble(), // X-axis based on date
        pHHistory[i].value, // Y-axis value for pH
      ),
    );

    // Turbidity
    combinedData.add(
      FlSpot(
        turbidityHistory[i].date.millisecondsSinceEpoch.toDouble(),
        turbidityHistory[i].value,
      ),
    );

    // Oxygen
    combinedData.add(
      FlSpot(
        oxygenHistory[i].date.millisecondsSinceEpoch.toDouble(),
        oxygenHistory[i].value,
      ),
    );

    // Temperature
    combinedData.add(
      FlSpot(
        tempHistory[i].date.millisecondsSinceEpoch.toDouble(),
        tempHistory[i].value,
      ),
    );

    // Salinity
    combinedData.add(
      FlSpot(
        salinityHistory[i].date.millisecondsSinceEpoch.toDouble(),
        salinityHistory[i].value,
      ),
    );
  }

  

  print("Combined data for graph: $combinedData"); // Debugging line

  yield combinedData;
}

  // Updated _buildGaugesTab function
  Widget _buildGaugesTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Wrap(
            spacing: 16.0, // Space between the children in the wrap
            runSpacing: 16.0, // Space between the rows
            children: [
              // pH
              Row(
                children: [
                  Expanded(
                    child: Consumer<pHProvider>(builder: (context, pHProvider, child) {
                      double pH = pHProvider.pH;
                      final optimumParam = pHProvider.optimumParameter;
                      double optimumMin = optimumParam?.optimumMin ?? 6.5;
                      double optimumMax = optimumParam?.optimumMax ?? 9.0;
                      return _buildReadingCard(
                        "pH",
                        pH,
                        optimumMin,
                        optimumMax,
                        PHGauge(
                          pH: pH,
                          optimumMin: optimumMin,
                          optimumMax: optimumMax,
                        ),
                      );
                    }),
                  ),
                  // Turbidity
                  Expanded(
                    child: Consumer<turbidityProvider>(builder: (context, turbidityProvider, child) {
                      double turbidity = turbidityProvider.turbidity;
                      final optimumParam = turbidityProvider.optimumParameter;
                      double optimumMin = optimumParam?.optimumMin ?? 0.0;
                      double optimumMax = optimumParam?.optimumMax ?? 25.0;
                      return _buildReadingCard(
                        "Turbidity (NTU)",
                        turbidity,
                        optimumMin,
                        optimumMax,
                        turbidityGauge(
                          parameter_value: turbidity,
                          optimumMin: optimumMin,
                          optimumMax: optimumMax,
                        ),
                      );
                    }),
                  ),
                  // Salinity
                  Expanded(
                    child: Consumer<salinityProvider>(builder: (context, salinityProvider, child) {
                      double salinity = salinityProvider.salinity;
                      final optimumParam = salinityProvider.optimumParameter;
                      double optimumMin = optimumParam?.optimumMin ?? 0.0;
                      double optimumMax = optimumParam?.optimumMax ?? 5.0;
                      return _buildReadingCard(
                        "Salinity (ppt)",
                        salinity,
                        optimumMin,
                        optimumMax,
                        salinityGauge(
                          parameter_value: salinity,
                          optimumMin: optimumMin,
                          optimumMax: optimumMax,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              // Dissolved Oxygen and Temperature
              Row(
                children: [
                  // Dissolved Oxygen
                  Expanded(
                    child: Consumer<oxygenProvider>(builder: (context, oxygenProvider, child) {
                      final optimumParam = oxygenProvider.optimumParameter;
                      double dissolvedOxygen = oxygenProvider.oxygen;
                      double optimumMin = optimumParam?.optimumMin ?? 5.0;
                      double optimumMax = optimumParam?.optimumMax ?? 10.0;
                      return _buildReadingCard(
                        "Dissolved Oxygen (ppm)",
                        dissolvedOxygen,
                        optimumMin,
                        optimumMax,
                        oxygenGauge(
                          parameter_value: dissolvedOxygen,
                          optimumMin: optimumMin,
                          optimumMax: optimumMax,
                        ),
                      );
                    }),
                  ),
                  // Temperature
                  Expanded(
                    child: Consumer<tempProvider>(builder: (context, tempProvider, child) {
                      double temperature = tempProvider.temp;
                      final optimumParam = tempProvider.optimumParameter;
                      double optimumMin = optimumParam?.optimumMin ?? 28.0;
                      double optimumMax = optimumParam?.optimumMax ?? 32.0;
                      return _buildReadingCard(
                        "Temperature (°C)",
                        temperature,
                        optimumMin,
                        optimumMax,
                        tempGauge(
                          parameter_value: temperature,
                          optimumMin: optimumMin,
                          optimumMax: optimumMax,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReadingCard(
      String parameterName, double value, double min, double max, Widget gauge) {
    return Card(
      color: Color(0xfffeffff),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(parameterName,
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff202976))),
            gauge,
          ],
        ),
      ),
    );
  }
}