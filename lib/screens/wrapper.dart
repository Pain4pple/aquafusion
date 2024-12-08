import 'package:aquafusion/models/user.dart';
import 'package:aquafusion/screens/authenticate/authenticate.dart';
import 'package:aquafusion/screens/home/home.dart';
import 'package:aquafusion/screens/setup/setup.dart';
import 'package:aquafusion/screens/setup/tablesetup.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool? setupCompleted;
  bool? tableSetupCompleted;
  bool? speciesSelected;

  @override
  void initState() {
    super.initState();
  }

  void _checkUserSetup() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (mounted) {
        setState(() {
          setupCompleted = userDoc['setup'] ?? false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          setupCompleted = false;
        });
      }
    }
  }

  void _checkUserTableSetup() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (mounted) {
      setState(() {
        if (userDoc['feedingTable'] != null && userDoc['feedingTable'].isNotEmpty) {
          tableSetupCompleted = true;
        } else {
          tableSetupCompleted = false;
        }
      
        // Check if the user has selected a species
        speciesSelected = userDoc['species'] != null;
      });
      }
    } else {
      if (mounted) {
      setState(() {
        tableSetupCompleted = false;
        speciesSelected = false;
      });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    // Check if user is authenticated
    if (user == null) {
      return const Authenticate();
    } else {
      _checkUserSetup();
      _checkUserTableSetup();

      // If setupCompleted or tableSetupCompleted is null, show a loading screen
      if (setupCompleted == null || tableSetupCompleted == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // If setup is not completed, show Setup screen
      if (!setupCompleted!) {
        return const Setup();
      }

      // If feeding table is not set up, show Species Table screen
      if (!tableSetupCompleted!) {
        return const TableSetup(); // New screen for choosing species and table
      }

      // Show Home if everything is set up
      return Home();
    }
  }
}
