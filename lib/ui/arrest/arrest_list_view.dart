import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/common_list_item.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/arrest/sub_view/assigned_arrest_list_view.dart';
import 'package:beatapp/ui/arrest/sub_view/completed_arrest_list_view.dart';
import 'package:beatapp/ui/arrest/sub_view/pending_arrest_list_view.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';


class ArrestListActivity extends StatefulWidget {
  final data;
  const ArrestListActivity({Key? key,this.data}) : super(key: key);

  @override
  State<ArrestListActivity> createState() => _ArrestListActivityState(data);
}

class _ArrestListActivityState extends BaseFullState<ArrestListActivity> {
  int selectedTab = 0;

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  String role = "0";

  _ArrestListActivityState(data) {
    role = data["role"];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: const Text("Wanted Criminals"),
        backgroundColor: Color(ColorProvider.colorPrimary),
        //bottom: getTabs(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListenableBuilder(
          listenable: stateChanger,
          builder:(context,child)=> Column(
            children: [
              if (role == "2")
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
                    title: "WANTED CRIMINALS",
                    value: role == "2"?stateChanger.dashCounts.TotalWantedCriminals.toString():stateChanger.dashCounts.CompletedWantedCriminals.toString(),
                  ),
                ),


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
                  title: "ASSIGNED CRIMINALS",
                  value: role == "2"?stateChanger.dashCounts.TotalPendingWantedCriminals.toString():stateChanger.dashCounts.PendingWantedCriminals.toString(),
                ),
              ),
              12.height,
              InkWell(
                onTap: () {
                  selectedTab = 2;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => getSelectedView(),
                      ));
                },
                child: TotalPendingCompletedItem(
                  title: "ARRESTED CRIMINALS",
                  value: role == "2"?stateChanger.dashCounts.TotalCompletedWantedCriminals.toString(): stateChanger.dashCounts.CompletedWantedCriminals.toString(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  dynamic getSelectedView() {
    if (role == "23") {
      if (selectedTab == 1) {
        return AssignedArrestListFragment(
          data: {"role": role},
        );
      } else {
        return CompletedArrestListFragment(
          data: {"role": role},
        );
      }
    } else {
      if (selectedTab == 0) {
        return const PendingArrestListFragment();
      } else if (selectedTab == 1) {
        return AssignedArrestListFragment(
          data: {"role": role},
        );
      } else {
        return CompletedArrestListFragment(data: {"role": role});
      }
    }
  }
}
