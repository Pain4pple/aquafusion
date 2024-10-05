import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff0f4ff),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
          //tabs
          Row(
            children: [
              Text("all"),
              Text("water"),
              Text("feeds"),
            ],
          ),
          //main dashboard
          Row(
            children: [
              Column(
                //feed
              children: [
              Text ("feeds"),
              Text ("feed illustration"),
              Text ("amount of feeds"),
              Text ("control"),
                
              ],
              ),
              Column(
            //water quality
              children: [
              Text ("water"),
              Text ("water cards"),
                
              ],
              ),
            ],
          )
          ],
        ),
      )
    );
  }
}

// Widget _buildTabItem(String title, int index) {
// }