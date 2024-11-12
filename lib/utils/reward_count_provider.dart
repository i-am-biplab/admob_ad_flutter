import 'package:flutter/material.dart';

class RewardCountProvider extends ChangeNotifier {
  int _rewardCount = 0;

  int get rewardCount => _rewardCount;

  void incrementRewardCount() {
    _rewardCount++;
    notifyListeners();
  }
}
