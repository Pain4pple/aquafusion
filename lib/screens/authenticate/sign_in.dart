import 'package:aquafusion/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String otp = '';
  String verificationId = '';
  bool isOtpSent = false;
  String error = '';
  bool isLoading = false;

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
                      TextFormField(
                        enabled: !isOtpSent,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: const TextStyle(
                            color: Color(0xff7fbbe9),
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'Enter your phone number',
                          prefixIcon: const Icon(Icons.phone, color: Colors.blue),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
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
                      ),
                      if (isOtpSent) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'OTP',
                            labelStyle: const TextStyle(
                              color: Color(0xff7fbbe9),
                              fontWeight: FontWeight.w400,
                            ),
                            hintText: 'Enter OTP',
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.blue),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 1.5),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            setState(() {
                              otp = val;
                            });
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      _buildGradientButton(
                        isOtpSent ? 'Verify OTP' : 'Send OTP',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                              error = '';
                            });
                            if (isOtpSent) {
                              // Verify OTP
                              await _verifyOtp();
                            } else {
                              // Send OTP
                              await _sendOtp();
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      if (error.isNotEmpty)
                        Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 12),
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
          )
        ],
      ),
    );
  }

  Widget _buildGradientButton(String text,
      {required VoidCallback onPressed, List<Color>? colors, Color? textColor}) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ?? [const Color(0xffb3e8ff), const Color(0xff529cea)],
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
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendOtp() async {
    await _authService.sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) {
        setState(() {
          this.verificationId = verificationId;
          isOtpSent = true;
        });
        print('OTP Sent!');
      },
      onError: (errorMessage) {
        setState(() {
          error = errorMessage;
        });
      },
    );
  }

  Future<void> _verifyOtp() async {
    var user = await _authService.verifyOtpAndRegister(
      verificationId: verificationId,
      otp: otp,
      firstName: '',
      lastName: '',
    );

    if (user != null) {
      print('User signed in: ${user.uid}');
      // Redirect to the home screen
      widget.toggleView('home');
    } else {
      setState(() {
        error = 'Invalid OTP. Please try again.';
      });
    }
  }
}
