/*
* Copyright 2021 HiveMQ GmbH
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*       http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

main() {
  MQTTClientWrapper newclient = MQTTClientWrapper();
  newclient.prepareMqttClient();
}

// connection states for easy identification
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

  late MqttClient client;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  // using async tasks, so the connection won't hinder the code flow
  Future<void> prepareMqttClient() async {
     try {
    _setupMqttClient();
    await _connectClient();
    _subscribeToTopic('aquafusion/001/#');
    _publishMessage('Hello, this is Flutter');
  } catch (e) {
    print('Error preparing MQTT client: $e');
  }
  }

  // waiting for the connection, if an error occurs, print it and disconnect
  Future<void> _connectClient() async {
    try {
      print('client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect('AquaFusion', 'Group2MQTT');
    } on Exception catch (e) {
      print('client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }

    // when connected, print a confirmation, else print an error
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('client connected');
    } else {
      print(
          'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    if (kIsWeb) {
      // Initialize MqttBrowserClient for web
      client = MqttBrowserClient.withPort(
        'wss://2577b26ceb134221a22d8d1d904f419e.s1.eu.hivemq.cloud/mqtt',
        'flutter_app',
        8884,
      );
      print('Setting up MqttBrowserClient for web');
    } else {
      // Initialize MqttServerClient for mobile/desktop
      client = MqttServerClient.withPort(
        '2577b26ceb134221a22d8d1d904f419e.s1.eu.hivemq.cloud',
        'flutter_app',
        8883,
      );
      (client as MqttServerClient).secure = true; // Enable TLS
      try {
        (client as MqttServerClient).securityContext = SecurityContext.defaultContext;
      } catch (e) {
        print('Error setting SecurityContext: $e');
      }
      print('Setting up MqttServerClient for mobile/desktop');
    }

    // Shared configuration for both clients
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void _subscribeToTopic(String topicName) {
    print('Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atMostOnce);

    // print the message when it is received
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      var message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print('YOU GOT A NEW MESSAGE:');
      print(message);
    });
  }

  void _publishMessage(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publishing message "$message" to topic ${'aquafusion/001/'}');
    client.publishMessage('aquafusion/001/', MqttQos.exactlyOnce, builder.payload!);
  }

  // callbacks for different events
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
    print('OnConnected client callback - Client connection was sucessful');
  }

}