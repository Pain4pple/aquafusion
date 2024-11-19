import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';

class Water extends StatefulWidget {
  const Water({Key? key}) : super(key: key);

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  // Simulated data (replace with database integration)
  double ph = 8.5;
  double turbidity = 30.0;
  double salinity = 0.1;
  double dissolvedOxygen = 5.0;
  double temperature = 24.0;

  List<FlSpot> phData = [FlSpot(0, 8.2), FlSpot(1, 8.4), FlSpot(2, 8.5)];
  List<FlSpot> turbidityData = [FlSpot(0, 28), FlSpot(1, 29), FlSpot(2, 30)];
  List<FlSpot> salinityData = [FlSpot(0, 0.1), FlSpot(1, 0.12), FlSpot(2, 0.1)];
  List<FlSpot> dissolvedOxygenData = [FlSpot(0, 4.8), FlSpot(1, 5.0), FlSpot(2, 5.1)];
  List<FlSpot> temperatureData = [FlSpot(0, 23.5), FlSpot(1, 24), FlSpot(2, 24.2)];

  Timer? _dataUpdateTimer;

  // Fetch data from the database
  Future<void> fetchData() async {
    // Simulate a delay for fetching data
    await Future.delayed(const Duration(seconds: 1));

    // Uncomment and replace with real database calls
    /*
    final fetchedData = await fetchWaterQualityDataFromDatabase();
    setState(() {
      ph = fetchedData['ph'];
      turbidity = fetchedData['turbidity'];
      salinity = fetchedData['salinity'];
      dissolvedOxygen = fetchedData['dissolvedOxygen'];
      temperature = fetchedData['temperature'];

      // Add new data points to the respective lists
      phData.add(FlSpot(phData.length.toDouble(), ph));
      turbidityData.add(FlSpot(turbidityData.length.toDouble(), turbidity));
      salinityData.add(FlSpot(salinityData.length.toDouble(), salinity));
      dissolvedOxygenData.add(FlSpot(dissolvedOxygenData.length.toDouble(), dissolvedOxygen));
      temperatureData.add(FlSpot(temperatureData.length.toDouble(), temperature));
    });
    */

    // Simulated updates for testing
    setState(() {
      ph = 8.3 + (0.2 - 0.4 * (DateTime.now().second % 2)); // Random variation
      turbidity = 28.0 + (1.0 * (DateTime.now().second % 2));
      salinity = 0.1 + (0.02 * (DateTime.now().second % 2));
      dissolvedOxygen = 5.0 + (0.1 * (DateTime.now().second % 2));
      temperature = 24.0 + (0.2 * (DateTime.now().second % 2));

      // Add new data points
      phData.add(FlSpot(phData.length.toDouble(), ph));
      turbidityData.add(FlSpot(turbidityData.length.toDouble(), turbidity));
      salinityData.add(FlSpot(salinityData.length.toDouble(), salinity));
      dissolvedOxygenData.add(FlSpot(dissolvedOxygenData.length.toDouble(), dissolvedOxygen));
      temperatureData.add(FlSpot(temperatureData.length.toDouble(), temperature));

      // Keep only the last 20 data points to avoid overcrowding
      if (phData.length > 20) phData.removeAt(0);
      if (turbidityData.length > 20) turbidityData.removeAt(0);
      if (salinityData.length > 20) salinityData.removeAt(0);
      if (dissolvedOxygenData.length > 20) dissolvedOxygenData.removeAt(0);
      if (temperatureData.length > 20) temperatureData.removeAt(0);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch initial data
    // Schedule updates every 5 minutes
    _dataUpdateTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    _dataUpdateTimer?.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Reduced padding for closer layout
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Trend Section (Combined Line Graph)
              Text(
                "Overall Trends",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildCombinedLineGraph(),

              // Water Quality Metrics
              _buildMetricSection("pH", ph, phData, Colors.red, 0, 14),
              _buildMetricSection("Turbidity (NTU)", turbidity, turbidityData, Colors.orange, 0, 100),
              _buildMetricSection("Salinity (ppt)", salinity, salinityData, Colors.purple, 0, 10),
              _buildMetricSection("Dissolved Oxygen (mg/L)", dissolvedOxygen, dissolvedOxygenData, Colors.green, 0, 15),
              _buildMetricSection("Temperature (°C)", temperature, temperatureData, Colors.blue, 0, 40),
            ],
          ),
        ),
      ),
    );
  }

  // Build the combined line graph for overall trends
  Widget _buildCombinedLineGraph() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: phData,
              isCurved: true, // Set to true for curved lines
              color: Colors.red,
              barWidth: 2,
            ),
            LineChartBarData(
              spots: turbidityData,
              isCurved: true, // Set to true for curved lines
              color: Colors.orange,
              barWidth: 2,
            ),
            LineChartBarData(
              spots: salinityData,
              isCurved: true, // Set to true for curved lines
              color: Colors.purple,
              barWidth: 2,
            ),
            LineChartBarData(
              spots: dissolvedOxygenData,
              isCurved: true, // Set to true for curved lines
              color: Colors.green,
              barWidth: 2,
            ),
            LineChartBarData(
              spots: temperatureData,
              isCurved: true, // Set to true for curved lines
              color: Colors.blue,
              barWidth: 2,
            ),
          ],
        ),
      ),
    );
  }

  // Build a single metric section with gauge and line graph
  Widget _buildMetricSection(String title, double value, List<FlSpot> data, Color color, double min, double max) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  SfRadialGauge(
                    axes: [
                      RadialAxis(
                        minimum: min,
                        maximum: max,
                        ranges: [
                          GaugeRange(startValue: min, endValue: (max - min) / 3, color: Colors.red),
                          GaugeRange(startValue: (max - min) / 3, endValue: (2 * (max - min)) / 3, color: Colors.yellow),
                          GaugeRange(startValue: (2 * (max - min)) / 3, endValue: max, color: Colors.green),
                        ],
                        pointers: [NeedlePointer(value: value)],
                      ),
                    ],
                  ),
                  Text(
                    value.toStringAsFixed(2), // Display value under the gauge
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 150,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: data,
                        isCurved: true, // Curved lines for the metric's trend
                        color: color,
                        barWidth: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
