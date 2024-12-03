import 'dart:convert'; // Import the dart:convert library for JSON encoding
import 'package:aquafusion/services/mqtt_service.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final mqttClient = MQTTClientWrapper();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Create the payload map with the necessary data
                Map<String, dynamic> payload = {
                  "uid": "some-unique-id",  // Replace with actual UID
                  "abw": 50.0,  // Replace with actual ABW
                  "survival_rate": 95.0,  // Replace with actual survival rate
                  "population_count": 1000,  // Replace with actual population count
                  "species": "Tilapia",  // Replace with actual species
                  "supplier": "TATEH",  // Replace with actual species
                  "lifestage": "Juvenile",  // Replace with actual lifestage
                  "phoneNumber": "+1234567890"  // Replace with actual phone number
                };

                // Convert the payload to a JSON string
                String jsonString = jsonEncode(payload);

                // Publish the message to the MQTT topic
                // mqttClient.publishMessageToWorld('aquafusion/001/command/calibrate_feeder', jsonString, false);
              },
              child: const Text("Pair with AquaFusion Device"),
            ),
          ],
        ),
      ),
    );
  }
}
