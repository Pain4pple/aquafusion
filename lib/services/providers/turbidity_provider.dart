import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

class turbidityProvider with ChangeNotifier {
  double _turbidity = 0.0;
  final MQTTStreamService _mqttStreamService;

  turbidityProvider(this._mqttStreamService) {
    _mqttStreamService.turbidityStream.listen((turbidity) {
      _turbidity = turbidity;
      notifyListeners(); // Notify UI to rebuild
    });
  }

  double get turbidity => _turbidity;

  void setturbidity(double turbidity) {
    _turbidity = turbidity;
    notifyListeners(); // Manually update if needed
  }
}
