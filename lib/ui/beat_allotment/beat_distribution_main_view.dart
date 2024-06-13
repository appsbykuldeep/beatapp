import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/beat_allotment/subview/beat_allotment_view.dart';
import 'package:beatapp/ui/beat_allotment/subview/beat_list_view.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';


class BeatDistributionMainActivity extends StatefulWidget {
  final data;
  const BeatDistributionMainActivity({Key? key,this.data}) : super(key: key);

  @override
  State<BeatDistributionMainActivity> createState() =>
      _BeatDistributionMainActivityState();
}

class _BeatDistributionMainActivityState
    extends State<BeatDistributionMainActivity> {
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
          title: Text(getTranlateString("beat_allotment")),
          backgroundColor: Color(ColorProvider.colorPrimary),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  getTranlateString("beat_allotment").toUpperCase(),
                ),
              ),
              Tab(
                  child:
                      Text(getTranlateString("allotment_list").toUpperCase())),
            ],
            indicatorColor: Colors.red,
            onTap: (value) {
              selectedTab = value;
              setState(() {});
            },
          ),
        ),
        body: selectedTab == 0 ? const BeatAllotmentFragment() : const BeatListFragment(),
      ),
    );
  }
}
