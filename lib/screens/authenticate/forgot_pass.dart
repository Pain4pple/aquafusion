import 'package:aquafusion/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:aquafusion/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPass extends StatefulWidget {
  // const Register({super.key});
  final Function(String) toggleView;
  const ForgotPass ({super.key, required this.toggleView});
  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {

  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  String email = '';
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
                child:Form(
                key: _formKey,
                 child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 18),
                    Center(
                      child: Text(
                        "Forgot Password",
                        style: GoogleFonts.poppins(
                          color: const Color(0xff202976),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),                    
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400,
                        ),      
                        hintText: 'Enter your email',
                        hintStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),                    
                        prefixIcon: const Icon(Icons.email, color: Colors.blue),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onChanged: (val){
                        setState(() {
                          email = val;
                        });
                      },
                    ),

                  const SizedBox(height: 24),
                    _buildGradientButton('Submit', onPressed: () async {
                      if (_formKey.currentState!.validate()){
                        dynamic result = await _authService.forgotPass(email);
                        print(result);
                       showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Password Reset'),
                            content: Text('If the email is valid, a password reset email has been sent to $email.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                  widget.toggleView('signin'); // Navigate back to sign-in
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      }
                    }),
                  const SizedBox(height: 12),
                    _buildGradientButton('Cancel', onPressed: () {
                      widget.toggleView('signin');
                    }, colors: [const Color(0xfff4f6ff), const Color.fromARGB(171, 194, 207, 231)],textColor: const Color(0xff5d9cec)),
                  const SizedBox(height: 16),
                  ],
                ),
              ),
              ),
            ),

          )
        ],
      )
    );
  }

    Widget _buildGradientButton(String text, {required VoidCallback onPressed, List<Color>? colors, Color? textColor}) {
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
        border: Border.all(
        color: const Color(0xffb3e8ff), // Border color
        width: 2, // Border width
      ),
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
}