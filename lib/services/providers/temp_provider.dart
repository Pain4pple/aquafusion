import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

class tempProvider with ChangeNotifier {
  double _temp = 0.0;
  final MQTTStreamService _mqttStreamService;

  tempProvider(this._mqttStreamService) {
    _mqttStreamService.tempStream.listen((temp) {
      _temp = temp;
      notifyListeners(); // Notify UI to rebuild
    });
  }

  double get temp => _temp;

  void settemp(double temp) {
    _temp = temp;
    notifyListeners(); // Manually update if needed
  }
}
