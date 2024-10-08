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
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("all"),
                Text("water"),
                Text("feeds"),
              ],
            ),
          ),
          //main dashboard
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //feed
              children: [
              Card(
                clipBehavior: Clip.hardEdge,
                 child: const SizedBox(
                  width: 300,
                  height: 40,
                  child: Text('Feeds'),
                ),
              ),
              Card(
                clipBehavior: Clip.hardEdge,
                 child: const SizedBox(
                  width: 300,
                  height: 100,
                  child: Text('Feed Levels'),
                ),
              ),
              Card(
                clipBehavior: Clip.hardEdge,
                 child: const SizedBox(
                  width: 300,
                  height: 100,
                  child: Text('Amount Dispensed'),
                ),
              ),
              Card(
                clipBehavior: Clip.hardEdge,
                 child: const SizedBox(
                  width: 300,
                  height: 100,
                  child: Text('Control Feeding'),
                ),
              ),
                
              ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
            //water quality
              children: [
              Card(
                clipBehavior: Clip.hardEdge,
                 child: const SizedBox(
                  width: 300,
                  height: 100,
                  child: Text('Water Quality'),
                ),
              ),
              Card(
                clipBehavior: Clip.hardEdge,
                 child: const SizedBox(
                  width: 300,
                  height: 100,
                  child: Text('Water Cards'),
                ),
              ),
                
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