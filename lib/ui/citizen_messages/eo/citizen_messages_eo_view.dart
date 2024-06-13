import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/citizen_messages/eo/subview/eo_completed_view_citizen_messages.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';


class CitizenMessagesActivityEO extends StatefulWidget {
  const CitizenMessagesActivityEO({Key? key}) : super(key: key);

  @override
  State<CitizenMessagesActivityEO> createState() =>
      _CitizenMessagesActivityStateEO();
}

class _CitizenMessagesActivityStateEO extends BaseFullState<CitizenMessagesActivityEO> {
  int selectedTab = 0;

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("citizens_messages")),
          backgroundColor: Color(ColorProvider.colorPrimary),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  getTranlateString("completed_verfication_enquiry")
                      .toUpperCase(),
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
    return const EOCompletedFragmentCitizenMessages();
  }
}
