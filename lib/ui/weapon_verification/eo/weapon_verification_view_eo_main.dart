import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/common_list_item.dart';
import 'package:beatapp/ui/weapon_verification/eo/subview/pending_view_arms.dart';
import 'package:beatapp/ui/weapon_verification/eo/subview/completed_view_arms.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class WeaponVerificationActivityEOMain extends StatefulWidget {
   const WeaponVerificationActivityEOMain({Key? key}) : super(key: key);

  @override
  State<WeaponVerificationActivityEOMain> createState() => _WeaponVerificationActivityEOMainState();
}

class _WeaponVerificationActivityEOMainState extends BaseFullState<WeaponVerificationActivityEOMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: const Text("Arms and Weapon Verification"),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child:ListenableBuilder(
          listenable: stateChanger,
          builder:(context,child)=> Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PendingFragmentArms(),
                        ));
                  },
                  child: TotalPendingCompletedItem(
                    title: "Pending Verification",
                    value: stateChanger.dashCounts.PendingHistorySheeter.toString(),
                  ),
                ),
                12.height,
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompletedFragmentArms(),
                        ));
                  },
                  child: TotalPendingCompletedItem(
                    title: "VERIFICATION ENQUIRY\nCOMPLETED",
                    value:stateChanger.dashCounts.EnquiryCompletedArms_Weapons.toString(),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
