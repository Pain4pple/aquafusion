import 'package:aquafusion/screens/authenticate/register.dart';
import 'package:aquafusion/screens/authenticate/sign_in.dart';
import 'package:aquafusion/screens/authenticate/forgot_pass.dart'; // Import the new screen
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  // Track which screen to display
  String currentScreen = 'signin';

  // Function to switch between screens
  void toggleView(String screen) {
    setState(() => currentScreen = screen);
  }

  @override
  Widget build(BuildContext context) {
    if (currentScreen == 'signin') {
      return Container(
        child: SignIn(toggleView: toggleView),
      );
    } else if (currentScreen == 'register') {
      return Container(
        child: Register(toggleView: toggleView),
      );
    } else if (currentScreen == 'forgotPassword') {
      return Container(
        child: ForgotPass(toggleView: toggleView), // New screen
      );
    } else {
      return Container(
        child: Text('Error: Unknown screen'),
      );
    }
  }
}
