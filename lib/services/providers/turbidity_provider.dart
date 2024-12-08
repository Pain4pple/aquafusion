import 'package:aquafusion/models/optimum_parameters.dart';
import 'package:aquafusion/screens/home/components/linegraphs/turbidityLineGraph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

// Provider class to manage turbidity data and optimum range
class turbidityProvider with ChangeNotifier {
  double _turbidity = 0.0;
  List<ChartData> _turbidityHistory = [];
  OptimumParameter? _optimumParameter;
  final MQTTStreamService _mqttStreamService;

  turbidityProvider(this._mqttStreamService) {
    _mqttStreamService.turbidityStream.listen((turbidity) {
      _turbidity = turbidity;
      notifyListeners();
    });
  }

  double get turbidity => _turbidity;

  List<ChartData> get turbidityHistory => _turbidityHistory;

  OptimumParameter? get optimumParameter => _optimumParameter;

  void setturbidity(double turbidity) {
    _turbidity = turbidity;
    _turbidityHistory.add(ChartData(DateTime.now(), turbidity));
    if (_turbidityHistory.length > 50) {
      _turbidityHistory.removeAt(0); // Limit history size
    }
    notifyListeners();
  }

  // Fetch optimum turbidity parameter from Firestore
  Future<void> fetchOptimumParameters(String? species) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('species')
          .doc(species)
          .collection('water_parameters')
          .doc('turbidity')
          .get();
      if (docSnapshot.exists) {
        _optimumParameter = OptimumParameter.fromFirestore(docSnapshot);
        notifyListeners(); // Notify listeners when optimum data is fetched
      }
    } catch (e) {
      print('Error fetching optimum turbidity parameters: $e');
    }
  }
}