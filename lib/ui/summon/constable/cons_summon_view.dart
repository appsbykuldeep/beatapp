import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/common_list_item.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/summon/constable/subview/cons_completed_view_summon.dart';
import 'package:beatapp/ui/summon/constable/subview/cons_pending_view_summon.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class ConsSummonActivity extends StatefulWidget {
  final Map<String, String?> data;

  /// 1 for summon 2 for warrant
  final int SUMM_WARR_NATURE;

  const ConsSummonActivity({
    Key? key,
    required this.data,
    required this.SUMM_WARR_NATURE,
  }) : super(key: key);

  @override
  State<ConsSummonActivity> createState() => _ConsSummonActivityState();
}

class _ConsSummonActivityState extends BaseFullState<ConsSummonActivity> {
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
          title: Text(getTranlateString(title)),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListenableBuilder(
            listenable: stateChanger,
            builder: (context, child) => Column(children: [
              InkWell(
                onTap: () {
                  selectedTab = 0;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => getSelectedView(),
                      ));
                },
                child: TotalPendingCompletedItem(
                  title: AppTranslations.of(context)!
                      .text(getTranlateString("list").toUpperCase()),
                  value: title == "summon"
                      ? stateChanger.dashCounts.CompletedSummonList.toString()
                      : stateChanger.dashCounts.CompletedWarrantList.toString(),
                ),
              ),
              12.height,
              InkWell(
                onTap: () {
                  selectedTab = 1;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => getSelectedView(),
                      ));
                },
                child: TotalPendingCompletedItem(
                  title: AppTranslations.of(context)!
                      .text(getTranlateString("pending").toUpperCase()),
                  value: title == "summon"
                      ? stateChanger.dashCounts.PendingSummonList.toString()
                      : stateChanger.dashCounts.PendingWarrantList.toString(),
                ),
              ),
            ]),
          ),
        ));
  }

  dynamic getSelectedView() {
    if (selectedTab == 0) {
      return ConsCompletedFragment_Summon(
        data: {"title": title},
        SUMM_WARR_NATURE: widget.SUMM_WARR_NATURE,
      );
    }

    if (selectedTab == 1) {
      return ConsPendingFragment_Summon(
        data: {"title": title},
        SUMM_WARR_NATURE: widget.SUMM_WARR_NATURE,
      );
    }
  }
}
