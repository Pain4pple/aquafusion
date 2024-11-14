import 'package:aquafusion/models/user.dart';
import 'package:aquafusion/screens/authenticate/authenticate.dart';
import 'package:aquafusion/screens/home/home.dart';
import 'package:aquafusion/screens/setup/setup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool? setupCompleted;

  @override
  void initState() {
    super.initState();
  }

  void _checkUserSetup() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        setupCompleted = userDoc['setup'] ?? false;
      });
    } else {
      setState(() {
        setupCompleted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    // Check if user is authenticated
    if (user == null) {
      return Authenticate();
    } else {
      _checkUserSetup();
      // If setupCompleted is null, show a loading screen
      if (setupCompleted == null) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // Show Home or Setup screen based on setupCompleted status
      return setupCompleted! ? Home() : Setup();
    }
  }
}
