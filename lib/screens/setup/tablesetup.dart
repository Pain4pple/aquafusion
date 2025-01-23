// import 'dart:ffi';

import 'dart:convert';

import 'package:aquafusion/services/mqtt_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class TableSetup extends StatefulWidget {
  const TableSetup({super.key});

  @override
  State<TableSetup> createState() => _TableSetupState();
}

class _TableSetupState extends State<TableSetup> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final mqttClient = MQTTClientWrapper();
  List<String> optionsTables = [];  
  String? selectedSpecies;
  String? selectedLifestage;
  String error = '';
  String survivalRate = '';
  String averageBodyWeight = '';
  String populationCount = '';
  String? feedingTable='TATEH';
  bool isLoading = true;
  late DocumentSnapshot userDoc;
  void _completeTableSetup() async {
    User? user = _auth.currentUser;
    if (user != null) {
      print("Feeding table: $feedingTable");
      await _firestore.collection('users').doc(user.uid).update({
        'feedingTable': feedingTable,
      });

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
    mqttClient.publishMessage('aquafusion/001/command/calibrate_feeder', jsonString, false);

      // Navigate to main app screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    }
  }
  
  
  @override
  void initState() {
    super.initState();
    User? user = _auth.currentUser;
    _fetchUserSpecies(user);
  }

  Future<void> _fetchUserSpecies(User? user) async {
    try {
      userDoc = await _firestore.collection('users').doc(user?.uid).get();
      selectedSpecies = userDoc['species']; 
      selectedLifestage = userDoc['lifestage']; 
      print("$selectedSpecies is the selected species");
      if (selectedSpecies != null) {
        DocumentSnapshot speciesDoc = await _firestore.collection('species').doc(selectedSpecies).get();
        if (speciesDoc.exists) {
          QuerySnapshot feedingTableSnapshot = await speciesDoc.reference.collection('feeding_table').get();
          final List<String> fetchedTables = feedingTableSnapshot.docs
              .map((doc) => doc.id) 
              .toList();
          setState(() {
            optionsTables = fetchedTables;
            feedingTable = fetchedTables.isNotEmpty ? fetchedTables.first : null; // set initial value
            isLoading = false;
          });
        } else {
          print('$selectedSpecies document not found');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('User has not selected a species');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching species and feeding table: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
            Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundlogin.png', 
              fit: BoxFit.cover,     
            ),
          ),
          Center(
            child: Card(
              color: const Color(0xfffeffff),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                key:_formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        "You are raising",
                        style: GoogleFonts.poppins(
                          color: const Color(0xff202976),
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "$selectedSpecies $selectedLifestage",
                        style: GoogleFonts.poppins(
                          color: const Color(0xff202976),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),                    
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "Choose from our available feeding tables for $selectedSpecies",
                        style: GoogleFonts.poppins(
                          color: const Color(0xff202976),
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (isLoading)
                      CircularProgressIndicator()
                    else
                     // Dropdown for feeding tables
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        hintText: 'Select a feeding table',
                        hintStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),     
                      ),
                      value: feedingTable, // Keep the selected value
                      items: optionsTables.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        print("Feeding table: $newValue");
                        setState(() {
                          feedingTable = newValue!;
                        });
                      },
                      icon: const Icon(Icons.expand_more, color: Colors.blue),
                      style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    _buildGradientButton('Proceed', onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                      // If the form is valid, show a success message or proceed
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Storing Data')));
                          _completeTableSetup();
                      }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please make sure all details are correct')));
                      }
                    }),
                    const SizedBox(height: 16),
                  ],
                ),
                ),
              ),
            ),

          )
        ],
      )
    );
  }

  Widget _buildGradientButton(String text, {required VoidCallback onPressed, List<Color>? colors, Color? textColor}) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ?? [const Color(0xffb3e8ff), const Color(0xff529cea)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}