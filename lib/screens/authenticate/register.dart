import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  final Function(String) toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String otp = '';
  String verificationId = '';
  bool isOTPSent = false;
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
                          isOTPSent ? "Verify OTP" : "Register",
                          style: GoogleFonts.poppins(
                            color: const Color(0xff202976),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // First Name & Last Name Fields
                      if (!isOTPSent) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                label: 'First Name',
                                icon: Icons.person,
                                onChanged: (val) => setState(() => firstName = val),
                                validator: (value) => value!.isEmpty
                                    ? 'First Name is required'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildTextField(
                                label: 'Last Name',
                                icon: Icons.person_outline,
                                onChanged: (val) => setState(() => lastName = val),
                                validator: (value) => value!.isEmpty
                                    ? 'Last Name is required'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Phone Number Input
                        _buildTextField(
                          label: 'Phone Number',
                          icon: Icons.phone,
                          prefixText: '+63 ',
                          keyboardType: TextInputType.phone,
                          onChanged: (val) => setState(() => phoneNumber = val),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone number is required';
                            }
                            if (!RegExp(r'^(9\d{9})$').hasMatch(value)) {
                              return 'Enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                      // OTP Input Field
                      if (isOTPSent) ...[
                        _buildTextField(
                          label: 'OTP',
                          icon: Icons.sms,
                          keyboardType: TextInputType.number,
                          onChanged: (val) => setState(() => otp = val),
                          validator: (value) => value!.isEmpty
                              ? 'Enter the OTP sent to your phone'
                              : null,
                        ),
                        const SizedBox(height: 24),
                      ],
                      // Register or Verify OTP Button
                      _buildGradientButton(
                        isOTPSent ? 'Verify OTP' : 'Send OTP',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (isOTPSent) {
                              await _verifyOTP();
                            } else {
                              await _sendOTP();
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      // Cancel Button
                      _buildGradientButton(
                        'Cancel',
                        onPressed: () {
                          widget.toggleView('signin');
                        },
                        colors: [
                          const Color(0xfff4f6ff),
                          const Color.fromARGB(171, 194, 207, 231)
                        ],
                        textColor: const Color(0xff5d9cec),
                      ),
                      const SizedBox(height: 16),
                      if (error.isNotEmpty)
                        Text(
                          error,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
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

  Widget _buildTextField({
    required String label,
    required IconData icon,
    String? prefixText,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xff7fbbe9), fontWeight: FontWeight.w400),
        prefixText: prefixText,
        prefixIcon: Icon(icon, color: Colors.blue),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
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
        border: Border.all(color: const Color(0xffb3e8ff), width: 2),
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

  Future<void> _sendOTP() async {
    String fullPhoneNumber = '+63$phoneNumber';
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          setState(() => error = 'Phone number verified automatically');
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => error = 'Verification failed: ${e.message}');
        },
        codeSent: (String verId, int? resendToken) {
          setState(() {
            verificationId = verId;
            isOTPSent = true;
            error = '';
          });
        },
        codeAutoRetrievalTimeout: (String verId) {
          setState(() => verificationId = verId);
        },
      );
    } catch (e) {
      setState(() => error = 'Failed to send OTP. Error: $e');
    }
  }

  Future<void> _verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      setState(() => error = 'Phone number verified successfully!');
    } catch (e) {
      setState(() => error = 'Invalid OTP. Please try again.');
    }
  }
}
