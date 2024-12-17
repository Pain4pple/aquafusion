import 'package:flutter/material.dart';
import 'package:aquafusion/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  final Function(String) toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String otp = '';
  String error = '';
  String verificationId = '';
  bool isOtpSent = false;
  bool isLoading = false;
  bool _isChecked = false; // Checkbox state

  // Show Terms and Conditions dialog
  void _showAgreementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms and Conditions for Data Privacy'),
        content: const SingleChildScrollView(
          child: Text(
            '''Introduction
This document outlines the terms and conditions regarding the collection, use, and protection of your personal data when you use our services. By accessing and using our services, you agree to the collection and use of information in accordance with this Privacy Policy.

1. Data Collection
We collect personal information that you provide when registering for an account, including your name, phone number, and other relevant data necessary to provide our services. This data may be collected through forms, phone verification, and other interactions with the app.

2. Use of Personal Information
The personal data we collect is used for the following purposes:
- To verify your identity and manage your account.
- To send notifications and updates related to your activities within the app.
- To improve the quality of our services and provide customer support.
- To comply with legal obligations as required.

3. Data Security
We are committed to ensuring the security of your personal data. We implement various security measures, including encryption, access controls, and regular security audits, to protect your data from unauthorized access, alteration, disclosure, or destruction. 

While we use industry-standard measures to protect your data, no method of transmission or storage can be guaranteed to be 100% secure. By using our services, you acknowledge and accept this inherent risk.

4. Data Sharing
We will not sell, rent, or lease your personal data to third parties. However, we may share your personal data with trusted partners or service providers who assist us in operating our services, subject to the same data protection standards.

5. Data Retention
We retain your personal information only for as long as necessary for the purposes set out in this Privacy Policy, or as required by law. Once your data is no longer required, it will be securely deleted.

6. Your Rights
You have the right to access, correct, or delete your personal data at any time. If you wish to exercise these rights, please contact us using the contact details provided below. We will respond to your request within a reasonable timeframe.

7. Cookies and Tracking Technologies
We may use cookies or similar tracking technologies to improve the user experience and collect information about your use of our services. You can control the use of cookies through your browser settings, but please note that disabling cookies may affect the functionality of the app.

8. Changes to This Privacy Policy
We may update this Privacy Policy from time to time. Any changes will be posted in this section with an updated revision date. It is your responsibility to review this Privacy Policy regularly to stay informed about how we are protecting your personal data.

9. Contact Us
If you have any questions or concerns regarding this Terms and Conditions for Data Privacy, please contact us at:

Email: aquafusion.dev@gmail.com  

By registering, you agree to these terms and conditions for data privacy.''',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
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
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 18),
                      Center(
                        child: Text(
                          "Register",
                          style: GoogleFonts.poppins(
                            color: const Color(0xff202976),
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  _inputDecoration('First Name', Icons.person),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'First Name is required';
                                }
                                if (value.length > 100) {
                                  return 'First Name must be less than 100 characters';
                                }
                                return null;
                              },
                              onChanged: (val) =>
                                  setState(() => firstName = val),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  _inputDecoration('Last Name', Icons.person),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Last Name is required';
                                }
                                if (value.length > 100) {
                                  return 'Last Name must be less than 100 characters';
                                }
                                return null;
                              },
                              onChanged: (val) =>
                                  setState(() => lastName = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration:
                            _inputDecoration('Phone Number', Icons.phone)
                                .copyWith(prefixText: '+63'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          RegExp regExp = RegExp(r'^(9\d{9})$');
                          if (!regExp.hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        onChanged: (val) => setState(() => phoneNumber = val),
                      ),
                      const SizedBox(height: 16),
                      if (isOtpSent)
                        TextFormField(
                          decoration: _inputDecoration('Enter OTP', Icons.lock),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'OTP is required';
                            }
                            return null;
                          },
                          onChanged: (val) => setState(() => otp = val),
                        ),
                      const SizedBox(height: 16),

                      // Terms and Conditions Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (value) {
                              setState(() => _isChecked = value!);
                            },
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: _showAgreementDialog,
                              child: Text.rich(
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: const TextStyle(fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Register Button (Disabled until checkbox is checked)
_buildGradientButton('Register', onPressed: () async {
                        if (_formKey.currentState!.validate()) {
if (isOtpSent) {
  // Verify OTP
  try {
    User? user = await _authService.verifyOtpAndRegister(
      verificationId: verificationId,
      otp: otp,
      firstName: firstName,
      lastName: lastName,
    );

    if (user != null) {
      print('User registered with UID: ${user.uid}');
      widget.toggleView('home'); // Redirect to the home screen
    } else {
      setState(() {
        error = 'OTP verification failed';
      });
    }
  } catch (e) {
    print('Error during verification: $e');
    setState(() {
      error = 'Failed to verify OTP';
    });
  }
} else {
  // Send OTP
  await _authService.sendOtp(
    phoneNumber: phoneNumber,
    onCodeSent: (verificationId) {
      setState(() {
        this.verificationId = verificationId;
        isOtpSent = true;
        isLoading = false;
      });
      print('OTP Sent. Verification ID: $verificationId');
    },
    onError: (errorMessage) {
      setState(() {
        error = errorMessage;
        isLoading = false;
      });
      print('Error: $errorMessage');
    },
  );
}

                        }
                      }),
                      const SizedBox(height: 12),
                      _buildGradientButton('Cancel', onPressed: () {
                        widget.toggleView('signin');
                      }),
                      if (error.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(error, style: const TextStyle(color: Colors.red)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Input decoration helper
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xff7fbbe9)),
      prefixIcon: Icon(icon, color: Colors.blue),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
    );
  }

  // Gradient button builder
  Widget _buildGradientButton(String text, {VoidCallback? onPressed}) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffb3e8ff), Color(0xff529cea)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
