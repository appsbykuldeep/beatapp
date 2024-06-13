import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/information/important/subview/save_important_information_view.dart';
import 'package:beatapp/ui/information/important/subview/view_information_list_view.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';


class ImportantInformationActivity extends StatefulWidget {
  final data;

  const ImportantInformationActivity({Key? key, this.data}) : super(key: key);

  @override
  State<ImportantInformationActivity> createState() =>
      _ImportantInformationActivityState(data);
}

class _ImportantInformationActivityState
    extends State<ImportantInformationActivity> {
  int selectedTab = 0;

  String role = "0";

  _ImportantInformationActivityState(data) {
    role = data["role"];
  }

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
      length: 2,
      child: Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("important_information")),
          backgroundColor: Color(ColorProvider.colorPrimary),
          bottom: getTabs(),
        ),
        body: getBody(),
      ),
    );
  }

  dynamic getTabs() {
    if (role == "23") {
      return null;
    } else {
      return TabBar(
        tabs: [
          Tab(
            child: Text(
              getTranlateString("important_information").toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyleProvider.tabLayout_TextStyle(),
            ),
          ),
          Tab(
              child: Text(
            getTranlateString("view_important_info").toUpperCase(),
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
    }
  }

  dynamic getBody() {
    if (role == "23") {
      return const ViewInformationListFragment();
    } else {
      return selectedTab == 0
          ? const SaveImportantInformationFragment()
          : const ViewInformationListFragment();
    }
  }
}
