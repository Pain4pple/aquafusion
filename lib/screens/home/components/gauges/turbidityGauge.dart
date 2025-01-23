import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart'; // Import SfRadialGauge

class turbidityGauge extends StatelessWidget {
  final double parameter_value; // parameter_value value passed from the provider or Water widget
  final double optimumMin; // Minimum optimal parameter_value value
  final double optimumMax; // Maximum optimal parameter_value value

  turbidityGauge({required this.parameter_value, required this.optimumMin, required this.optimumMax});

  @override
  Widget build(BuildContext context) {
    // Determine the color based on parameter_value value
    Color fillColor;
    if (parameter_value < optimumMin) {
      fillColor = Colors.red; // parameter_value below optimum range
    } else if (parameter_value > optimumMax) {
      fillColor = Colors.orange; // parameter_value above optimum range
    } else {
      fillColor = Colors.green; // parameter_value within the optimum range
    }

    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          annotations: <GaugeAnnotation>[
              GaugeAnnotation(axisValue: 50, positionFactor: 0.4,
              widget: Text("$parameter_value NTU", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),))],
          axisLineStyle: const AxisLineStyle(
            thickness: 0.15,
            thicknessUnit: GaugeSizeUnit.factor,
            ),
          minimum: 0,
          maximum: 100, // parameter_value scale from 0 to 14
          startAngle: 180, endAngle: 0,
          canScaleToFit: true,
          pointers: <GaugePointer>[
            NeedlePointer(value: parameter_value,enableAnimation: true,), // parameter_value value dynamically passed
          ],
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: optimumMin,
              gradient: const SweepGradient(
                colors: <Color>[Color.fromARGB(255, 248, 39, 7), Color.fromARGB(255, 255, 216, 86)],
                stops: <double>[0.25, 0.75]),
            ),
            GaugeRange(
              startValue: optimumMin,
              endValue: optimumMax,
              gradient: const SweepGradient(
                colors: <Color>[Color.fromARGB(255, 41, 238, 126),Color.fromARGB(255, 87, 224, 74),Color.fromARGB(255, 41, 238, 126)],),
              
            ),
            GaugeRange(
              startValue: optimumMax,
              endValue: 100,
              gradient: const SweepGradient(
                colors: <Color>[Color.fromARGB(255, 255, 216, 86),Color.fromARGB(255, 248, 39, 7)],
                stops: <double>[0.25, 0.75]),
            ),
          ],

        ),
      ],
    );
  }
}
