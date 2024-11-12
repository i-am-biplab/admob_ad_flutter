import 'dart:io';

class AdmobServiceHelper {
  static String get testBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/9214589741';
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  static String get testInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  static String get testRewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }
}
