import 'package:flutter/material.dart';
import 'package:aquafusion/services/mqtt_stream_service.dart';

class FeedingProvider with ChangeNotifier {
  final MQTTStreamService _mqttStreamService;

  // Initial values for the feeding data
  double _feedingRate = 13.0;
  double _feedAmount = 136.5;
  double _feedAmountPerFeeding = 27.3;
  String _schedule = '8:00,10:00,12:00,14:00,16:00';
  int _doc = 8;
  double _estimatedABW = 3.888888888888889;

  FeedingProvider(this._mqttStreamService) {
    // Listen to MQTT streams for feeding data
    // _mqttStreamService.feedingRateStream.listen((rate) {
    //   _feedingRate = rate;
    //   notifyListeners();
    // });

    _mqttStreamService.dfrStream.listen((amount) {
      _feedAmount = amount;
      notifyListeners();
    });

    _mqttStreamService.feedAmountPerFeedingStream.listen((amountPerFeeding) {
      _feedAmountPerFeeding = amountPerFeeding;
      notifyListeners();
    });

    _mqttStreamService.scheduleStream.listen((schedule) {
      _schedule = schedule;
      notifyListeners();
    });

    _mqttStreamService.docStream.listen((doc) {
      _doc = doc;
      notifyListeners();
    });

    _mqttStreamService.estimatedABWStream.listen((abw) {
      _estimatedABW = abw;
      notifyListeners();
    });
  }

  // Getters
  double get feedingRate => _feedingRate;
  double get feedAmount => _feedAmount;
  double get feedAmountPerFeeding => _feedAmountPerFeeding;
  String get schedule => _schedule;
  int get doc => _doc;
  double get estimatedABW => _estimatedABW;

  // Setters for manual update and UI interaction
  void setFeedingRate(double rate) {
    _feedingRate = rate;
    notifyListeners();
  }

  void setFeedAmount(double amount) {
    _feedAmount = amount;
    notifyListeners();
  }

  void setFeedAmountPerFeeding(double amountPerFeeding) {
    _feedAmountPerFeeding = amountPerFeeding;
    notifyListeners();
  }

  void setSchedule(String schedule) {
    _schedule = schedule;
    notifyListeners();
  }

  void setDOC(int doc) {
    _doc = doc;
    notifyListeners();
  }

  void setEstimatedABW(double abw) {
    _estimatedABW = abw;
    notifyListeners();
  }
}
