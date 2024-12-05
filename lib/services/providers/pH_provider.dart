import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

class pHProvider with ChangeNotifier {
  double _pH = 0.0;
  final MQTTStreamService _mqttStreamService;

  pHProvider(this._mqttStreamService) {
    _mqttStreamService.pHStream.listen((pH) {
      _pH = pH;
      notifyListeners(); // Notify UI to rebuild
    });
  }

  double get pH => _pH;

  void setpH(double pH) {
    _pH = pH;
    notifyListeners(); // Manually update if needed
  }
}
