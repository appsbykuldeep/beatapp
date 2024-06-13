import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/common_list_item.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/domestic_verification/sho/subview/completed_view_domestic.dart';
import 'package:beatapp/ui/domestic_verification/sho/subview/pending_view_domestic.dart';
import 'package:beatapp/ui/domestic_verification/sho/subview/sho_completed_view_domestic.dart';
import 'package:beatapp/ui/domestic_verification/sho/subview/unassigned_view_domestic.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';


class DomesticVerificationSHOActivity extends StatefulWidget {
  final data;

  const DomesticVerificationSHOActivity({Key? key, this.data})
      : super(key: key);

  @override
  State<DomesticVerificationSHOActivity> createState() =>
      _DomesticVerificationSHOActivityState();
}

class _DomesticVerificationSHOActivityState extends BaseFullState<DomesticVerificationSHOActivity> {
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
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("domestic_help_verification")),
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
                    value: stateChanger.dashCounts.TotalDomesticHelpList.toString(),
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
                    value:stateChanger.dashCounts.PendingDomesticHelp.toString(),
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
                    value: stateChanger.dashCounts.EnquiryCompleteDeomesticList.toString(),
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
                    value: stateChanger.dashCounts.CompletedDomesticHelp.toString(),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  dynamic getSelectedView() {
    if (selectedTab == 0) {
      return const UnassignedFragmentDomestic();
    } else if (selectedTab == 1) {
      return const PendingFragmentDomestic();
    } else if (selectedTab == 2) {
      return const CompletedFragmentDomestic();
    } else {
      return const ShoCompletedFragmentDomestic();
    }
  }
}
