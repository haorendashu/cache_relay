import 'dart:async';

import 'package:flutter/material.dart';
import 'package:relay_sdk/network/statistics/traffic_counter.dart';

class TrafficCounterProvider extends ChangeNotifier with TrafficCounter {
  void startMoveTimer() {
    Timer.periodic(const Duration(seconds: TrafficCounter.TRAFFIC_TIME_SECOND),
        (t) {
      move();
    });
  }

  @override
  void move() {
    super.move();

    notifyListeners();
  }

  @override
  void add(String id, int length) {
    super.add(id, length);

    notifyListeners();
  }
}
