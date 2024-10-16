import 'package:aquafusion/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your screens
import 'pages/dashboard.dart';
import 'pages/feedingpage.dart';
import 'pages/exportreport.dart';
import 'pages/devmode.dart';
import 'pages/settings.dart';
import 'pages/login_screen.dart';
import 'pages/register_screen.dart';
import 'pages/forgot_password_screen.dart';
import 'pages/welcome_screen.dart';
import 'pages/setup_screen.dart';
import 'pages/feeding_table_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ); // Initialize Firebase here
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AquaFusion',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/setup': (context) => SetupScreen(),
        '/feeding_table': (context) => FeedingTableScreen(),
        '/dashboard': (context) => HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;

  // Pages for navigation
  final List<Widget> _pages = [
    DashboardScreen(),
    FeedingScheduleScreen(),
    Exportreport(),
    DevMode(),
    SettingsScreen(),
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Container(
            width: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff529cea), Color(0xffa8e0fd)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 110,
                  child: DrawerHeader(
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                _buildNavItem(Icons.dashboard, 'Dashboard', 0),
                _buildNavItem(FontAwesomeIcons.fish, 'Feeding', 1),
                _buildNavItem(Icons.note, 'Reports', 2),
                _buildNavItem(Icons.developer_mode_rounded, 'Dev Mode', 3),
                _buildNavItem(Icons.settings, 'Settings', 4),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  color: Color(0xfffeffff),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "AquaFusion",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  color: Color(0xff202976),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text("80%"),
                                  Icon(Icons.battery_4_bar_rounded),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            color: Color(0xff529cea),
                            thickness: 0.2,
                          ),
                          Text(
                            "Don Hilario's Fish Farm",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Color(0xff202976),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(child: _pages[_selectedPageIndex])
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    return GestureDetector(
      onTap: () => _selectPage(index),
      child: Container(
        color: _selectedPageIndex == index ? Color(0xff55ccff) : Colors.red.withOpacity(0),
        padding: EdgeInsets.all(15),
        width: 100,
        child: Column(
          children: <Widget>[
            Icon(icon, color: Colors.white),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
