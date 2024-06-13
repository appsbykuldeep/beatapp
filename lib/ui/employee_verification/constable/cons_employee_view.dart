import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/common_list_item.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/employee_verification/constable/subview/cons_completed_view_employee.dart';
import 'package:beatapp/ui/employee_verification/constable/subview/cons_pending_view_employee.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';


class ConsEmployeeActivity extends StatefulWidget {
  final data;

  const ConsEmployeeActivity({Key? key, this.data}) : super(key: key);

  @override
  State<ConsEmployeeActivity> createState() => _ConsEmployeeActivityState();
}

class _ConsEmployeeActivityState extends BaseFullState<ConsEmployeeActivity> {
  int selectedTab = 0;

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("employee_verification")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListenableBuilder(
          listenable: stateChanger,
          builder:(context,child)=> Column(
              children: [
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
                    title: "PENDING",
                    value: stateChanger.dashCounts.PendingEmployeeList.toString(),
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
                    title: "Completed",
                    value: stateChanger.dashCounts.CompletedEmployeeList.toString(),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  getTabs(){
    return TabBar(
      tabs: [
        Tab(
          child: Text(
            getTranlateString("pending").toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyleProvider.tabLayout_TextStyle(),
          ),
        ),
        Tab(
          child: Text(
            getTranlateString("completed").toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyleProvider.tabLayout_TextStyle(),
          ),
        )
      ],
      indicatorColor: Colors.red,
      onTap: (value) {
        selectedTab = value;
        setState(() {});
      },
    );
  }

  dynamic getSelectedView() {
    if (selectedTab == 0) {
      return const ConsPendingFragmentEmployee();
    } else if (selectedTab == 1) {
      return const ConsCompletedFragmentEmployee();
    }
  }
}
