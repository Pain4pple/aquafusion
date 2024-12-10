import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FeedReport {
  final String day;
  final double amount;
  final String method;
  FeedReport({
    required this.day,
    required this.amount,
    required this.method,
  });
}

Future<double> getTotalFeedAmount(String uid, DateTimeRange dateRange) async {
  double totalAmount = 0.0;

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

  if (snapshot.docs.isEmpty) {
    print('No feeding logs found for the specified date range');
  } else {
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      if (data['amount'] != null) {
        totalAmount += data['amount'];
      }
    }
  }

  return totalAmount;
}

Future<List<FeedReport>> fetchDailyFeedAverages(String uid, DateTimeRange dateRange) async {
  List<FeedReport> reports = [];
  Map<String, List<Map<String, dynamic>>> groupedData = {};

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

    if (data['timestamp'] != null) {
      DateTime timestamp;
      try {
        timestamp = DateTime.parse(data['timestamp']);
      } catch (e) {
        print('Error parsing timestamp for document ${doc.id}: ${e.toString()}');
        continue;
      }

      final day = DateFormat('yyyy-MM-dd').format(timestamp);

      if (!groupedData.containsKey(day)) {
        groupedData[day] = [];
      }

      groupedData[day]!.add({
        'amount': data['amount'] ?? 0.0,
        'method': data['method'] ?? "automatic",
      });
    }
  }

  groupedData.forEach((day, logs) {
    double sumAmount = 0.0;
    String method = logs.isNotEmpty ? logs[0]['method'] : "automatic"; // Assuming method is consistent per day
    for (var log in logs) {
      sumAmount += log['amount']!;
    }

    reports.add(FeedReport(
      day: day,
      amount: sumAmount / logs.length,
      method: method,
    ));
  });

  reports.sort((a, b) => a.day.compareTo(b.day));

  return reports;
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
          pw.Table.fromTextArray(
            headers: ['Day', 'Amount (kg)', 'Method'],
            data: logs.map((log) => [
              log.day,
              log.amount.toStringAsFixed(2),
              log.method,
            ]).toList(),
          ),
        ],
      ),
    ),
  );

  final output = await getApplicationDocumentsDirectory();
  final file = File("${output.path}/feed_usage_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf");
  await file.writeAsBytes(await pdf.save());
  print("PDF saved to ${file.path}");
}
