import 'package:aquafusion/screens/home/pages/tabs/all.dart';
import 'package:aquafusion/screens/home/pages/tabs/water.dart';
import 'package:aquafusion/screens/home/pages/tabs/feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure you have this imported
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userSpecies; // Variable to hold the user species

  @override
  void initState() {
    super.initState();
    _getUserDetails(); // Fetch user details when the widget initializes
  }

  Future<void> _getUserDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        print("Fetching details for user: ${user.uid}");
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        print("Document fetched: ${userDoc.data()}");

        if (userDoc.exists) {
          setState(() {
            userSpecies = userDoc['species']; // Update the species state
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



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: const Color(0xfff0f4ff),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 235, 239, 253), // Background color of the TabBar
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Color.fromARGB(255, 168, 176, 202),
                indicatorColor: Colors.blue,
                indicatorWeight: 5.0,
                tabs: [
                  Tab(text: "All"),
                  Tab(text: "Water"),
                  Tab(text: "Feed"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            All(),
            Water(species: userSpecies,),
            Center(child: Feed()),
          ],
        ),
      ),
    );
  }
}
