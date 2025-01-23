import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_service.dart';

class MQTTStreamService {
  // Subscriptions
  late StreamSubscription feedLevelSubscription;
  late StreamSubscription maintenanceSubscription;
  late StreamSubscription dfrSubscription;
  late StreamSubscription scheduleSubscription;
  late StreamSubscription blockageSubscription;
  late StreamSubscription lowLevelSubscription;
  late StreamSubscription pHSubscription;
  late StreamSubscription temperatureSubscription;
  late StreamSubscription oxygenSubscription;
  late StreamSubscription turbiditySubscription;
  late StreamSubscription salinitySubscription;
  late StreamSubscription overallWaterStatusSubscription;
  late StreamSubscription waterSubscription;
  late StreamSubscription docSubscription;
  late StreamSubscription abwSubscription;
  late StreamSubscription dividedfeedSubscription;

  // Controllers for each topic
  final _feedLevelController = StreamController<double>.broadcast();
  final _maintenanceController = StreamController<String>.broadcast();
  final _dfrController = StreamController<double>.broadcast();
  final _scheduleController = StreamController<String>.broadcast();
  final _blockageController = StreamController<String>.broadcast();
  final _lowLevelController = StreamController<String>.broadcast();
  final _pHController = StreamController<double>.broadcast();
  final _temperatureController = StreamController<double>.broadcast();
  final _oxygenController = StreamController<double>.broadcast();
  final _turbidityController = StreamController<double>.broadcast();
  final _salinityController = StreamController<double>.broadcast();
  final _trendController = StreamController<List<FlSpot>>.broadcast();
  final _waterStatusController = StreamController<String>.broadcast();
  final _overallWaterStatusController = StreamController<String>.broadcast();
  final _dividedFeedingController = StreamController<double>.broadcast();
  final _estimatedABWController = StreamController<double>.broadcast();
  final _estimatedDOCController = StreamController<int>.broadcast();

  // Getters for streams
  Stream<double> get feedLevelStream => _feedLevelController.stream;
  Stream<String> get maintenanceStream => _maintenanceController.stream;
  Stream<double> get dfrStream => _dfrController.stream;
  Stream<String> get scheduleStream => _scheduleController.stream;
  Stream<String> get blockageStream => _blockageController.stream;
  Stream<String> get lowLevelStream => _lowLevelController.stream;
  Stream<double> get pHStream => _pHController.stream;
  Stream<double> get tempStream => _temperatureController.stream;
  Stream<double> get oxygenStream => _oxygenController.stream;
  Stream<double> get turbidityStream => _turbidityController.stream;
  Stream<double> get salinityStream => _salinityController.stream;
  Stream<String> get waterStatusStream => _waterStatusController.stream;
  Stream<String> get overallWaterStatusStream => _overallWaterStatusController.stream;
  Stream<double> get estimatedABWStream => _estimatedABWController.stream;
  Stream<int> get docStream => _estimatedDOCController.stream;
  Stream<double> get feedAmountPerFeedingStream => _dividedFeedingController.stream;
  // Start listening to MQTT topics
  void startListening() {
    feedLevelSubscription = MQTTClientWrapper().feedLevel.listen((message) {
      double feedLevel = double.tryParse(message.toString()) ?? 0.0;
      _feedLevelController.sink.add(feedLevel); // Add to the stream
    });

    maintenanceSubscription = MQTTClientWrapper().maintenanceStream.listen((message) {
      String maintenanceMessage = message.toString();
      _maintenanceController.sink.add(maintenanceMessage); // Add to the stream
    });

    dfrSubscription = MQTTClientWrapper().dfrStream.listen((message) {
      double dfr = double.tryParse(message.toString()) ?? 0.0;
      _dfrController.sink.add(dfr); // Add to the stream
    });

    scheduleSubscription = MQTTClientWrapper().scheduleStream.listen((message) {
      String scheduleMessage = message.toString();
      _scheduleController.sink.add(scheduleMessage); // Add to the stream
    });

    blockageSubscription = MQTTClientWrapper().blockageStream.listen((message) {
      String blockageMessage = message.toString();
      _blockageController.sink.add(blockageMessage); // Add to the stream
    });

    lowLevelSubscription = MQTTClientWrapper().lowLevelStream.listen((message) {
      String lowLevelMessage = message.toString();
      _lowLevelController.sink.add(lowLevelMessage); // Add to the stream
    });

    pHSubscription = MQTTClientWrapper().pHStream.listen((message) {
      double pH = double.tryParse(message.toString()) ?? 0.0;
      _pHController.sink.add(pH); // Add to the stream
    });

    temperatureSubscription = MQTTClientWrapper().temperatureStream.listen((message) {
      double temp = double.tryParse(message.toString()) ?? 0.0;
      _temperatureController.sink.add(temp); // Add to the stream
    });

    oxygenSubscription = MQTTClientWrapper().oxygenStream.listen((message) {
      double oxygen = double.tryParse(message.toString()) ?? 0.0;
      _oxygenController.sink.add(oxygen); // Add to the stream
    });

    turbiditySubscription = MQTTClientWrapper().turbidityStream.listen((message) {
      double turbidity = double.tryParse(message.toString()) ?? 0.0;
      _turbidityController.sink.add(turbidity); // Add to the stream
    });

    salinitySubscription = MQTTClientWrapper().salinityStream.listen((message) {
      double salinity = double.tryParse(message.toString()) ?? 0.0;
      _salinityController.sink.add(salinity); // Add to the stream
    });

    waterSubscription = MQTTClientWrapper().waterStatusStream.listen((message) {
      _waterStatusController.sink.add(message.toString());
    });

    // Listen to overall_water_status topic
    overallWaterStatusSubscription = MQTTClientWrapper().overallWaterStatusStream.listen((message) {
      _overallWaterStatusController.sink.add(message.toString());
    });

    docSubscription = MQTTClientWrapper().docStream.listen((message) {
      double salinity = double.tryParse(message.toString()) ?? 0.0;
      _salinityController.sink.add(salinity); // Add to the stream
    });

    abwSubscription = MQTTClientWrapper().abwStream.listen((message) {
      _waterStatusController.sink.add(message.toString());
    });

    // Listen to overall_water_status topic
    dividedfeedSubscription = MQTTClientWrapper().feedAmountPerFeedingStream.listen((message) {
      _overallWaterStatusController.sink.add(message.toString());
    });
  }

  // Stop listening and clean up resources
  void stopListening() {
    feedLevelSubscription.cancel();
    maintenanceSubscription.cancel();
    dfrSubscription.cancel();
    scheduleSubscription.cancel();
    blockageSubscription.cancel();
    lowLevelSubscription.cancel();
    pHSubscription.cancel();
    temperatureSubscription.cancel();
    oxygenSubscription.cancel();
    turbiditySubscription.cancel();
    salinitySubscription.cancel();

    _feedLevelController.close();
    _maintenanceController.close();
    _dfrController.close();
    _scheduleController.close();
    _blockageController.close();
    _lowLevelController.close();
    _pHController.close();
    _temperatureController.close();
    _oxygenController.close();
    _turbidityController.close();
    _salinityController.close();
  }

  // Method to publish message to a topic
  void publishMessage(String topic, String message, bool retain) {
    MQTTClientWrapper().publishMessage(topic, message, retain);
  }
}

class FlSpot {
}
