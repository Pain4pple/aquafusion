// import 'dart:io';

// import 'package:aquafusion/screens/wrapper.dart';
// import 'package:aquafusion/services/auth.dart';
// import 'package:aquafusion/services/mqtt_setup.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'firebase_options.dart';
// import 'package:aquafusion/models/user.dart';
// import 'package:provider/provider.dart';

// import 'services/stream_provider.dart';

// Future<void> main() async {
//   HttpOverrides.global = MyHttpOverrides();
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   final MQTTClientWrapper mqttClient = MQTTClientWrapper();
//   await mqttClient.prepareMqttClient().then((_) {
//     print('MQTT Client connected successfully!');
//     runApp(
//       ChangeNotifierProvider(
//         create: (context) => MqttStreamProvider(mqttClient),
//         child: MyApp(),
//       ),
//     );
//   }).catchError((e) {
//     print('Error initializing MQTT Client: $e');
//   });
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     // MQTT initialization moved to provider, so no need here
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<UserModel?>.value(
//       initialData: null,
//       value: AuthService().user,
//       child: MaterialApp(
//         title: 'AquaFusion',
//         home: Wrapper(),
//         theme: ThemeData(
//           textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
//         ),
//       ),
//     );
//   }
// }

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   }
// }
