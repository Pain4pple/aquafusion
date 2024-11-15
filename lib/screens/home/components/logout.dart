import 'package:aquafusion/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatefulWidget {
  final IconData icon;
  final String title;
  final AuthService _firebaseAuth;

  LogoutButton({
    required this.icon,
    required this.title,
    required AuthService firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          showLogoutConfirmationDialog(context, () async {
            // Your logout logic here
            // Example: FirebaseAuth.instance.signOut();
            await widget._firebaseAuth.signOut();
            print("User logged out");
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          color: _isHovered ? Color(0xff55ccff) : Color.fromARGB(7, 85, 204, 255),
          padding: EdgeInsets.all(15),
          width: 105,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                widget.icon,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLogoutConfirmationDialog(BuildContext context, VoidCallback onConfirmLogout) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to log out?\nChanging your account means you have to pair the AquaFusion device to your account again."),
        actions: <Widget>[
          TextButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              onConfirmLogout(); // Call the logout function
            },
          ),
        ],
      );
    },
  );
}
}