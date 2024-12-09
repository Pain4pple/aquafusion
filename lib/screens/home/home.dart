import 'package:aquafusion/screens/home/components/logout.dart';
import 'package:aquafusion/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
// Import the pages
import 'pages/dashboard.dart';
import 'pages/feedingpage.dart';
import 'pages/exportreport.dart';
import 'pages/devmode.dart';
import 'pages/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text('home'),
//     );
//   }
// }


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPageIndex = 0;
  final AuthService _firebaseAuth = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userName;
  String? userPhoneNumber;
  String? userSpecies;
  
  // Pages for navigation
  final List<Widget> _pages = [
    const DashboardScreen(),
    FeedingScheduleScreen(),
    Exportreport(),
    // DevMode(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
  // Function to retrieve user details
  Future<void> _getUserDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Container(
            width: 115, 
             decoration: const BoxDecoration(
               gradient: LinearGradient(
               colors: [Color(0xff529cea), Color(0xffa8e0fd)],
              begin: Alignment.bottomLeft,
               end: Alignment.topRight,
            ),
          ),
            child: Column(
              children: <Widget>[
                 SizedBox(
                  height: 110,
                  child: DrawerHeader(
                    child: Image.asset('assets/images/logo.png')
                  ),
                 ),

                _buildNavItem(Icons.dashboard, 'Dashboard', 0),
                _buildNavItem(FontAwesomeIcons.fish, 'Feeding', 1),
                _buildNavItem(Icons.note, 'Reports', 2),
                // _buildNavItem(Icons.developer_mode_rounded, 'Dev Mode', 3),
                _buildNavItem(Icons.settings, 'Settings', 3),
                LogoutButton(
                  icon: Icons.logout,
                  title: 'Logout',
                  firebaseAuth: _firebaseAuth,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Column(
              children: [
                Container(color: const Color(0xfffeffff), 
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("AquaFusion",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Color(0xff202976),
                              fontFamily: 'Poppins'
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text("80%"),
                                Icon(Icons.battery_4_bar_rounded)
                              ],
                            )
                          ],
                        ),
                        const Divider(
                          color: Color(0xff529cea),
                          thickness: 0.2,
                        ),
                        Text("$userName's Fish Farm",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Color(0xff202976),
                              fontFamily: 'Poppins'
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                ),
                Expanded(child: _pages[_selectedPageIndex])
              ]
            )
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    return GestureDetector(
      onTap: () => _selectPage(index),
      child: Container(
        color: _selectedPageIndex == index ? const Color(0xff55ccff) : Colors.red.withOpacity(0),
        padding: const EdgeInsets.all(15),
        width: 150,
        child: Column(
          children: <Widget>[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _logout(IconData icon, String title) {
    return GestureDetector(
      onTap: () async{
        await _firebaseAuth.signOut();
      },
      
      child: Container(
        color: Colors.red.withOpacity(0),
        padding: const EdgeInsets.all(15),
        width: 100,
        child: Column(
          children: <Widget>[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}