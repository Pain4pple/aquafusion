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
import 'package:provider/provider.dart';
import 'package:aquafusion/screens/home/components/gauges/pHGauge.dart';
import 'package:aquafusion/screens/home/components/linegraphs/pHLineGraph.dart';

class Water extends StatefulWidget {
  final String? species;

  Water({required this.species});

  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  @override
  void initState() {
    super.initState();
    final pHprovider = Provider.of<pHProvider>(context, listen: false);
    pHprovider.fetchOptimumParameters(widget.species);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f4ff),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Water Quality Readings",
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff202976))),
            const SizedBox(height: 25),

            // Wrap the Row with a Wrap widget for responsive design
            Wrap(
              spacing: 16.0, // Space between the children in the wrap
        
              runSpacing: 16.0, // Space between the rows
              children: [
                // pH
                Consumer<pHProvider>(builder: (context, pHProvider, child) {
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

                // Turbidity
                Consumer<turbidityProvider>(builder: (context, turbidityProvider, child) {
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

                // Salinity
                Consumer<salinityProvider>(builder: (context, salinityProvider, child) {
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

                // Dissolved Oxygen
                Consumer<oxygenProvider>(builder: (context, oxygenProvider, child) {
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

                // Temperature
                Consumer<tempProvider>(builder: (context, tempProvider, child) {
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildReadingCard(String parameterName, double value, double min, double max, Widget gauge) {
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
