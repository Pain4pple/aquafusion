import 'package:aquafusion/services/mqtt_service.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class DevMode extends StatefulWidget {
  const DevMode({super.key});

  @override
  _DevModeState createState() => _DevModeState();
}

class _DevModeState extends State<DevMode> {
  final TextEditingController _feedAmountController = TextEditingController();
  // final MQTTClientWrapper mqttClient = MQTTClientWrapper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
   
        ),
      ),
    );
  }
}
