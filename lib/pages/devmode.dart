import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class DevMode extends StatefulWidget {
  @override
  _DevModeState createState() => _DevModeState();
}

class _DevModeState extends State<DevMode> {
  final TextEditingController _feedAmountController = TextEditingController();
  MqttServerClient? _client;
  String broker = 'aquafusion'; // e.g., 'test.mosquitto.org'
  String topic = 'aquafusion/manual_feed';

  @override
  void initState() {
    super.initState();
    _connectToMqtt();
  }

  Future<void> _connectToMqtt() async {
    _client = MqttServerClient(broker, '');
    _client!.port = 1883;
    _client!.logging(on: true);
    _client!.onDisconnected = _onDisconnected;
    _client!.onConnected = _onConnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_dev_mode')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    _client!.connectionMessage = connMessage;

    try {
      await _client!.connect();
    } catch (e) {
      print('MQTT Connection failed: $e');
    }
  }

  void _onConnected() {
    print('Connected to MQTT broker');
  }

  void _onDisconnected() {
    print('Disconnected from MQTT broker');
  }

  void _publishFeedAmount() {
    if (_client != null && _client!.connectionStatus!.state == MqttConnectionState.connected) {
      final String feedAmount = _feedAmountController.text;
      final builder = MqttClientPayloadBuilder();
      builder.addString(feedAmount);

      _client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);

      print('Published feed amount: $feedAmount');
    } else {
      print('MQTT client is not connected');
    }
  }
   void publishMessage(String message) {
    if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      _client!.publishMessage('led/control', MqttQos.exactlyOnce, builder.payload!);
      print('Message published: $message');
    } else {
      print('Cannot publish message, client is not connected.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => publishMessage('ON'),
              child: Text('Turn LED ON'),
            ),
            ElevatedButton(
              onPressed: () => publishMessage('OFF'),
              onLongPress: () => publishMessage('HEHEHHE'),
              child: Text('Turn LED OFF'),
            ),
          ],
        ),
      ),
    );
  }
}
