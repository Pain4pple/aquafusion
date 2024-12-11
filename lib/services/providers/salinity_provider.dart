import 'package:aquafusion/models/optimum_parameters.dart';
// import 'package:aquafusion/screens/home/components/linegraphs/salinityLineGraph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service
import 'package:aquafusion/screens/home/components/chart_data.dart';
// Provider class to manage salinity data and optimum range
class salinityProvider with ChangeNotifier {
  double _salinity = 0.0;
  List<ChartData> _salinityHistory = [];
  OptimumParameter? _optimumParameter;
  final MQTTStreamService _mqttStreamService;

  salinityProvider(this._mqttStreamService) {
    _mqttStreamService.salinityStream.listen((salinity) {
      _salinity = salinity;
      _salinityHistory.add(ChartData(DateTime.now(), salinity)); // Add new data to history
      if (_salinityHistory.length > 50) _salinityHistory.removeAt(0); // Limit history size
      print("Salinity Data: $_salinity"); // Debugging line to check data flow
      notifyListeners();
    });
  }

  double get salinity => _salinity;
  List<ChartData> get salinityHistory => _salinityHistory;
  
  OptimumParameter? get optimumParameter => _optimumParameter;

  void setsalinity(double salinity) {
    _salinity = salinity;
    _salinityHistory.add(ChartData(DateTime.now(), salinity));
    if (_salinityHistory.length > 50) {
      _salinityHistory.removeAt(0); // Limit history size
    }
    notifyListeners();
  }

  // Fetch optimum salinity parameter from Firestore
  Future<void> fetchOptimumParameters(String? species) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('species')
          .doc(species)
          .collection('water_parameters')
          .doc('salinity')
          .get();
      if (docSnapshot.exists) {
        _optimumParameter = OptimumParameter.fromFirestore(docSnapshot);
        notifyListeners(); // Notify listeners when optimum data is fetched
      }
    } catch (e) {
      print('Error fetching optimum salinity parameters: $e');
    }
  }
}