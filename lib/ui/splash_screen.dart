import 'dart:async';
import 'dart:io';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/call_api.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/version_response.dart';
import 'package:beatapp/preferences/constraints.dart';
import 'package:beatapp/preferences/preference_util.dart';
import 'package:beatapp/ui/dashboard/dashboard.dart';
import 'package:beatapp/ui/dashboard/user_office_view.dart';
import 'package:beatapp/ui/login/login_view.dart';
import 'package:beatapp/utility/build_utils.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      checkRoute(1);
    });
  }

  void getVersionData() async {
    BuildDetails details = await BuildUtils.getappBuild();
    Response response =
        await getVersion(endPoint: EndPoints.END_POINT_GET_VERSION);
    print(response.body);
    if (response.statusCode == 200) {
      List<VersionResponse> versionResponse =
          versionResponseFromJson(response.body);
      if (versionResponse.isNotEmpty) {
        if (double.parse(versionResponse[0].releaseVersion) >
            double.parse(details.version.substring(0, 1))) {
          showNewBuildDialog(context);
        } else {
          checkRoute(1);
        }
      } else {
        checkRoute(1);
      }
    } else {
      checkRoute(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              20.height,
              Text(
                "Prahari (Beat Policing)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorProvider.transparent_black,
                  fontSize: SizeProvider.size_24,
                ),
              ),
              25.height,
              Image.asset(
                "assets/images/ic_launcher.png",
                height: SizeProvider.size_150,
                width: SizeProvider.size_150,
              ),
              20.height,
              const CircularProgressIndicator(
                color: Colors.red,
              )
            ],
          ),
        ));
  }

  void checkRoute(int from) async {
    Timer(
        from == 1
            ? const Duration(seconds: 3)
            : const Duration(milliseconds: 50), () async {
      bool isLogin = await PreferenceHelper().getBool(Constraints.IS_LOGIN);
      if (isLogin) {
        await AppUser.setByLocalStorage();
        String role = AppUser.ROLE_CD;
        if (role.split(",").length == 1) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const UserOfficeView(),
              ),
              (route) => false);
        }
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
            (route) => false);
      }
    });
  }

  showNewBuildDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(AppTranslations.of(context)!.text("Ignore")),
      onPressed: () {
        checkRoute(2);
      },
    );
    Widget continueButton = TextButton(
      child: Text(AppTranslations.of(context)!.text("Update Now")),
      onPressed: () {
        if (Platform.isAndroid || Platform.isIOS) {
          final appId =
              Platform.isAndroid ? 'up.pts.beatapp' : 'up.pts.beatapp';
          final url = Uri.parse(
            Platform.isAndroid
                ? "https://play.google.com/store/apps/details?id=$appId"
                : "https://apps.apple.com/app/id$appId",
          );
          launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(AppTranslations.of(context)!.text("update")),
      content: Text(AppTranslations.of(context)!.text("update_message")),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
