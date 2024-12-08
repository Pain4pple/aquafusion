import 'package:aquafusion/models/optimum_parameters.dart';
import 'package:aquafusion/screens/home/components/linegraphs/pHLineGraph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

// Provider class to manage pH data and optimum range
class pHProvider with ChangeNotifier {
  double _pH = 0.0;
  List<ChartData> _phHistory = [];
  OptimumParameter? _optimumParameter;
  final MQTTStreamService _mqttStreamService;

  pHProvider(this._mqttStreamService) {
    _mqttStreamService.pHStream.listen((pH) {
      _pH = pH;
      notifyListeners();
    });
  }

  double get pH => _pH;

  List<ChartData> get phHistory => _phHistory;

  OptimumParameter? get optimumParameter => _optimumParameter;

  void setpH(double pH) {
    _pH = pH;
    _phHistory.add(ChartData(DateTime.now(), pH));
    if (_phHistory.length > 50) {
      _phHistory.removeAt(0); // Limit history size
    }
    notifyListeners();
  }

  // Fetch optimum pH parameter from Firestore
  Future<void> fetchOptimumParameters(String? species) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('species')
          .doc(species)
          .collection('water_parameters')
          .doc('pH')
          .get();
      if (docSnapshot.exists) {
        _optimumParameter = OptimumParameter.fromFirestore(docSnapshot);
        notifyListeners(); // Notify listeners when optimum data is fetched
      }
    } catch (e) {
      print('Error fetching optimum pH parameters: $e');
    }
  }
}