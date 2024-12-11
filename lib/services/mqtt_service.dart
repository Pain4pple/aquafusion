import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  Future<void> prepareMqttClient() async {
    if (_isInitialized && connectionState == MqttCurrentConnectionState.CONNECTED) {
      print("MQTT client already connected.");
      return;
    }
    try {
      _setupMqttClient();
      await _connectClient();
      // _subscribeToTopic('aquafusion/001/#');  // Subscribe to a general topic
      _subscribeToTopic('aquafusion/001/maintenance');  

      _subscribeToTopic('aquafusion/001/sensor/feeder/feed_level');  
      _subscribeToTopic('aquafusion/001/sensor/feeder/low_level');  
      _subscribeToTopic('aquafusion/001/sensor/feeder/blockage');  
      _subscribeToTopic('aquafusion/001/feeder/feed_amount');  
      _subscribeToTopic('aquafusion/001/feeder/schedule');  

      _subscribeToTopic('aquafusion/001/sensor/water/pH'); 
      _subscribeToTopic('aquafusion/001/sensor/water/temp');  
      _subscribeToTopic('aquafusion/001/sensor/water/DO');
      _subscribeToTopic('aquafusion/001/sensor/water/salinity');
      _subscribeToTopic('aquafusion/001/sensor/water/turbidity');

      _publishMessage('aquafusion/001/test', 'Hello, this is Flutter', false);
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
      print('Setting up MqttBrowserClient for web');
    } else {
      client = MqttServerClient.withPort('aquafusion-88ayr3.a02.usw2.aws.hivemq.cloud', 'flutter_app', 8883);
      (client as MqttServerClient).secure = true;
      try {
        (client as MqttServerClient).securityContext = SecurityContext.defaultContext;
      } catch (e) {
        print('Error setting SecurityContext: $e');
      }
      print('Setting up MqttServerClient for mobile/desktop');
    }

    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  // void _subscribeToTopic(String topicName) {
  //   print('Subscribing to the $topicName topic');
  //   client.subscribe(topicName, MqttQos.atMostOnce);
  //   client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
  //     final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
  //     var message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

  //     print('YOU GOT A NEW MESSAGE:');
  //     print(message);

  //     // Dispatch message to the correct stream based on topic
  //     if (c[0].topic == 'aquafusion/001/sensor/water/pH') {
  //       _pHController.add(message);
  //     } else if (c[0].topic == 'aquafusion/001/sensor/water/temp') {
  //       _temperatureController.add(message);
  //     } else if (c[0].topic == 'aquafusion/001/sensor/feeder/feed_level') {
  //       _feedLevelController.add(message);
  //     }
  //   });
  // }

  void _subscribeToTopic(String topicName) {
    print('Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atLeastOnce);

    // Define a map of topics to their respective controllers
    final topicControllerMap = {
      'aquafusion/001/sensor/water/pH': _pHController,
      'aquafusion/001/sensor/water/temp': _temperatureController,
      'aquafusion/001/sensor/water/DO': _oxygenController,
      'aquafusion/001/sensor/water/turbidity': _turbidityController,
      'aquafusion/001/sensor/water/salinity': _salinityController,
      'aquafusion/001/sensor/feeder/feed_level': _feedLevelController,
      'aquafusion/001/sensor/feeder/low_level': _lowLevelController,
      'aquafusion/001/sensor/feeder/blockage': _blockageController,
      'aquafusion/001/feeder/feed_amount': _dfrController,
      'aquafusion/001/feeder/schedule': _scheduleController,
      'aquafusion/001/maintenance': _maintenanceController,
    };

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final topic = c[0].topic;

      print('Received message: "$message" from topic: "$topic"');

      // Dispatch message to the appropriate controller if the topic exists in the map
      if (topicControllerMap.containsKey(topic)) {
        topicControllerMap[topic]?.add(message);
      } else {
        print('No controller found for topic: $topic');
      }
    });
}

  Stream<String> getMessages(String topic) async* {
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      await _connectClient();
    }

    client.subscribe(topic, MqttQos.atMostOnce);

    await for (var message in client.updates!) {
      final MqttReceivedMessage<MqttMessage> mqttMessage = message[0];
      final MqttPublishMessage recMess = mqttMessage.payload as MqttPublishMessage;
      var payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      if (mqttMessage.topic == topic) {
        yield payload;
      }
    }
  }

  void publishMessage(String topic, String message, bool retain) {
    _publishMessage(topic, message, retain);
  }
  
  void _publishMessage(String topic, String message, bool retainBool) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publishing message "$message" to topic $topic');
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!, retain: retainBool);
  }

    void publishMessage(String topic, String message, bool retain) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publishing message "$message" to topic $topic');
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!, retain: retain);
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
  }
}
