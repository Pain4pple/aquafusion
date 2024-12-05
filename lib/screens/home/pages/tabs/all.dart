import 'dart:async';

import 'package:aquafusion/prompts/insertnewabw.dart';
import 'package:aquafusion/services/auth.dart';
import 'package:aquafusion/services/providers/feed_level_provider.dart';
import 'package:aquafusion/services/mqtt_service.dart';
import 'package:aquafusion/services/providers/dO_provider.dart';
import 'package:aquafusion/services/providers/pH_provider.dart';
import 'package:aquafusion/services/providers/salinity_provider.dart';
import 'package:aquafusion/services/providers/temp_provider.dart';
import 'package:aquafusion/services/providers/turbidity_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class All extends StatefulWidget {
  const All({Key? key}) : super(key: key);
  

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  // late StreamSubscription feedLevelSubscription;
    String waterStatus = "Operational";
  double ph = 8.5;
  double turbidity = 30.0;
  double salinity = 0.1;
  double dissolvedOxygen = 5.0;
  double temperature = 24.0;
  final AuthService _firebaseAuth = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userSpecies;
  
  Map<String, double> pHRange = {}; 
  Map<String, double> tempRange = {}; 
  Map<String, double> turbidityRange = {}; 
  Map<String, double> doRange = {}; 
  Map<String, double> salinityRange = {}; 

  @override
  void initState() {
    super.initState();
    _initializeRanges();
  }

  @override
  void dispose() {
    // feedLevelSubscription.cancel();  // Cancel the subscription on dispose
    super.dispose();
  }

Future<void> _getUserDetails() async {
  try {
    User? user = _auth.currentUser;
    if (user != null) {
      print("Fetching details for user: ${user.uid}");
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      print("Document fetched: ${userDoc.data()}");

      if (userDoc.exists) {
        setState(() {
          userSpecies = userDoc['species']; // May throw an error if 'species' is missing
        });
        print("User species: $userSpecies");
      } else {
        print("User document does not exist.");
      }
    } else {
      print("No user is currently logged in.");
    }
  } catch (e) {
    print("Error fetching user details: $e");
  }
}

