import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaterQualityReport {
  final String day;
  final double avgTemperature;
  final double avgDissolvedOxygen;
  final double avgSalinity;
  final double avgTurbidity;
  final double avgPH;

  WaterQualityReport({
    required this.day,
    required this.avgTemperature,
    required this.avgDissolvedOxygen,
    required this.avgSalinity,
    required this.avgTurbidity,
    required this.avgPH,
  });
}

Future<List<WaterQualityReport>> fetchDailyAverages(String uid, DateTimeRange dateRange) async {
  List<WaterQualityReport> reports = [];
  Map<String, List<Map<String, double>>> groupedData = {};

  DateFormat firebaseFormat = DateFormat("yyyy-MM-dd HH:mm"); // Match your Firestore string format
  String startString = firebaseFormat.format(dateRange.start);
  String endString = firebaseFormat.format(dateRange.end);

  // Fetch water quality logs within the date range
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('water_quality_logs')
      .where('timestamp', isGreaterThanOrEqualTo: startString)
      .where('timestamp', isLessThanOrEqualTo: endString)
      .get();

  if (snapshot.docs.isEmpty) {
    print('No data found for the specified date range');
  } else {
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      print('Document Data: ${doc.data()}');
    }
  }

  for (var doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;

    // Check if the 'timestamp' field exists and is not null
    if (data['timestamp'] != null) {
      // Convert Firestore string date to DateTime
      DateTime timestamp;
      try {
        timestamp = DateTime.parse(data['timestamp']); // Assuming it's an ISO 8601 formatted string
      } catch (e) {
        print('Error parsing timestamp for document ${doc.id}: ${e.toString()}');
        continue; // Skip this document if the timestamp is invalid
      }

      // Format the DateTime object to "yyyy-MM-dd" for grouping
      final day = DateFormat('yyyy-MM-dd').format(timestamp);

      // Group logs by day
      if (!groupedData.containsKey(day)) {
        groupedData[day] = [];
      }

      groupedData[day]!.add({
        'temperature': data['temperature'] ?? 0.0,
        'dissolved_oxygen': data['dissolved_oxygen'] ?? 0.0,
        'salinity': data['salinity'] ?? 0.0,
        'ph': data['ph'] ?? 0.0,
        'turbidity': data['turbidity'] ?? 0.0,  // Fixed typo 'turbidty' to 'turbidity'
      });
    } else {
      print('Timestamp is missing or null for document ${doc.id}');
    }
  }

  // Calculate daily averages
  groupedData.forEach((day, logs) {
    double sumTemp = 0.0, sumDO = 0.0, sumSalinity = 0.0, sumPH = 0.0, sumTurbidity = 0.0;
    for (var log in logs) {
      sumTemp += log['temperature']!;
      sumDO += log['dissolved_oxygen']!;
      sumSalinity += log['salinity']!;
      sumPH += log['ph']!;
      sumTurbidity += log['turbidity']!;
    }

    reports.add(WaterQualityReport(
      day: day,
      avgTemperature: sumTemp / logs.length,
      avgDissolvedOxygen: sumDO / logs.length,
      avgSalinity: sumSalinity / logs.length,
      avgPH: sumPH / logs.length,
      avgTurbidity: sumTurbidity / logs.length,
    ));
  });

  // Sort reports by day
  reports.sort((a, b) => a.day.compareTo(b.day));

  return reports;
}
