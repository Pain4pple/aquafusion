import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          ElevatedButton(onPressed: (){
            
          }, child: Text("Pair with AquaFusion Device"))
        ],
      ),
      ),
    );
  }
}
