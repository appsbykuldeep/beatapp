import 'package:beatapp/ui/report/area/area_report_view.dart';
import 'package:beatapp/ui/report/beat_area_allotment/beat_area_report_view.dart';
import 'package:beatapp/ui/report/citizen_services/pending_report_view.dart';
import 'package:beatapp/ui/report/history_sheeters/history_sheeter_report_view.dart';
import 'package:beatapp/ui/report/village/village_report_view.dart';
import 'package:beatapp/ui/report/weapon/arms_and_weapon_report_view.dart';
import 'package:flutter/material.dart';

import '../../localization/app_translations.dart';
import '../../utility/resource_provider.dart';

class ReportActivity extends StatefulWidget {
  final data;

  const ReportActivity({Key? key, this.data}) : super(key: key);

  @override
  State<ReportActivity> createState() => _ReportActivityState();
}

class _ReportActivityState extends State<ReportActivity> {
  final _dashboard = _getDashboardMenu();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3.0;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(AppTranslations.of(context)!.text("report")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 2.0,
          childAspectRatio: (itemWidth / itemHeight),
          children: List.generate(_dashboard.length, (index) {
            return Center(
              child: selectCard(_dashboard[index]),
            );
          })),
    );
  }

  Widget selectCard(choiceRep) {
    return InkWell(
        onTap: () {
          openView(choiceRep.id);
        },
        child: Container(
            margin: const EdgeInsets.only(top: 3),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
//BoxShadow
                ]),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      choiceRep.icon,
                      height: 60,
                      width: 60,
                    ),
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.only(top: 7),
                      child: Text(
                        AppTranslations.of(context)!.text(choiceRep.title),
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ]),
            )));
  }

  void openView(int id) {
    StatefulWidget? page;
    if (id == 1) {
      page = const HistorySheeterReportActivity();
    } else if (id == 2) {
      page = const ArmsAndWeaponReportActivity();
    } else if (id == 3) {
      page = const VillageReportActivity();
    } else if (id == 4) {
      page = const AreaReportActivity();
    } else if (id == 5) {
      page = const BeatAreaReportActivity();
    } else if (id == 6) {
      page = const PendingReportActivity();
    } else {
      page = null;
    }
    if (page == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page!),
    );
  }
}

class ChoiceRep {
  const ChoiceRep({required this.id, required this.title, required this.icon});

  final String title;
  final String icon;
  final int id;
}

List<ChoiceRep> _getDashboardMenu() {
  return const <ChoiceRep>[
    ChoiceRep(id: 1, title: "history_sheeters", icon: "assets/images/list.png"),
    ChoiceRep(
        id: 2,
        title: "arms_weapon_verification",
        icon: "assets/images/weapon_verification.png"),
    ChoiceRep(
        id: 3, title: "village_street", icon: "assets/images/ic_location.png"),
    ChoiceRep(id: 4, title: "area", icon: "assets/images/ic_location.png"),
    ChoiceRep(
        id: 5,
        title: "beat_area_allotment_report",
        icon: "assets/images/ic_beat_assignment.png"),
    ChoiceRep(
        id: 6,
        title: "pending_citizen_services",
        icon: "assets/images/pending_reports.png"),
  ];
}
