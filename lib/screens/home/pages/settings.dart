import 'dart:convert'; // Import the dart:convert library for JSON encoding
import 'package:aquafusion/prompts/manual_prompt.dart';
import 'package:aquafusion/prompts/skip_doc.dart';
import 'package:aquafusion/services/auth.dart';
import 'package:aquafusion/services/mqtt_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _firebaseAuth = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final mqttClientWrapper = MQTTClientWrapper();
  User? user;
  String? userName;
  String? userPhoneNumber;
  String? userSpecies;
  late DocumentSnapshot userDoc;

   Future<void> _getUserDetails() async {
    try {
      user = _auth.currentUser;
      if (user != null) {
        userDoc = await _firestore.collection('users').doc(user!.uid).get();
        if (userDoc.exists) {
          setState(() {
            userName = userDoc['firstName'] ?? 'User';
            userPhoneNumber = userDoc['phoneNumber'] ?? 'No phone number';
            userSpecies = userDoc['species'] ?? 'No species';
          });
        }
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  

@override
  void initState() {
    _getUserDetails();
    setState(() {
      
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // final mqttClient = MQTTClientWrapper();

    return Scaffold(
      backgroundColor: const Color(0xfff0f4ff),
      body: SingleChildScrollView(
        child: 
          Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Settings - For Calibration",
                                style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff202976))),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Map<String, dynamic> payload = {
                            "uid": user!.uid, 
                            "abw": userDoc['averageBodyWeight'], 
                            "survival_rate":
                                userDoc['survivalRate'], 
                            "population_count":
                                userDoc['populationCount'], 
                            "species": userDoc['species'], 
                            "supplier": userDoc['feedingTable'], 
                            "lifestage": userDoc['lifestage'], 
                            "phoneNumber":
                                "+63${userDoc['phoneNumber']}" 
                          };
                    
                          String jsonString = jsonEncode(payload);
                    
                          // Publish the message to the MQTT topic
                          mqttClientWrapper.publishMessage('aquafusion/001/command/calibrate_feeder', jsonString, false);
                        },
                        child: const Text("Pair with AquaFusion Device"),
                      ),
            SizedBox(height: 16),
                       ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                ManualFeed(),
                          );
                        },
                        child: const Text("Manual Feed"),
                      ),
                                  SizedBox(height: 16),
                       ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                SkipDOC(),
                          );
                        },
                        child: const Text("Skip Days"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}
