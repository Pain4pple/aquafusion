import 'package:flutter/material.dart';

class InsertNewAbwPrompt extends StatefulWidget {
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
              // Perform the action with the entered values
              double abw = double.parse(_abwController.text);
              double stockingDensity = double.parse(_stockingDensityController.text);

              // Example action: Print to console
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
}
