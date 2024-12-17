import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FeedLog {
  final String timestamp;
  final double targetFeed;
  final double actualDispensed;
  final String method;

  FeedLog({
    required this.timestamp,
    required this.targetFeed,
    required this.actualDispensed,
    required this.method,
  });
}

Future<List<FeedLog>> fetchFeedLogs(String uid, DateTimeRange dateRange) async {
  List<FeedLog> logs = [];

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
    final data = doc.data() as Map<String, dynamic>;

    // Extract fields with null safety
    String timestamp = data['timestamp'] ?? 'Unknown';
    double targetFeed = (data['feed_amount'] as num?)?.toDouble() ?? 0.0;
    double actualDispensed = (data['dispensed_amount'] as num?)?.toDouble() ?? 0.0;
    String method = data['method'] ?? "scheduled";

    // Add each individual log to the list
    logs.add(FeedLog(
      timestamp: timestamp,
      targetFeed: targetFeed,
      actualDispensed: actualDispensed,
      method: method,
    ));
  }

  // Sort by timestamp
  logs.sort((a, b) => a.timestamp.compareTo(b.timestamp));

  return logs;
}

Future<void> generatePDFReportFromLogs(List<FeedLog> logs) async {
  final pdf = pw.Document();
  final fontData = await rootBundle.load('assets/fonts/poppins.ttf');
  final ttf = pw.Font.ttf(fontData);

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Feed Usage Report',
              style: pw.TextStyle(font: ttf, fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['Timestamp', 'Target Feed (g)', 'Actual Dispensed (g)', 'Method'],
            data: logs.map((log) => [
              log.timestamp,
              log.targetFeed.toStringAsFixed(2),
              log.actualDispensed.toStringAsFixed(2),
              log.method,
            ]).toList(),
          ),
        ],
      ),
    ),
  );

  final output = await getApplicationDocumentsDirectory();
  final file = File(
      "${output.path}/feed_usage_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf");
  await file.writeAsBytes(await pdf.save());
  print("PDF saved to ${file.path}");
}
