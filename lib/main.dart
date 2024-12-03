import 'dart:io';

import 'package:aquafusion/screens/wrapper.dart';
import 'package:aquafusion/services/auth.dart';
import 'package:aquafusion/services/feed_level_provider.dart';
import 'package:aquafusion/services/mqtt_service.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart';
import 'package:aquafusion/services/mqttstream_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:aquafusion/models/user.dart';
import 'package:provider/provider.dart';

// ...
// void main() {
//   runApp(MyApp());
// }
Future <void> main()async{
  final mqttService = MQTTStreamService();
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => FeedLevelProvider(mqttService),
      child: MyApp(mqttService:mqttService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final MQTTClientWrapper mqttClient = MQTTClientWrapper();
  final MQTTStreamService mqttService;

  MyApp({super.key, required this.mqttService});

  @override
  Widget build(BuildContext context) {
    mqttClient.prepareMqttClient();
    mqttService.startListening();
    return StreamProvider<UserModel?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'AquaFusion',
        home: Wrapper(),
        theme: ThemeData(
        // Set the default font family to Poppins using Google Fonts
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      )
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

