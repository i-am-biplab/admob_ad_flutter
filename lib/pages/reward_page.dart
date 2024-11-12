import 'package:flutter/material.dart';
import 'package:in_app_ads/utils/reward_count_provider.dart';
import 'package:provider/provider.dart';

class RewardPage extends StatelessWidget {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int rewardCoin =
        Provider.of<RewardCountProvider>(context).rewardCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reward Page"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          "Your Free Coins: $rewardCoin",
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}
