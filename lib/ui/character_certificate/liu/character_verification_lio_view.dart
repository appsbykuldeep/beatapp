import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';



class CharacterVerificationLIUActivity extends StatefulWidget {
  const CharacterVerificationLIUActivity({Key? key}) : super(key: key);

  @override
  State<CharacterVerificationLIUActivity> createState() =>
      _CharacterVerificationLIUActivityState();
}

class _CharacterVerificationLIUActivityState
    extends State<CharacterVerificationLIUActivity> {
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
          title: Text(getTranlateString("character_certificate")),
          backgroundColor: Color(ColorProvider.colorPrimary),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  getTranlateString("list").toUpperCase(),
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
