import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class FeedingTableScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  String? selectedFeedingTable;

  void _saveFeedingTableSelection(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && selectedFeedingTable != null) {
      await _firestoreService.addSetupData(user.uid, {
        'selectedFeedingTable': selectedFeedingTable,
        'updatedAt': Timestamp.now(),
      });
      Navigator.pushNamed(context, '/nextScreen');  
    } else {
    }
  }

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
                },
                hint: Text("Select Feeding Table"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
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
