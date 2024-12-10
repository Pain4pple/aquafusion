import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fl_chart/fl_chart.dart'; // Add fl_chart for line graph plotting

enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState {
  IDLE,
  SUBSCRIBED
}


class MQTTClientWrapper {
  static final MQTTClientWrapper _instance = MQTTClientWrapper._internal();
  late MqttClient client;

  // Add StreamControllers for specific topics
  final StreamController<String> _maintenanceController = StreamController<String>.broadcast();

  // Stream for storing historical data (for line graph plotting)
  final StreamController<List<FlSpot>> _trendController = StreamController<List<FlSpot>>.broadcast();

  Stream<List<FlSpot>> get trendStream => _trendController.stream;

  // Stream controllers for specific topics
  final StreamController<String> _feedLevelController = StreamController<String>.broadcast();
  final StreamController<String> _dfrController = StreamController<String>.broadcast();
  final StreamController<String> _scheduleController = StreamController<String>.broadcast();
  final StreamController<String> _blockageController = StreamController<String>.broadcast();
  final StreamController<String> _lowLevelController = StreamController<String>.broadcast();
  final StreamController<String> _pHController = StreamController<String>.broadcast();
  final StreamController<String> _temperatureController = StreamController<String>.broadcast();
  final StreamController<String> _oxygenController = StreamController<String>.broadcast();
  final StreamController<String> _turbidityController = StreamController<String>.broadcast();
  final StreamController<String> _salinityController = StreamController<String>.broadcast();

  // Getters for streams
  Stream<String> get maintenanceStream => _maintenanceController.stream;
  Stream<String> get feedLevel => _feedLevelController.stream;
  Stream<String> get dfrStream => _dfrController.stream;
  Stream<String> get scheduleStream => _scheduleController.stream;
  Stream<String> get blockageStream => _blockageController.stream;
  Stream<String> get lowLevelStream => _lowLevelController.stream;
  Stream<String> get pHStream => _pHController.stream;
  Stream<String> get temperatureStream => _temperatureController.stream;
  Stream<String> get oxygenStream => _oxygenController.stream;
  Stream<String> get turbidityStream => _turbidityController.stream;
  Stream<String> get salinityStream => _salinityController.stream;

  MQTTClientWrapper._internal();

  factory MQTTClientWrapper() {
    return _instance;
  }

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  bool _isInitialized = false;
  List<Map<String, dynamic>> _historicalData = []; // Store historical data for line graph

  Future<void> prepareMqttClient() async {
    if (_isInitialized && connectionState == MqttCurrentConnectionState.CONNECTED) {
      print("MQTT client already connected.");
      return;
    }
    try {
      _setupMqttClient();
      await _connectClient();
      _subscribeToTopic('aquafusion/001/sensor/water/pH');
      _subscribeToTopic('aquafusion/001/sensor/water/temp');
      _subscribeToTopic('aquafusion/001/sensor/water/DO');
      _subscribeToTopic('aquafusion/001/sensor/water/salinity');
      _subscribeToTopic('aquafusion/001/sensor/water/turbidity');
    } catch (e) {
      print('Error preparing MQTT client: $e');
    }
  }

  Future<void> _connectClient() async {
    try {
      print('Client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect('AquaFusion', 'Group2MQTT');
    } on Exception catch (e) {
      print('Client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('Client connected');
    } else {
      print('ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    if (kIsWeb) {
      client = MqttBrowserClient.withPort('wss://aquafusion-88ayr3.a02.usw2.aws.hivemq.cloud/mqtt', 'flutter_app', 8884);
    } else {
      client = MqttServerClient.withPort('aquafusion-88ayr3.a02.usw2.aws.hivemq.cloud', 'flutter_app', 8883);
      (client as MqttServerClient).secure = true;
    }

    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void _subscribeToTopic(String topicName) {
    print('Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      // For pH example, process and store the data
      if (c[0].topic == 'aquafusion/001/sensor/water/pH') {
        _processData('pH', message);
      }
      // You can process other data in a similar way...
    });
  }

  void _processData(String sensorType, String message) {
    final parsedData = _parseMessage(message);
    _historicalData.add(parsedData);

    // Only keep the latest 100 data points to avoid memory overflow
    if (_historicalData.length > 100) {
      _historicalData.removeAt(0);
    }

    // Convert the historical data to FlSpot format for the graph
    final spots = _historicalData.map((data) {
      return FlSpot(data['time'].millisecondsSinceEpoch.toDouble(), data['value']);
    }).toList();

    // Emit the data to the trendStream
    _trendController.add(spots);
  }

  Map<String, dynamic> _parseMessage(String message) {
    final parts = message.split(",");
    return {
      'time': DateTime.parse(parts[0]),
      'value': double.parse(parts[1]),
    };
  }

  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print('OnConnected client callback - Client connection was successful');
  }

  void close() {
    _feedLevelController.close();
    _pHController.close();
    _temperatureController.close();
    _trendController.close();
  }
}
