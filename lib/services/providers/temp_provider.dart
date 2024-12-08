import 'package:aquafusion/models/optimum_parameters.dart';
import 'package:aquafusion/screens/home/components/linegraphs/tempLineGraph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

// Provider class to manage temp data and optimum range
class tempProvider with ChangeNotifier {
  double _temp = 0.0;
  List<ChartData> _tempHistory = [];
  OptimumParameter? _optimumParameter;
  final MQTTStreamService _mqttStreamService;

  tempProvider(this._mqttStreamService) {
    _mqttStreamService.tempStream.listen((temp) {
      _temp = temp;
      notifyListeners();
    });
  }

  double get temp => _temp;

  List<ChartData> get tempHistory => _tempHistory;

  OptimumParameter? get optimumParameter => _optimumParameter;

  void settemp(double temp) {
    _temp = temp;
    _tempHistory.add(ChartData(DateTime.now(), temp));
    if (_tempHistory.length > 50) {
      _tempHistory.removeAt(0); // Limit history size
    }
    notifyListeners();
  }

  // Fetch optimum temp parameter from Firestore
  Future<void> fetchOptimumParameters(String? species) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('species')
          .doc(species)
          .collection('water_parameters')
          .doc('temp')
          .get();
      if (docSnapshot.exists) {
        _optimumParameter = OptimumParameter.fromFirestore(docSnapshot);
        notifyListeners(); // Notify listeners when optimum data is fetched
      }
    } catch (e) {
      print('Error fetching optimum temp parameters: $e');
    }
  }
}