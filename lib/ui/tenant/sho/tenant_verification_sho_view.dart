import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/common_list_item.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/tenant/sho/subview/completed_view_tenant.dart';
import 'package:beatapp/ui/tenant/sho/subview/pending_view_tenant.dart';
import 'package:beatapp/ui/tenant/sho/subview/sho_completed_view_tenant.dart';
import 'package:beatapp/ui/tenant/sho/subview/unassigned_view_tenant.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class TenantVerificationSHOActivity extends StatefulWidget {
  final data;

  const TenantVerificationSHOActivity({Key? key, this.data}) : super(key: key);

  @override
  State<TenantVerificationSHOActivity> createState() =>
      _TenantVerificationSHOActivityState();
}

class _TenantVerificationSHOActivityState extends BaseFullState<TenantVerificationSHOActivity> {
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
                    title: "TOTAL LIST",
                    value: stateChanger.dashCounts.TotalTENANTList.toString(),
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
                    title: "PENDING",
                    value: stateChanger.dashCounts.PendingTENANT.toString(),
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
                    title: "ENQUIRY COMPLETED",
                    value: stateChanger.dashCounts.TotalEnquiryCompletedTENANT.toString(),
                  ),
                ),
                12.height,
                InkWell(
                  onTap: () {
                    selectedTab = 3;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => getSelectedView(),
                        ));
                  },
                  child: TotalPendingCompletedItem(
                    title: "ACCEPTED",
                    value: stateChanger.dashCounts.CompletedTENANT.toString(),
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
          ),),
        Tab(
          child: Text(
            getTranlateString("accepted").toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyleProvider.tabLayout_TextStyle(),
          ),)
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
      return const UnassignedFragmentTenant();
    } else if (selectedTab == 1) {
      return const PendingFragmentTenant();
    } else if (selectedTab == 2) {
      return const CompletedFragmentTenant();
    } else {
      return const ShoCompletedFragmentTenant();
    }
  }
}
