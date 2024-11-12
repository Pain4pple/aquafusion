import 'package:flutter/material.dart';
import 'package:aquafusion/services/auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _authService = AuthService();
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';

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
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(child: TextField(
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400,
                        ),      
                        hintText: ' ',
                        hintStyle: TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),                    
                        prefixIcon: Icon(Icons.person, color: Colors.blue),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      onChanged: (val){
                        setState(() {
                          firstName = val;
                        });
                      },
                    ),
                    ),
                     SizedBox(width: 8), 
                    Expanded (child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400,
                        ),      
                        hintText: ' ',
                        hintStyle: TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),                    
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      onChanged: (val){
                        setState(() {
                          lastName = val;
                        });
                      },
                    ),)
                    ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400,
                        ),      
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),                    
                        prefixIcon: Icon(Icons.email, color: Colors.blue),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      onChanged: (val){
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400,
                        ),                    
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                          color: Color(0xff7fbbe9), 
                          fontWeight: FontWeight.w400, 
                        ),            
                        prefixIcon: Icon(Icons.lock, color: Colors.blue),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      obscureText: true,
                      onChanged: (val){
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                  SizedBox(height: 24),
                    _buildGradientButton('Register', onPressed: () async {
                      print(email);
                      print(firstName);
                    }),
                  SizedBox(height: 16),
                    _buildGradientButton('Cancel', onPressed: () {
                      // Handle sign-in logic here
                    }, colors: [const Color(0xfff4f6ff)!, const Color.fromARGB(171, 134, 159, 206)!],textColor: Color(0xff5d9cec)),
                  SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle registration navigation
                          },
                          child: Text(
                            'Already registered? Sign in here',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
          colors: colors ?? [Color(0xffb3e8ff), Color(0xff529cea)],
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
}