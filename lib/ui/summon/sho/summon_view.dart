import 'package:beatapp/custom_view/common_list_item.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/summon/sho/subview/completed_view.dart';
import 'package:beatapp/ui/summon/sho/subview/pending_view.dart';
import 'package:beatapp/ui/summon/sho/subview/unassigned_view.dart';
import 'package:beatapp/utility/extentions/context_ext.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class SummonActivity extends StatefulWidget {
  final Map<String, String> data;

  const SummonActivity({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<SummonActivity> createState() => _SummonActivityState();
}

class _SummonActivityState extends State<SummonActivity> {
  int selectedTab = 0;
  String title = "";

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    title = widget.data["title"] ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(getTranlateString(title)),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(children: [
            InkWell(
              onTap: () {
                selectedTab = 0;
                context.push(getSelectedView());
              },
              child: const TotalPendingCompletedItem(
                title: "TOTAL LIST",
                value: "0",
              ),
            ),
            12.height,
            InkWell(
              onTap: () {
                selectedTab = 1;
                context.push(getSelectedView());
              },
              child: const TotalPendingCompletedItem(
                title: "PENDING",
                value: "0",
              ),
            ),
            12.height,
            InkWell(
              onTap: () {
                selectedTab = 2;
                context.push(getSelectedView());
              },
              child: const TotalPendingCompletedItem(
                title: "ENQUIRY COMPLETED",
                value: "0",
              ),
            )
          ]),
        ));

    /*DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString(title)),
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
    );*/
  }

  Widget getSelectedView() {
    if (selectedTab == 0) {
      return UnassignedFragment(
        data: {"title": title},
      );
    } else if (selectedTab == 1) {
      return PendingFragment(
        data: {"title": title},
      );
    } else {
      return CompletedFragment(
        data: {"title": title},
      );
    }
  }
}
