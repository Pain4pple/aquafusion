import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(All());
}

class All extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FeederControlPage(),
    );
  }
}

class FeederControlPage extends StatefulWidget {
  @override
  _FeederControlPageState createState() => _FeederControlPageState();
}

class _FeederControlPageState extends State<FeederControlPage> {
  double currentDfr = 0.0; // Displayed DFR
  String statusMessage = "";

  // Fetch the current DFR from the Raspberry Pi
  Future<void> fetchCurrentDfr() async {
    try {
      final response = await http.get(Uri.parse('http://<raspberry-pi-ip>:5000/get-dfr'));

      if (response.statusCode == 200) {
        setState(() {
          currentDfr = double.parse(response.body); // Parse the DFR value
        });
      } else {
        setState(() {
          statusMessage = "Failed to fetch DFR. Error code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "Error fetching DFR: $e";
      });
    }
  }

  // Send adjustment commands to the Raspberry Pi
  Future<void> adjustDfr(String adjustmentType) async {
    try {
      final response = await http.post(
        Uri.parse('http://<raspberry-pi-ip>:5000/adjust-dfr'),
        headers: {'Content-Type': 'application/json'},
        body: '{"adjustment": "$adjustmentType"}',
      );

      if (response.statusCode == 200) {
        setState(() {
          statusMessage = "DFR updated successfully!";
          currentDfr = double.parse(response.body); // Update displayed DFR
        });
      } else {
        setState(() {
          statusMessage = "Failed to update DFR. Error code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "Error updating DFR: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentDfr(); // Fetch the DFR when the app loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feeder Control'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current DFR: ${currentDfr.toStringAsFixed(2)} grams',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => adjustDfr('decrease'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('-10%'),
                ),
                ElevatedButton(
                  onPressed: () => adjustDfr('increase'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('+10%'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              statusMessage,
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