Future<Map<String, double>> _getOptimumRange(String species, String parameter) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('species')
        .doc(species)
        .collection('water_parameters')
        .doc(parameter)
        .get();

    if (docSnapshot.exists) {
      return {
        'optimumMin': double.tryParse(docSnapshot['optimumMin'].toString()) ?? 0.0,
        'optimumMax': double.tryParse(docSnapshot['optimumMax'].toString()) ?? 0.0,
      };
    }
  } catch (e) {
    print('Error fetching range: $e');
  }
  return {'optimumMin': 0.0, 'optimumMax': 0.0}; // Default values
}

  Future<void> _initializeRanges() async {
    await _getUserDetails();

  if (userSpecies != null) {
    final pH = await _getOptimumRange(userSpecies!, 'pH');
    final temp = await _getOptimumRange(userSpecies!, 'temperature');
    final turbidity = await _getOptimumRange(userSpecies!, 'turbidity');
    final doRangeResult = await _getOptimumRange(userSpecies!, 'dissolvedOxygen');
    final salinity = await _getOptimumRange(userSpecies!, 'salinity');

    setState(() {
      pHRange = pH;
      tempRange = temp;
      turbidityRange = turbidity;
      doRange = doRangeResult;
      salinityRange = salinity;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Consumer<FeedLevelProvider>(
      builder: (context, feedLevelProvider, child) {
        double feedLevel = feedLevelProvider.feedLevel;
        String feedStatus = feedLevel < 30 ? "Low Feed Levels" : "Appropriate Feed Levels";
        IconData feedIcon = feedLevel < 30 ? Icons.error : Icons.thumb_up_alt_rounded;
        Color iconColor = feedLevel < 30 ? Colors.red : const Color.fromARGB(255, 101, 168, 67);
        List<Color> gradientColorFeeder = feedLevel < 30 ?  [Color(0xFFFEC583), Color(0xFFFAD9D9)] : [Color.fromARGB(255, 180, 254, 131), Color.fromARGB(255, 220, 250, 217)];
        if (userSpecies == null) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(userSpecies!, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Feed and Water Quality Monitoring Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Feed Status Card
              _buildStatusCard(
                context: context,
                title: "Feeder",
                status: feedStatus,
                icon: feedIcon,
                iconColor: iconColor,
                gradientColors:gradientColorFeeder,
              ),
              // Water Quality Status Card
              _buildStatusCard(
                context: context,
                title: "Water Quality Monitoring",
                status: waterStatus,
                icon: Icons.water_drop,
                iconColor: Colors.blue,
                gradientColors: [Color(0xFF95C9FF), Color(0xFFCAEFFF)],
              ),
            ],
          ),

          // Feed Level Indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                    Text(
                      "Feed Levels",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.feed, size: 50, color: Colors.red),
                    Text(
                      "${feedLevel.toStringAsFixed(1)}%",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Deduct 10% of the feed level but ensure it doesn't go below 0
                            feedLevelProvider.setFeedLevel((feedLevel * 0.9).clamp(0, double.infinity));
                          },
                          child: const Text("-10%"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => InsertNewAbwPrompt(),
                            );
                          },
                          child: Text("Insert New ABW and Stocking Density"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Add 10% to the feed level
                            feedLevelProvider.setFeedLevel(feedLevel * 1.1);
                          },
                          child: const Text("+10%"),
                        ),
                      ],
                    ),
              ],
            ),
          ),

          // Water Quality Readings
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Water Quality Readings",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Consumer<pHProvider>(
                  builder: (context, pHProvider, child) {
                    double pH = pHProvider.pH;
                    double optimumMin = pHRange['optimumMin'] ?? 6.5;
                    double optimumMax = pHRange['optimumMax'] ?? 9.0;
                    return _buildReadingCard("pH", pH, optimumMin,optimumMax,0.5,"Average: Last 2 mins");
                  },
                ),
                Consumer<turbidityProvider>(
                  builder: (context, turbidityProvider, child) {
                    double turbidity = turbidityProvider.turbidity;
                    double optimumMin = pHRange['optimumMin'] ?? 0.0;
                    double optimumMax = pHRange['optimumMax'] ?? 25.0;
                    return _buildReadingCard("Turbidity (NTU)", turbidity, optimumMin,optimumMax,0.5,"Average: Last 2 mins");
                  },
                ),
                Consumer<salinityProvider>(
                  builder: (context, salinityProvider, child) {
                    double salinity = salinityProvider.salinity;
                    double optimumMin = salinityRange['optimumMin'] ?? 0.0;
                    double optimumMax = salinityRange['optimumMax'] ?? 5.0;
                    return _buildReadingCard("Salinity (ppt)", salinity, optimumMin,optimumMax,0.5,"Average: Last 2 mins");
                  },
                ),
                Consumer<oxygenProvider>(
                  builder: (context, oxygenProvider, child) {
                    double dissolvedOxygen = oxygenProvider.oxygen;
                    double optimumMin = doRange['optimumMin'] ?? 5.0;
                    double optimumMax = doRange['optimumMax'] ?? 10.0;
                    return _buildReadingCard("Dissolved Oxygen (mg/L)", dissolvedOxygen,optimumMin,optimumMax,0.5,"Average: Last 2 mins");
                  },
                ),
                Consumer<tempProvider>(
                  builder: (context, tempProvider, child) {
                    double temperature = tempProvider.temp;
                    double optimumMin = tempRange['optimumMin'] ?? 28.0;
                    double optimumMax = tempRange['optimumMax'] ?? 32.0;
                    return _buildReadingCard("Temperature (°C)", temperature, optimumMin,optimumMax,0.5,"Average: Last 2 mins");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
        );
      },
    );
  }
}


  // Method to build status cards
Widget _buildStatusCard({
    required BuildContext context,
    required String title,
    required String status,
    required IconData icon,
    required Color iconColor,
    required List<Color> gradientColors,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: iconColor, size: 30),
              const SizedBox(width: 8),
              Text(
                status,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to build reading cards
  Widget _buildReadingCard(String title, double value,double optimumMin,double optimumMax,double warningMargin,String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _determineBackgroundColor(value,optimumMin,optimumMax,warningMargin),
          child: Text(value.toStringAsFixed(1), style: GoogleFonts.poppins(fontSize: 16)),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: GoogleFonts.poppins(fontSize: 14)),
      ),
    );
  }

  Color _determineBackgroundColor(double value, double optimumMin, double optimumMax, double warningMargin) {
    if (value >= optimumMin && value <= optimumMax) {
      return Colors.green; // Great
    } else if (value >= (optimumMin - warningMargin) && value < optimumMin ||
              value > optimumMax && value <= (optimumMax + warningMargin)) {
      return Colors.yellow; // Borderline
    } else if (value >= (optimumMin - 2 * warningMargin) && value < (optimumMin - warningMargin) ||
              value > (optimumMax + warningMargin) && value <= (optimumMax + 2 * warningMargin)) {
      return Colors.orange; // Warning Borderline
    } else {
      return Colors.red; // Critical
    }
  }


