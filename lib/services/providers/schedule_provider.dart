import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

class scheduleProvider with ChangeNotifier {
  String _schedule = '';
  final MQTTStreamService _mqttStreamService;

  scheduleProvider(this._mqttStreamService) {
    _mqttStreamService.scheduleStream.listen((schedule) {
      _schedule = schedule;
      notifyListeners(); // Notify UI to rebuild
    });
  }

  String get schedule => _schedule;

  void setschedule(String schedule) {
    _schedule = schedule;
    notifyListeners(); // Manually update if needed
  }
}
