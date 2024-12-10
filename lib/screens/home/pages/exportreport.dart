import 'package:aquafusion/screens/home/components/feedreport.dart';
import 'package:aquafusion/screens/home/components/reporttry.dart';
import 'package:aquafusion/services/auth.dart';
import 'package:aquafusion/services/mqtt_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class Exportreport extends StatefulWidget {
  @override
  _ExportreportState createState() => _ExportreportState();
}

class _ExportreportState extends State<Exportreport> {
  String selectedMetric = 'Water Quality';
  String email = '';
  DateTimeRange? selectedDateRange;
  final AuthService _firebaseAuth = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final mqttClientWrapper = MQTTClientWrapper();
  User? user;
  String? userName;
  String? userPhoneNumber;
  String? userSpecies;
  double feedTotal=13.0;
  late DocumentSnapshot userDoc;

  Future<void> _getUserDetails() async {
    try {
      user = _auth.currentUser;
      if (user != null) {
        userDoc = await _firestore.collection('users').doc(user!.uid).get();
        if (userDoc.exists) {
          setState(() {
            userName = userDoc['firstName'] ?? 'User';
            userPhoneNumber = userDoc['phoneNumber'] ?? 'No phone number';
            userSpecies = userDoc['species'] ?? 'No species';
          });
        }
      }
    } catch (e) {
       showDialogMessage(context, "Error fetching user details: $e");
    }
  }
 Future<double> fetchFeedingLogs(String uid, DateTimeRange dateRange) async {
  double totalFeedAmount = 0.0;

  DateFormat firebaseFormat = DateFormat("yyyy-MM-dd HH:mm");
  String startString = firebaseFormat.format(dateRange.start);
  String endString = firebaseFormat.format(dateRange.end);

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('feeding_logs')
      .where('timestamp', isGreaterThanOrEqualTo: startString)
      .where('timestamp', isLessThanOrEqualTo: endString)
      .get();

  for (var doc in snapshot.docs) {

    var data = doc.data() as Map<String, dynamic>;
    totalFeedAmount += data['amount'] ?? 0.0;
  print(data);

  }

  return totalFeedAmount;
}
  @override
void initState() {
  super.initState();
  _getUserDetails().then((_) {
    if (user != null) {
      final now = DateTime.now();
      final oneMonthAgo = now.subtract(Duration(days: 30));
      selectedDateRange = DateTimeRange(start: oneMonthAgo, end: now);

      // Fetch feeding logs after user details have been fetched
      fetchFeedingLogs(user!.uid, selectedDateRange!).then((totalFeedAmount) {
        setState(() {
          feedTotal = totalFeedAmount;
        });
      });
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f4ff),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown and Date Range Picker
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedMetric,
                    decoration: InputDecoration(
                      labelText: 'Metrics',
                      labelStyle: const TextStyle(
                        color: Color(0xff7fbbe9),
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'Select metric',
                      hintStyle: const TextStyle(
                        color: Color(0xff7fbbe9),
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(Icons.dashboard, color: Colors.blue),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text('Water Quality'),
                        value: 'Water Quality',
                      ),
                      DropdownMenuItem(
                        child: Text('Feed Usage'),
                        value: 'Feed Usage',
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedMetric = value!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Colors.blue, // Header background color
                                onPrimary: Colors.white, // Header text color
                                onSurface: Colors.blue, // Body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue, // Button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (picked != null && picked != selectedDateRange) {
                        setState(() {
                          selectedDateRange = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Range',
                        labelStyle: const TextStyle(
                          color: Color(0xff7fbbe9),
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: const TextStyle(
                          color: Color(0xff7fbbe9),
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                      child: Text(
                        selectedDateRange == null
                            ? 'Select Date Range'
                            : '${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Report Buttons
            Row(
              children: [
                Expanded(
                  child: _buildGradientButton(
                    'Get Report (PDF)',
                    onPressed: () async {
                      final uid = user!.uid; // Replace with the current user's UID
                      if (selectedDateRange != null) {
                        if (selectedMetric == 'Water Quality') {
                          List<WaterQualityReport> reports = await fetchDailyAverages(uid, selectedDateRange!);
                          await generatePDFReport(reports);
                        } else {
                          List<FeedReport> feedingLogs = await fetchDailyFeedAverages(uid, selectedDateRange!);
                          await generatePDFReportFromLogs(feedingLogs);
                        }
                      } else {
                         showDialogMessage(context, "Please select a date range first.");
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildGradientButton(
                    'Get Report (CSV)',
                    onPressed: () {
                      generateCSV();
                      //  showDialogMessage(context, "Get Report (CSV)");
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Average Stats Display
            Text(
              'Average Last 30 Days:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildStatCard('${feedTotal.toStringAsFixed(2)} grams', 'Feed Usage', Icons.food_bank)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildStatCard('27°C', 'Temp', Icons.thermostat)),
                Expanded(child: _buildStatCard('5 mg/L', 'DO', Icons.water)),
                Expanded(child: _buildStatCard('0.1 ppt', 'Salinity', Icons.opacity)),
                Expanded(child: _buildStatCard('7', 'pH', Icons.science)),
                Expanded(child: _buildStatCard('210', 'Turbidity', Icons.dirty_lens)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text, {required VoidCallback onPressed, List<Color>? colors, Color? textColor}) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ?? [const Color(0xffb3e8ff), const Color(0xff529cea)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Future<void> generatePDFReport(List<WaterQualityReport> reports) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/fonts/poppins.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Water Quality Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Day', 'Temp (°C)', 'DO (mg/L)', 'Salinity (ppt)', 'pH', 'Turbidity'],
              data: reports.map((report) => [
                    report.day,
                    report.avgTemperature.toStringAsFixed(2),
                    report.avgDissolvedOxygen.toStringAsFixed(2),
                    report.avgSalinity.toStringAsFixed(2),
                    report.avgPH.toStringAsFixed(2),
                    report.avgTurbidity.toStringAsFixed(2),
                  ]).toList(),
            ),
          ],
        ),
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/water_quality_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf");
    await file.writeAsBytes(await pdf.save());
     showDialogMessage(context, "PDF saved to ${file.path}");
  }

  Future<void> generatePDFReportFromLogs(List<FeedReport> logs) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/fonts/poppins.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Feed Usage Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Timestamp', 'Method', 'Amount'],
              data: logs.map((log) => [
                    log.day,
                    log.method,
                    log.amount.toString(),
                  ]).toList(),
            ),
          ],
        ),
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/feed_usage_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf");
    await file.writeAsBytes(await pdf.save());
     showDialogMessage(context, "PDF saved to ${file.path}");
  }

 

  void generateCSV() async {
  if (selectedDateRange == null) {
     showDialogMessage(context, "Please select a date range first.");
    return;
  }

  final uid = user!.uid; // Current user UID
  List<List<dynamic>> rows = [];

  if (selectedMetric == 'Water Quality') {
    // Fetch Water Quality data
    List<WaterQualityReport> reports = await fetchDailyAverages(uid, selectedDateRange!);
    rows.add(['Day', 'Temp (°C)', 'DO (mg/L)', 'Salinity (ppt)', 'pH', 'Turbidity']);
    for (var report in reports) {
      rows.add([
        report.day,
        report.avgTemperature.toStringAsFixed(2),
        report.avgDissolvedOxygen.toStringAsFixed(2),
        report.avgSalinity.toStringAsFixed(2),
        report.avgPH.toStringAsFixed(2),
        report.avgTurbidity.toStringAsFixed(2),
      ]);
    }
  } else if (selectedMetric == 'Feed Usage') {
    // Fetch Feed Usage data (feeding_logs)
      DateFormat firebaseFormat = DateFormat("yyyy-MM-dd HH:mm"); // Match your Firestore string format
    String startString = firebaseFormat.format(selectedDateRange!.start);
    String endString = firebaseFormat.format(selectedDateRange!.end);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('feeding_logs')
        .where('timestamp', isGreaterThanOrEqualTo: startString)
        .where('timestamp', isLessThanOrEqualTo: endString)
        .get();

    rows.add(['Timestamp', 'Method', 'Amount']);
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      rows.add([
        data['timestamp'],  // Assuming timestamp is a string
        data['method'] ?? 'Unknown Method',
        data['amount'] ?? 0.0,
      ]);
    }
  }

  // Convert the data into CSV format
  String csvData = const ListToCsvConverter().convert(rows);

  // Get the documents directory
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/aquafusion_${selectedMetric}_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';

  // Save the CSV file to documents directory
  final file = File(filePath);
  await file.writeAsString(csvData);

   showDialogMessage(context, "CSV saved to: $filePath");
}
void showDialogMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Notification'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}
