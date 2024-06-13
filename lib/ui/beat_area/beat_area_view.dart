import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/beat_area/subview/area_allotment_view.dart';
import 'package:beatapp/ui/beat_area/subview/area_creation_view.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';


class BeatAreaActivity extends StatefulWidget {
  final data;
  const BeatAreaActivity({Key? key,this.data}) : super(key: key);

  @override
  State<BeatAreaActivity> createState() => _BeatAreaActivityState();
}

class _BeatAreaActivityState extends BaseFullState<BeatAreaActivity> {
  int selectedTab = 0;

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("beat_area")),
          backgroundColor: Color(ColorProvider.colorPrimary),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  getTranlateString("area_fixation"),
                ),
              ),
              Tab(child: Text(getTranlateString("beat_area_fixation"))),
            ],
            indicatorColor: Colors.red,
            onTap: (value) {
              selectedTab = value;
              setState(() {});
            },
          ),
        ),
        body: selectedTab == 0
            ? const AreaCreation_fragment()
            : const AreaAllotment_fragment(),
      ),
    );
  }
}
