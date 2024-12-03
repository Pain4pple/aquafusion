import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:aquafusion/services/mqtt_service.dart';

class MQTTStreamService {
  late StreamSubscription feedLevelSubscription;
  final _feedLevelController = StreamController<double>.broadcast();

  Stream<double> get feedLevelStream => _feedLevelController.stream;

  void startListening() {
    feedLevelSubscription = MQTTClientWrapper().feedLevel.listen((message) {
      double feedLevel = double.tryParse(message.toString()) ?? 0.0;
      _feedLevelController.sink.add(feedLevel); // Add to the stream
    });
  }

  void stopListening() {
    feedLevelSubscription.cancel();
    _feedLevelController.close();
  }
}
