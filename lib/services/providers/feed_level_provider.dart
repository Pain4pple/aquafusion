import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

class FeedLevelProvider with ChangeNotifier {
  double _feedLevel = 0.0;
  final MQTTStreamService _mqttStreamService;

  FeedLevelProvider(this._mqttStreamService) {
    _mqttStreamService.feedLevelStream.listen((feedLevel) {
      _feedLevel = feedLevel;
      notifyListeners(); // Notify UI to rebuild
    });
  }

  double get feedLevel => _feedLevel;

  void setFeedLevel(double feedLevel) {
    _feedLevel = feedLevel;
    notifyListeners(); // Manually update if needed
  }
}
