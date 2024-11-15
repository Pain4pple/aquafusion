import 'package:aquafusion/screens/home/pages/tabs/all.dart';
import 'package:aquafusion/screens/home/pages/tabs/feed.dart';
import 'package:aquafusion/screens/home/pages/tabs/water.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
 Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
      backgroundColor: Color(0xfff0f4ff),
        appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.0), 
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 235, 239, 253), // Background color of the TabBar
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: const Color.fromARGB(255, 168, 176, 202),
            indicatorColor: Colors.blue,
            indicatorWeight: 5.0, 
            tabs: [
              Tab(text: "All"),
              Tab(text: "Water"),
              Tab(text: "Feed"),
            ],
          ),
          )
        ),
        backgroundColor: Color(0xfff0f4ff),
        ),
        body: TabBarView(
          children: [
            Center(child: All()),
            Center(child: WaterQuality()),
            Center(child: Feed()),
          ],
        ),
      ),
    );
  }
}