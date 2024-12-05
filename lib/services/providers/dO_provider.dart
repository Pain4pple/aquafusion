import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

class oxygenProvider with ChangeNotifier {
  double _oxygen = 0.0;
  final MQTTStreamService _mqttStreamService;

  oxygenProvider(this._mqttStreamService) {
    _mqttStreamService.oxygenStream.listen((oxygen) {
      _oxygen = oxygen;
      notifyListeners(); // Notify UI to rebuild
    });
  }

  double get oxygen => _oxygen;

  void setoxygen(double oxygen) {
    _oxygen = oxygen;
    notifyListeners(); // Manually update if needed
  }
}
