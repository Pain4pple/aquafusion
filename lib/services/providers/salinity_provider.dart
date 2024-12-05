import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

class salinityProvider with ChangeNotifier {
  double _salinity = 0.0;
  final MQTTStreamService _mqttStreamService;

  salinityProvider(this._mqttStreamService) {
    _mqttStreamService.salinityStream.listen((salinity) {
      _salinity = salinity;
      notifyListeners(); // Notify UI to rebuild
    });
  }

  double get salinity => _salinity;

  void setsalinity(double salinity) {
    _salinity = salinity;
    notifyListeners(); // Manually update if needed
  }
}
