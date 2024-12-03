import 'package:flutter/material.dart';

class FeedLevelProvider with ChangeNotifier {
  double _feedLevel = 0.0;

  double get feedLevel => _feedLevel;

  // Method to update the feed level
  void updateFeedLevel(double newFeedLevel) {
    _feedLevel = newFeedLevel;
    notifyListeners(); // Notify listeners to update UI
  }
}
