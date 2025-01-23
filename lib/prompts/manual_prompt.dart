import 'package:aquafusion/services/mqtt_service.dart';
import 'package:flutter/material.dart';
  import 'dart:convert'; // Import for JSON encoding

class ManualFeed extends StatefulWidget {

  const ManualFeed({Key? key}) : super(key: key);
  @override
  _ManualFeedState createState() => _ManualFeedState();
}

class _ManualFeedState extends State<ManualFeed> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Insert Feed Amount"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ABW Field
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Feed Amount",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please feed amount";
                }
                if (double.tryParse(value) == null) {
                  return "Enter a valid number";
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            // Stocking Density Field
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
              double abw = double.parse(_amountController.text);

              sendManual(abw);
              print("Amount: $abw");

              // Close the dialog
              Navigator.pop(context);
            }
          },
          child: Text("Submit"),
        ),
      ],
    );
  }

void sendManual(double abw) {
   final mqttClientWrapper = MQTTClientWrapper();
  
  mqttClientWrapper.publishMessage(
    'aquafusion/001/command/manual_feed',
    abw.toStringAsFixed(0),
    false, // retain: false
  );
}

}
