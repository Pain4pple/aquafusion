import 'package:aquafusion/services/mqtt_service.dart';
import 'package:flutter/material.dart';
  import 'dart:convert'; // Import for JSON encoding

class InsertNewAbwPrompt extends StatefulWidget {

  const InsertNewAbwPrompt({Key? key}) : super(key: key);
  @override
  _InsertNewAbwPromptState createState() => _InsertNewAbwPromptState();
}

class _InsertNewAbwPromptState extends State<InsertNewAbwPrompt> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _abwController = TextEditingController();
  final TextEditingController _stockingDensityController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Insert New ABW and Stocking Density"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ABW Field
            TextFormField(
              controller: _abwController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Average Body Weight (ABW)",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter ABW";
                }
                if (double.tryParse(value) == null) {
                  return "Enter a valid number";
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            // Stocking Density Field
            TextFormField(
              controller: _stockingDensityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Stocking Density",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter stocking density";
                }
                if (double.tryParse(value) == null) {
                  return "Enter a valid number";
                }
                return null;
              },
            ),
          ],
        ),
      ),
  actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Retrieve input values
              double abw = double.parse(_abwController.text);
              double stockingDensity = double.parse(_stockingDensityController.text);

              sendNewAbwDensity(abw,stockingDensity);
              print("ABW: $abw, Stocking Density: $stockingDensity");

              // Close the dialog
              Navigator.pop(context);
            }
          },
          child: Text("Submit"),
        ),
      ],
    );
  }

void sendNewAbwDensity(double abw, double density) {
   final mqttClientWrapper = MQTTClientWrapper();
  // Create the payload
  final payload = {
    'abw': abw,
    'population': density,
  };

  final jsonPayload = jsonEncode(payload);

  mqttClientWrapper.publishMessage(
    'aquafusion/001/command/new_abw_density',
    jsonPayload,
    false, // retain: false
  );

  print('Payload sent: $jsonPayload');
}

}
