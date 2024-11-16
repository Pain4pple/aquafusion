import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ElevatedButton(onPressed: (){
            
          }, child: const Text("Pair with AquaFusion Device"))
        ],
      ),
      ),
    );
  }
}
