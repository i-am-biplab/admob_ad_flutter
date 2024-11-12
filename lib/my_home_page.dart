import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_ads/helper/admob_service_helper.dart';
import 'package:in_app_ads/pages/next_page.dart';
import 'package:in_app_ads/pages/reward_page.dart';
import 'package:in_app_ads/utils/reward_count_provider.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  // load a banner ad
  void loadBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdmobServiceHelper.testBannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            Timer(const Duration(seconds: 3), () {
              debugPrint("$ad loaded");
              setState(() {
                _isBannerAdLoaded = true;
              });
            });
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint("Failed to load the bannerAd: ${error.message}");
            _isBannerAdLoaded = false;
            ad.dispose();
          },
        ),
        request: const AdRequest())
      ..load();
  }

  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  // load an interstitial ad
  void loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdmobServiceHelper.testInterstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                loadInterstitialAd();
              },
            );

            debugPrint("$ad loaded");
            _interstitialAd = ad;
            setState(() {
              _isInterstitialAdLoaded = true;
            });
          },
          onAdFailedToLoad: (error) {
            debugPrint("Failed to load the InterstitialAd: ${error.message}");
          },
        ));
  }

  late RewardedAd _rewardedAd;
  bool _isRewardedAdLoaded = false;

  // load rewarded ad
  void loadRewardedAd() {
    RewardedAd.load(
        adUnitId: AdmobServiceHelper.testRewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                loadRewardedAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                loadRewardedAd();
              },
            );

            debugPrint("$ad loaded");
            _rewardedAd = ad;
            setState(() {
              _isRewardedAdLoaded = true;
            });
          },
          onAdFailedToLoad: (error) {
            debugPrint("Failed to load the RewardedAd: ${error.message}");
          },
        ));
  }

  @override
  void initState() {
    super.initState();

    loadBannerAd();
    loadInterstitialAd();
    loadRewardedAd();
  }

  @override
  void dispose() {
    super.dispose();

    _bannerAd.dispose();
    _interstitialAd.dispose();
    _rewardedAd.dispose();
  }

  void onTappedAddButton() {
    if (_isInterstitialAdLoaded) _interstitialAd.show();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NextPage(),
      ),
    );
  }

  void onTappedVideoCamButton() {
    if (_isRewardedAdLoaded) {
      _rewardedAd.show(
        onUserEarnedReward: (ad, reward) {
          Provider.of<RewardCountProvider>(context, listen: false)
              .incrementRewardCount();
        },
      );
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RewardPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Mobile Ads"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: onTappedAddButton,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: onTappedVideoCamButton,
            icon: const Icon(Icons.video_call),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(12.0),
                    color: Colors.red.shade300,
                    height: 200,
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isBannerAdLoaded)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: _bannerAd.size.height.toDouble(),
                  width: _bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
