import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/common_list_item.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/tenant/constable/subview/cons_completed_view_tenant.dart';
import 'package:beatapp/ui/tenant/constable/subview/cons_pending_view_tenant.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class ConsTenantActivity extends StatefulWidget {
  final data;
   const ConsTenantActivity({Key? key, this.data}) : super(key: key);

  @override
  State<ConsTenantActivity> createState() => _ConsTenantActivityState();
}

class _ConsTenantActivityState extends BaseFullState<ConsTenantActivity> {
  int selectedTab = 0;

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("tenant_verification")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListenableBuilder(
          listenable: stateChanger,
          builder:(context,child)=> Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    value: stateChanger.dashCounts.PendingTENANT.toString(),
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
                    title: "COMPLETED",
                    value: stateChanger.dashCounts.CompletedTENANT.toString(),
                  ),
                ),
              ]),
        ),
      ),
    );
  }


  dynamic getSelectedView() {
    if (selectedTab == 0) {
      return const ConsPendingFragmentTenant();
    } else if (selectedTab == 1) {
      return const ConsCompletedFragmentTenant();
    }
  }
}
