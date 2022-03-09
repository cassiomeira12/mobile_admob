import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile_admob/src/admob_widget.dart';

class MobileAdmob {
  static String _testAndroidId = 'ca-app-pub-3940256099942544/6300978111';
  static String _testIOSId = 'ca-app-pub-3940256099942544/2934735716';

  static void initialize({
    bool test = true,
    String? androidId,
    String? iOSId,
    List<String> testDevicesIds = const [],
  }) {
    if (kReleaseMode) {
      assert(androidId != null);
      assert(iOSId != null);
      _testAndroidId = androidId!;
      _testIOSId = iOSId!;
    }
    if (!test) {
      assert(androidId != null);
      assert(iOSId != null);
      _testAndroidId = androidId!;
      _testIOSId = iOSId!;
    }
    MobileAds.instance.initialize().then((status) {
      try {
        var platform = Platform.isAndroid
            ? 'com.google.android.gms.ads.MobileAds'
            : 'GADMobileAds';
        final finalStatus =
            describeEnum(status.adapterStatuses[platform]!.state);
        debugPrint('MobileAdmob status: [$finalStatus]');
      } catch (error) {
        debugPrint('MobileAdmob status: [$error]');
      }
      if (kDebugMode) {
        MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(testDeviceIds: testDevicesIds),
        );
      }
    });
  }

  static Widget banner({
    Widget? loadingWidget,
    ValueChanged<bool>? loadSucessful,
    bool? showError,
  }) {
    return AdmobWidget(
      adUnitId: Platform.isAndroid ? _testAndroidId : _testIOSId,
      size: AdSize.fullBanner, // const AdSize(width: 390, height: 55),
      loadingWidget: loadingWidget,
      loadSucessful: loadSucessful,
    );
  }

  static Widget rectangle({
    Widget? loadingWidget,
    ValueChanged<bool>? loadSucessful,
    bool? showError,
  }) {
    return AdmobWidget(
      adUnitId: Platform.isAndroid ? _testAndroidId : _testIOSId,
      size: AdSize.mediumRectangle,
      loadingWidget: loadingWidget,
      loadSucessful: loadSucessful,
    );
  }

  static Widget fullScreen({
    Widget? loadingWidget,
    ValueChanged<bool>? loadSucessful,
    bool? showError,
  }) {
    return AdmobWidget(
      adUnitId: Platform.isAndroid ? _testAndroidId : _testIOSId,
      size: const AdSize(width: 412, height: 340),
      loadingWidget: loadingWidget,
      loadSucessful: loadSucessful,
    );
  }

  static Future<void> requestTrackingAuthorization() async {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
}
