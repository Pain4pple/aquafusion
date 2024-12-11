import 'package:aquafusion/models/optimum_parameters.dart';
// import 'package:aquafusion/screens/home/components/linegraphs/oxygenLineGraph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service
import 'package:aquafusion/screens/home/components/chart_data.dart';
// Provider class to manage oxygen data and optimum range
class oxygenProvider with ChangeNotifier {
  double _oxygen = 0.0;
  List<ChartData> _oxygenHistory = [];
  OptimumParameter? _optimumParameter;
  final MQTTStreamService _mqttStreamService;

  oxygenProvider(this._mqttStreamService) {
    _mqttStreamService.oxygenStream.listen((oxygen) {
      _oxygen = oxygen;
      _oxygenHistory.add(ChartData(DateTime.now(), oxygen)); // Add new data to history
      if (_oxygenHistory.length > 50) _oxygenHistory.removeAt(0); // Limit history size
      print("Oxygen Data: $_oxygen"); // Debugging line to check data flow
      notifyListeners();
    });
  }

  double get oxygen => _oxygen;
  List<ChartData> get oxygenHistory => _oxygenHistory;

  OptimumParameter? get optimumParameter => _optimumParameter;

  void setoxygen(double oxygen) {
    _oxygen = oxygen;
    _oxygenHistory.add(ChartData(DateTime.now(), oxygen));
    if (_oxygenHistory.length > 50) {
      _oxygenHistory.removeAt(0); // Limit history size
    }
    notifyListeners();
  }

  // Fetch optimum oxygen parameter from Firestore
  Future<void> fetchOptimumParameters(String? species) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('species')
          .doc(species)
          .collection('water_parameters')
          .doc('oxygen')
          .get();
      if (docSnapshot.exists) {
        _optimumParameter = OptimumParameter.fromFirestore(docSnapshot);
        notifyListeners(); // Notify listeners when optimum data is fetched
      }
    } catch (e) {
      print('Error fetching optimum oxygen parameters: $e');
    }
  }
}