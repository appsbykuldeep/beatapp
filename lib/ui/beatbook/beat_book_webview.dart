import 'dart:async';

import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/utility/loaction_utils.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BeatBookWebActivtiy extends StatefulWidget {
  const BeatBookWebActivtiy({Key? key}) : super(key: key);

  @override
  State<BeatBookWebActivtiy> createState() => _BeatBookWebActivtiyState();
}

class _BeatBookWebActivtiyState extends State<BeatBookWebActivtiy> {
  late final WebViewController controller;
  bool isLoading = true;
  final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
      timeLimit: Duration(seconds: 10));
  @override
  void initState() {
    super.initState();
    initializeController();
  }

  pageLoaded() {
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      print("location $position");
      if (position != null) {
        controller.runJavaScript(
            "sessionStorage.setItem('latitude', '${position.latitude}');");
        controller.runJavaScript(
            "sessionStorage.setItem('longitude', '${position.longitude}');");

        controller
            .runJavaScriptReturningResult(
          "sessionStorage.getItem('latitude');",
        )
            .then((result) {
          print("updated Loc $result");
        });
      }
    });
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  initializeController() async {
    var role = AppUser.ROLE_CD;
    var position = await LocationUtils().determinePosition();
    var userData = await LoginResponseModel.fromPreference();
    print(
        'http://122.176.71.134/BeatBook?RoleId=$role&LoginId=${userData.mobile1}&PS_Code=${userData.psCd}&District_CD=${userData.districtCD}&Auth_Key=${userData.accessToken}&CUG_Number=${userData.mobile1}&LAT=${position.latitude}&LONG=${position.longitude}');
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            isLoading = true;
            setState(() {});
          },
          onPageFinished: (String url) async {
            isLoading = false;
            setState(() {});
            pageLoaded();
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(
          'http://122.176.71.134/BeatBook?RoleId=$role&LoginId=${userData.mobile1}&PS_Code=${userData.psCd}&District_CD=${userData.districtCD}&Auth_Key=${userData.accessToken}&CUG_Number=${userData.mobile1}&LAT=${position.latitude}&LONG=${position.longitude}'));
  }

  Future<bool> _onWillPop() async {
    return true;
    /*if (await controller!.canGoBack()) {
      controller!.goBack();
      return false;
    } else {
      return true;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Color(ColorProvider.color_window_bg),
            appBar: AppBar(
              title: Text(getTranlateString("BeatBook")),
              backgroundColor: Color(ColorProvider.colorPrimary),
            ),
            body: Container(
              alignment: Alignment.center,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.red,
                    )
                  : WebViewWidget(
                      controller: controller,
                    ),
            )));
  }
}
