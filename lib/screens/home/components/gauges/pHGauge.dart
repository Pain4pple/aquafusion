import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart'; // Import SfRadialGauge

class PHGauge extends StatelessWidget {
  final double pH; // pH value passed from the provider or Water widget
  final double optimumMin; // Minimum optimal pH value
  final double optimumMax; // Maximum optimal pH value

  PHGauge({required this.pH, required this.optimumMin, required this.optimumMax});

  @override
  Widget build(BuildContext context) {
    // Determine the color based on pH value
    Color fillColor;
    if (pH < optimumMin) {
      fillColor = Colors.red; // pH below optimum range
    } else if (pH > optimumMax) {
      fillColor = Colors.orange; // pH above optimum range
    } else {
      fillColor = Colors.green; // pH within the optimum range
    }

    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          annotations: <GaugeAnnotation>[
              GaugeAnnotation(axisValue: 7, positionFactor: 0.4,
              widget: Text("$pH", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),))],
          axisLineStyle: const AxisLineStyle(
            thickness: 0.15,
            thicknessUnit: GaugeSizeUnit.factor,
            ),
          minimum: 0,
          maximum: 14, // pH scale from 0 to 14
          startAngle: 180, endAngle: 0,
          canScaleToFit: true,
          pointers: <GaugePointer>[
            NeedlePointer(value: pH,enableAnimation: true,), // pH value dynamically passed
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
              endValue: 14,
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
