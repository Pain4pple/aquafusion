import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart'; // Import the service

class scheduleProvider with ChangeNotifier {
  String _schedule = '8:00,8:02,8:05,8:07,8:09'; // Initial schedule string
  List<String> _schedules = ['8:00', '8:02', '8:05', '8:07', '8:09'];
  final MQTTStreamService _mqttStreamService;

  scheduleProvider(this._mqttStreamService) {
    // Listen to MQTT schedule updates
    _mqttStreamService.scheduleStream.listen((schedule) {
      _schedule = schedule;
      _schedules = _schedule.split(',').map((s) => s.trim()).toList();
      notifyListeners(); // Notify UI to rebuild
    });
  }

  // Getters
  String get schedule => _schedule;
  List<String> get schedules => _schedules;

  // Update schedule and notify listeners
  void setschedule(String schedule) {
    _schedule = schedule;
    _schedules = schedule.split(',').map((s) => s.trim()).toList();
    notifyListeners();
  }

  void addSchedule(String time) {
    _schedules.add(time);
    _updateScheduleString();
  }

  void editSchedule(int index, String newTime) {
    if (index >= 0 && index < _schedules.length) {
      _schedules[index] = newTime;
      _updateScheduleString();
    }
  }

  void deleteSchedule(int index) {
    if (index >= 0 && index < _schedules.length) {
      _schedules.removeAt(index);
      _updateScheduleString();
    }
  }

  String getFormattedSchedules() {
    return _schedules.join(',');
  }

  // Private method to synchronize _schedule with _schedules
  void _updateScheduleString() {
    _schedule = _schedules.join(',');
    notifyListeners();
  }
}
