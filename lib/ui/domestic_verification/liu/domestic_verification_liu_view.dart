import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class DomesticVerificationLIUActivity extends StatefulWidget {
  const DomesticVerificationLIUActivity({Key? key}) : super(key: key);

  @override
  State<DomesticVerificationLIUActivity> createState() =>
      _DomesticVerificationLIUActivityState();
}

class _DomesticVerificationLIUActivityState
    extends State<DomesticVerificationLIUActivity> {
  int selectedTab = 0;

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("domestic_help_verification")),
          backgroundColor: Color(ColorProvider.colorPrimary),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  getTranlateString("pending").toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyleProvider.tabLayout_TextStyle(),
                ),
              ),
            ],
            indicatorColor: Colors.red,
            onTap: (value) {
              selectedTab = value;
              setState(() {});
            },
          ),
        ),
        body: getSelectedView(),
      ),
    );
  }

  dynamic getSelectedView() {
    if (selectedTab == 0) {
    } else if (selectedTab == 1) {
    } else {}
  }
}
