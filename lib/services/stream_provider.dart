// import 'package:aquafusion/services/mqtt_setup.dart';
// import 'package:flutter/material.dart';

// class MqttStreamProvider with ChangeNotifier {
//   final MQTTClientWrapper mqttClient = MQTTClientWrapper();
  
//   late Stream<String> feedStream;
//   late Stream<String> feedAmountStream;
//   late Stream<String> scheduleStream;
//   late Stream<String> pHStream;
//   late Stream<String> turbidityStream;
//   late Stream<String> salinityStream;
//   late Stream<String> doStream;
//   late Stream<String> tempStream;

//   bool _isMqttInitialized = false;

//   bool get isMqttInitialized => _isMqttInitialized;
  
//   Future<void> initializeMqtt() async {
//     if (_isMqttInitialized) return;
//     // await mqttClient.prepareMqttClient();
//     if (mqttClient.connectionState == MqttCurrentConnectionState.CONNECTED) {
//       feedStream = mqttClient.newGetMessage('aquafusion/001/sensor/feeder/feed_level').map((event) {
//             print('Feed Level: $event'); // Debugging
//             return event;
//           });
//           feedAmountStream = mqttClient.newGetMessage('aquafusion/001/feeder/feed_amount').map((event) {
//             print('Feed Amount per Feeding: $event'); // Debugging
//             return event;
//           });
//           scheduleStream = mqttClient.newGetMessage('aquafusion/001/feeder/schedule').map((event) {
//             print('Feed Amount per Feeding: $event'); // Debugging
//             return event;
//           });
//           pHStream = mqttClient.newGetMessage('aquafusion/001/sensor/water/pH').map((event) {
//             print('Water pH: $event'); // Debugging
//             return event;
//           });
//           turbidityStream = mqttClient.newGetMessage('aquafusion/001/sensor/water/turbidity').map((event) {
//             print('Water Turbidity: $event'); // Debugging
//             return event;
//           });
//           salinityStream = mqttClient.newGetMessage('aquafusion/001/sensor/water/salinity').map((event) {
//             print('Water Salinity: $event'); // Debugging
//             return event;
//           });
//           doStream = mqttClient.newGetMessage('aquafusion/001/sensor/water/DO').map((event) {
//             print('Water Dissolved Oxygen: $event'); // Debugging
//             return event;
//           });
//           tempStream = mqttClient.newGetMessage('aquafusion/001/sensor/water/temp').map((event) {
//             print('Water Temperature: $event'); // Debugging
//             return event;
//           });
//       _isMqttInitialized = true;
//       notifyListeners();
//     } else {
//       debugPrint('MQTT not connected');
//     }
//   }

// }