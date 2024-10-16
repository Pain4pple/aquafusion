import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class SetupScreen extends StatelessWidget {
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _lifestageController = TextEditingController();
  final TextEditingController _stockingDensityController = TextEditingController();
  final TextEditingController _averageBodyWeightController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  void _submitSetupData(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final setupData = {
        'species': _speciesController.text.trim(),
        'lifestage': _lifestageController.text.trim(),
        'stockingDensity': double.tryParse(_stockingDensityController.text) ?? 0,
        'averageBodyWeight': double.tryParse(_averageBodyWeightController.text) ?? 0,
        'createdAt': Timestamp.now(),
      };

      await _firestoreService.addSetupData(user.uid, setupData);
      Navigator.pushNamed(context, '/feeding_table');
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
                "Setup",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Species'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Lifestage'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Stocking density'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Average Body Weight'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/feeding_table');
                },
                child: Text("Submit"),
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
