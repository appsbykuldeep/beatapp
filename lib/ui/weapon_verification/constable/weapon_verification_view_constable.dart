import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/common_list_item.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/weapon_verification/constable/subview/cons_completed_view_arms.dart';
import 'package:beatapp/ui/weapon_verification/constable/subview/cons_pending_view_arms.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';



class WeaponVerificationActivityConstable extends StatefulWidget {
  final data;

  const WeaponVerificationActivityConstable({Key? key, this.data})
      : super(key: key);

  @override
  State<WeaponVerificationActivityConstable> createState() =>
      _WeaponVerificationActivityConstableState();
}

class _WeaponVerificationActivityConstableState extends BaseFullState<WeaponVerificationActivityConstable> {
  int selectedTab = 0;

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("arms_weapon_verification")),
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
                    value: stateChanger.dashCounts.TotalArms_Weapons.toString(),
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
                    title: "VERIFICATION ENQUIRY\nCOMPLETED",
                    value: stateChanger.dashCounts.EnquiryCompletedArms_Weapons.toString(),
                  ),
                ),
              ]),
        ),
      )
    );
  }


  dynamic getSelectedView() {
    if (selectedTab == 0) {
      return const ConsPendingFragmentArms();
    } else if (selectedTab == 1) {
      return const ConsCompletedFragmentArms();
    }
  }
}
