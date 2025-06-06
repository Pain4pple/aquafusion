// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> optionsSpecies = [];  
  final List<String> optionsLifestage = ['Fingerling', 'Juvenile','Grower','Finisher'];  
  String? species;
  String? lifestage;
  String error = '';
  String survivalRate = '';
  String averageBodyWeight = '';
  String populationCount = '';
  bool isLoading = true;

  void _completeSetup() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'species': species,
        'lifestage': lifestage,
        'survivalRate': double.tryParse(survivalRate.toString()) ?? 0.0, // Convert to double
        'averageBodyWeight': double.tryParse(averageBodyWeight.toString()) ?? 0.0, // Convert to double
        'populationCount': int.tryParse(populationCount.toString()) ?? 0, // Convert to int
        'setup': true,
      });

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    }
  }
  
  @override
  void initState() {
    super.initState();
    _fetchSpecies();
  }

  Future<void> _fetchSpecies() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('species').get(); // Adjust collection name if needed
      final List<String> fetchedSpecies = snapshot.docs
          .map((doc) => doc.id)
          .toList(); // Adjust field name if needed
      setState(() {
        optionsSpecies = fetchedSpecies;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching species: $e');
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
                        "Setup",
                        style: GoogleFonts.poppins(
                          color: const Color(0xff202976),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

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
                        hintText: 'Select a species',
                        hintStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),     
                      ),
                      value: species,
                      items: optionsSpecies.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          species = newValue!;
                        });
                      },
                      icon: const Icon(Icons.expand_more, color: Colors.blue),
                      style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(height: 16),

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
                        hintText: 'Select a lifestage',
                        hintStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),     
                      ),
                      value: optionsLifestage.contains(lifestage) ? lifestage : null,
                      onChanged: (newValue) {
                        setState(() {
                          lifestage = newValue!;
                        });
                      },
                      items: optionsLifestage.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      icon: const Icon(Icons.expand_more, color: Colors.blue),
                      style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: InputDecoration(    
                        suffixText: '%',
                        hintText: 'Survival Rate (%)',
                        hintStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),                    
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Survival Rate is required';
                        }
                        if (int.tryParse(value) == null && double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onChanged: (val){
                        setState(() {
                          survivalRate = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(    
                        hintText: 'Population count / Stocking density (pcs)',
                        hintStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),                    
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stocking density is required';
                        }
                        if (int.tryParse(value) == null && double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onChanged: (val){
                        setState(() {
                          populationCount = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(                    
                        hintText: 'Average Body Weight (g)',
                        hintStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),            
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty ) {
                          return 'Average Body Weight is required';
                        }
                      if (int.tryParse(value) == null && double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                        return null;
                      },
                      onChanged: (val){
                        setState(() {
                          averageBodyWeight = val ;
                        });
                      },
                    ),
                  const SizedBox(height: 24),
                    _buildGradientButton('Submit', onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                      // If the form is valid, show a success message or proceed
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Storing Data')));
                          _completeSetup();
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