import 'package:aquafusion/models/user.dart';
import 'package:aquafusion/screens/authenticate/authenticate.dart';
import 'package:aquafusion/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    // print(user);
    //return either home or authenticate widget

    if (user == null){
      return Authenticate();
    }else{
      return Home();
    }
  }
}