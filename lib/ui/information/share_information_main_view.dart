import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/information/share/subview/share_information_view.dart';
import 'package:beatapp/ui/information/share/subview/view_shared_information_view.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class ShareInformationActivity extends StatefulWidget {
  final data;

  const ShareInformationActivity({Key? key, this.data}) : super(key: key);

  @override
  State<ShareInformationActivity> createState() =>
      _ShareInformationActivityState(data);
}

class _ShareInformationActivityState extends State<ShareInformationActivity> {
  int selectedTab = 0;

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  String role = "0";

  _ShareInformationActivityState(data) {
    role = data["role"];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("shared_information")),
          backgroundColor: Color(ColorProvider.colorPrimary),
          bottom: getTab(),
        ),
        body: getBody(),
      ),
    );
  }

  dynamic getTab() {
    if (role == "23") {
      return TabBar(
        tabs: [
          Tab(
            child: Text(
              getTranlateString("share_information").toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyleProvider.tabLayout_TextStyle(),
            ),
          ),
          Tab(
              child: Text(
            getTranlateString("view_shared_info").toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyleProvider.tabLayout_TextStyle(),
          )),
        ],
        indicatorColor: Colors.red,
        onTap: (value) {
          selectedTab = value;
          setState(() {});
        },
      );
    } else {
      return null;
    }
  }

  dynamic getBody() {
    if (role == "23") {
      return selectedTab == 0
          ? const ShareInformationFragment()
          : ViewSharedInformationFragment(data: {"role": role});
    } else {
      return ViewSharedInformationFragment(data: {"role": role});
    }
  }
}
