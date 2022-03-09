import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobWidget extends StatefulWidget {
  final String adUnitId;
  final AdSize size;
  final Widget? loadingWidget;
  final bool showError;
  final ValueChanged<bool>? loadSucessful;

  const AdmobWidget({
    Key? key,
    required this.adUnitId,
    required this.size,
    this.loadingWidget,
    this.showError = true,
    this.loadSucessful,
  }) : super(key: key);

  @override
  _AdmobWidgetState createState() => _AdmobWidgetState();
}

class _AdmobWidgetState extends State<AdmobWidget> {
  late BannerAd _bannerAd;

  bool _loading = true;
  bool _hasError = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    debugPrint('MobileAdmob loading...');
    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      size: widget.size,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('MobileAdmob loaded.');
          widget.loadSucessful?.call(true);
          setState(() => _loading = false);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('MobileAdmob failed to load: $error');
          _error = error.message;
          _hasError = true;
          widget.loadSucessful?.call(false);
          setState(() => _loading = false);
          ad.dispose();
        },
        onAdOpened: (Ad ad) => debugPrint('MobileAdmob opened.'),
        onAdClosed: (Ad ad) => debugPrint('MobileAdmob closed.'),
        onAdImpression: (Ad ad) => debugPrint('MobileAdmob impression.'),
        onAdWillDismissScreen: (Ad ad) {
          debugPrint('onAdWillDismissScreen');
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('MobileAdmob dispose');
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Container(
            alignment: Alignment.center,
            width: widget.size.width.toDouble(),
            height: widget.size.height.toDouble(),
            color: Theme.of(context).cardColor,
            child: widget.loadingWidget ?? const CircularProgressIndicator(),
          )
        : _hasError
            ? Container(
                alignment: Alignment.center,
                width: widget.size.width.toDouble(),
                height: widget.size.height.toDouble(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Theme.of(context).cardColor,
                child: Text(
                  widget.showError ? _error : '',
                  textAlign: TextAlign.center,
                ),
              )
            : Container(
                alignment: Alignment.center,
                width: widget.size.width.toDouble(),
                height: widget.size.height.toDouble(),
                color: Theme.of(context).cardColor,
                child: AdWidget(ad: _bannerAd),
              );
  }
}
