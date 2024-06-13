import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/citizen_messages/sho/subview/completed_view_citizen_messages.dart';
import 'package:beatapp/ui/citizen_messages/sho/subview/pending_view_citizen_messages.dart';
import 'package:beatapp/ui/citizen_messages/sho/subview/sho_completed_view_citizen_messages.dart';
import 'package:beatapp/ui/citizen_messages/sho/subview/unassigned_view_citizen_messages.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class CitizenMessagesSHOActivity extends StatefulWidget {
  final data;

  const CitizenMessagesSHOActivity({Key? key, this.data}) : super(key: key);

  @override
  State<CitizenMessagesSHOActivity> createState() =>
      _CitizenMessagesSHOActivityState();
}

class _CitizenMessagesSHOActivityState extends State<CitizenMessagesSHOActivity> {
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
      length: 4,
      child: Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("citizens_messages")),
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
              Tab(
                child: Text(
                  getTranlateString("pending").toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyleProvider.tabLayout_TextStyle(),
                ),
              ),
              Tab(
                child: Text(
                  getTranlateString("enquiry_completed").toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyleProvider.tabLayout_TextStyle(),
                ),),
              Tab(
                child: Text(
                  getTranlateString("accepted").toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyleProvider.tabLayout_TextStyle(),
                ),)
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
      return const UnassignedFragmentCitizenMessages();
    } else if (selectedTab == 1) {
      return const PendingFragmentCitizenMessages();
    } else if (selectedTab == 2) {
      return const CompletedFragmentCitizenMessages();
    } else {
      return const ShoCompletedFragmentCitizenMessages();
    }
  }
}
