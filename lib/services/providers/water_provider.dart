import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

class WaterProvider with ChangeNotifier {
  String _waterStatus = 'Normal'; // Initial water status
  String _overallWaterStatus = 'Good'; // Initial overall water status
  final MQTTStreamService _mqttStreamService;

  WaterProvider(this._mqttStreamService) {
    // Listen to MQTT water_status updates
    _mqttStreamService.waterStatusStream.listen((status) {
      print("Received water status: $status");
      _waterStatus = status;
      notifyListeners(); // Notify UI to rebuild
    });

    // Listen to MQTT overall_water_status updates
    _mqttStreamService.overallWaterStatusStream.listen((status) {
      print("Received overall water status: $status");
      _overallWaterStatus = status;
      notifyListeners(); // Notify UI to rebuild
    });
  }

  // Getters
  String get waterStatus => _waterStatus;
  String get overallWaterStatus => _overallWaterStatus;

  // Optional setters if manual updates are ever needed
  void setWaterStatus(String status) {
    _waterStatus = status;
    notifyListeners();
  }

  void setOverallWaterStatus(String status) {
    _overallWaterStatus = status;
    notifyListeners();
  }
}
