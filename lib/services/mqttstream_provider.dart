import 'package:flutter/material.dart';
import 'mqtt_service.dart';

class MqttProvider with ChangeNotifier {
  // final MQTTService _mqttService = MQTTService();
  final MQTTClientWrapper _mqttService = MQTTClientWrapper();
  String _pHValue = '';
  String _feedLevelValue = '';
  String _temperatureValue = '';

  String get pHValue => _pHValue;
  String get temperatureValue => _temperatureValue;
  String get feedLevel => _feedLevelValue;

  MqttProvider() {
    // _mqttService.connect();
    _mqttService.prepareMqttClient();
    
    // Subscribe to individual streams
    _mqttService.feedLevel.listen((feedLevel) {
      _feedLevelValue = feedLevel;
      notifyListeners();
    });

    _mqttService.pHStream.listen((pH) {
      _pHValue = pH;
      notifyListeners();
    });

    _mqttService.temperatureStream.listen((temperature) {
      _temperatureValue = temperature;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _mqttService.client.disconnect();
    super.dispose();
  }
}
