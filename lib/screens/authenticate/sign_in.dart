import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aquafusion/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function(String) toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String phoneNumber = '';
  String smsCode = '';
  String verificationId = '';
  bool codeSent = false;
  String error = '';

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
                          "AquaFusion",
                          style: GoogleFonts.poppins(
                            color: const Color(0xff202976),
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      !codeSent
                          ? _buildPhoneInputField()
                          : _buildOTPInputField(),
                      const SizedBox(height: 24),
                      _buildGradientButton(
                        codeSent ? 'Verify OTP' : 'Send OTP',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (!codeSent) {
                              // Step 1: Send OTP
                              await _authService.signInWithPhoneNumber(
                                phoneNumber,
                                (verId) {
                                  setState(() {
                                    codeSent = true;
                                    verificationId = verId;
                                  });
                                },
                              );
                            } else {
                              // Step 2: Verify OTP
                              var user = await _authService.verifyOTP(
                                  verificationId, smsCode);
                              if (user != null) {
                                print('User signed in: ${user.uid}');
                              } else {
                                setState(() => error = 'Invalid OTP');
                              }
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      if (error.isNotEmpty)
                        Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView('register');
                        },
                        child: const Text(
                          'Create an account',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
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

  Widget _buildPhoneInputField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: '+1234567890',
        prefixIcon: const Icon(Icons.phone, color: Colors.blue),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        }
        return null;
      },
      onChanged: (val) {
        setState(() {
          phoneNumber = val;
        });
      },
    );
  }

  Widget _buildOTPInputField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'OTP',
        hintText: 'Enter OTP',
        prefixIcon: const Icon(Icons.sms, color: Colors.blue),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'OTP is required';
        }
        return null;
      },
      onChanged: (val) {
        setState(() {
          smsCode = val;
        });
      },
    );
  }

  Widget _buildGradientButton(String text,
      {required VoidCallback onPressed}) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
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
