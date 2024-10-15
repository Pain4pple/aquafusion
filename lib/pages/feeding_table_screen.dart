import 'package:flutter/material.dart';

class FeedingTableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "You are raising",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              Text(
                "Nile Tilapia Fingerlings",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Choose from our available feeding tables for Nile Tilapia",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                items: [
                  DropdownMenuItem(value: "Table1", child: Text("TATEH Feeding Table")),
                  DropdownMenuItem(value: "Table2", child: Text("Other Feeding Table")),
                ],
                onChanged: (value) {
                  // Handle dropdown selection
                },
                hint: Text("Select Feeding Table"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Proceed to next action
                },
                child: Text("Proceed"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
