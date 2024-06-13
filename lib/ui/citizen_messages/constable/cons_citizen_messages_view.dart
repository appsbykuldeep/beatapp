import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/citizen_messages/constable/subview/cons_completed_view_citizen_messages.dart';
import 'package:beatapp/ui/citizen_messages/constable/subview/cons_pending_view_citizen_messages.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class ConsCitizenMessagesActivity extends StatefulWidget {
  final data;

  const ConsCitizenMessagesActivity({Key? key, this.data}) : super(key: key);

  @override
  State<ConsCitizenMessagesActivity> createState() =>
      _ConsCitizenMessagesActivityState();
}

class _ConsCitizenMessagesActivityState
    extends State<ConsCitizenMessagesActivity> {
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
      length: 2,
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
      return const ConsPendingFragmentCitizenMessages();
    } else if (selectedTab == 1) {
      return const ConsCompletedFragmentCitizenMessages();
    }
  }
}
