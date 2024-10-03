import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AquaFusion App"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                // Navigate to Dashboard
              },
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Feeding Schedule'),
              onTap: () {
                // Navigate to Feeding Schedule
              },
            ),
            ListTile(
              leading: Icon(Icons.water),
              title: Text('Water Quality'),
              onTap: () {
                // Navigate to Water Quality Monitoring
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to Settings
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("Welcome to AquaFusion!"),
      ),
    );
  }
}