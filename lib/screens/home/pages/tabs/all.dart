import 'package:aquafusion/prompts/insertnewabw.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class All extends StatefulWidget {
  const All({Key? key}) : super(key: key);

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  // Simulated data placeholders (replace with database calls)
  double feedLevel = 25.0; // Example: 25 kg
  String feedStatus = "Low Feed Levels";
  String waterStatus = "Operational";
  double ph = 8.5;
  double turbidity = 30.0;
  double salinity = 0.1;
  double dissolvedOxygen = 5.0;
  double temperature = 24.0;

  // Fetch data from the database
  Future<void> fetchData() async {
    // Simulate API call delay and replace with real database calls
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Update with data fetched from the database
      feedLevel = 20.0; // Example: New feed level
      feedStatus = feedLevel < 30 ? "Low Feed Levels" : "Normal";
      ph = 7.8; // Example: New pH value
      turbidity = 25.0;
      salinity = 0.15;
      dissolvedOxygen = 5.5;
      temperature = 26.0;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch initial data
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("AquaFusion", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Feed and Water Quality Monitoring Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Feed Status Card
              _buildStatusCard(
                title: "Feeder",
                status: feedStatus,
                icon: Icons.error,
                iconColor: Colors.red,
                gradientColors: [Color(0xFFFEC583), Color(0xFFFAD9D9)],
              ),
              // Water Quality Status Card
              _buildStatusCard(
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
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.feed, size: 50, color: Colors.red),
                Text(
                  "${feedLevel.toStringAsFixed(1)} kg remaining",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                          // Deduct 10% of the feed level but ensure it doesn't go below 0
                            feedLevel = (feedLevel * 0.9).clamp(0, double.infinity);
                            feedStatus = feedLevel < 30 ? "Low Feed Levels" : "Normal";
                          });
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
                          setState(() {
                          // Add 10% to the feed level
                            feedLevel = feedLevel * 1.1;
                            feedStatus = feedLevel < 30 ? "Low Feed Levels" : "Normal";
                          });
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
                _buildReadingCard("pH", ph, "Average: Last 2 mins"),
                _buildReadingCard("Turbidity (NTU)", turbidity, "Average: Last 2 mins"),
                _buildReadingCard("Salinity (ppt)", salinity, "Average: Last 2 mins"),
                _buildReadingCard("Dissolved Oxygen (mg/L)", dissolvedOxygen, "Average: Last 2 mins"),
                _buildReadingCard("Temperature (°C)", temperature, "Average: Last 2 mins"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to build status cards
  Widget _buildStatusCard({
    required String title,
    required String status,
    required IconData icon,
    required Color iconColor,
    required List<Color> gradientColors,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
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
  Widget _buildReadingCard(String title, double value, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(value.toStringAsFixed(1), style: GoogleFonts.poppins(fontSize: 16)),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: GoogleFonts.poppins(fontSize: 14)),
      ),
    );
  }
}
