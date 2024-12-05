import 'package:flutter/material.dart';
import 'package:aquafusion/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  // const Register({super.key});
  final Function(String) toggleView;
  const Register ({super.key, required this.toggleView});
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
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
                        Expanded(child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400,
                        ),      
                        hintText: ' ',
                        hintStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),                    
                        prefixIcon: const Icon(Icons.person, color: Colors.blue),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty ) {
                          return 'First Name is required';
                        }
                        if(value.length>30){
                          return 'First Name must be less than 30 characters long';
                        }
                        return null;
                      },
                      onChanged: (val){
                        setState(() {
                          firstName = val;
                        });
                      },
                    ),
                    ),
                     const SizedBox(width: 8), 
                    Expanded (child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400,
                        ),      
                        hintText: ' ',
                        hintStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),                    
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty ) {
                          return 'Last Name is required';
                        }
                        if(value.length>30){
                          return 'Last Name must be less than 30 characters long';
                        }
                        return null;
                      },
                      onChanged: (val){
                        setState(() {
                          lastName = val;
                        });
                      },
                    ),)
                    ],
                    ),
                    const SizedBox(height: 16),
                    
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
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400,
                        ),      
                        hintText: ' ',
                        hintStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),                    
                        prefixIcon: const Icon(Icons.phone, color: Colors.blue),
                        prefixText: '+63',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
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
                      onChanged: (val){
                        setState(() {
                          phoneNumber = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400,
                        ),                    
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),            
                        prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty ) {
                            return 'Password is required';
                          }
                          if(value.length<6){
                            return 'Password must be 6+ characters long';
                          }
                          return null;
                        },
                      onChanged: (val){
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                  const SizedBox(height: 24),
                    _buildGradientButton('Register', onPressed: () async {
                      if (_formKey.currentState!.validate()){
                        dynamic result = await _authService.registerEmailAndPassword(email, password,firstName,lastName,phoneNumber);
                        if(result==null){
                          setState(()=> error = 'supply valid credentials');
                        }
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