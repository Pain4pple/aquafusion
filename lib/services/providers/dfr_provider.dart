import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

class dfrProvider with ChangeNotifier {
  double _dfr = 0.0;
  final MQTTStreamService _mqttStreamService;

  dfrProvider(this._mqttStreamService) {
    _mqttStreamService.dfrStream.listen((dfr) {
      _dfr = dfr;
      notifyListeners(); // Notify UI to rebuild
    });
  }

  double get dfr => _dfr;

  void setdfr(double dfr) {
    _dfr = dfr;
    notifyListeners(); // Manually update if needed
  }
}
