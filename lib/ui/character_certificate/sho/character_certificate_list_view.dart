import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/common_list_item.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/character_certificate/sho/sub_view/completed_character_list_view.dart';
import 'package:beatapp/ui/character_certificate/sho/sub_view/pending_character_certificate_list_tabview.dart';
import 'package:beatapp/ui/character_certificate/sho/sub_view/sho_completed_character_list_tabview.dart';
import 'package:beatapp/ui/character_certificate/sho/sub_view/unassigned_character_certificate_list_tabview.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class CharacterCertificateListActivity extends StatefulWidget {
  final data;

  const CharacterCertificateListActivity({Key? key, this.data})
      : super(key: key);

  @override
  State<CharacterCertificateListActivity> createState() =>
      _CharacterCertificateListActivityState();
}

class _CharacterCertificateListActivityState
    extends BaseFullState<CharacterCertificateListActivity> {
  int selectedTab = 0;

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("character_certificate")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListenableBuilder(
          listenable: stateChanger,
          builder:(context,child) =>Column(
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
                    value: stateChanger.dashCounts.TotalCharacterCertificateList.toString(),
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
                  child:TotalPendingCompletedItem(
                    title: "PENDING",
                    value: stateChanger.dashCounts.PendingCharacterCertificate.toString(),
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
                    value: stateChanger.dashCounts.EnquiryCompletedCharacterCertificate.toString(),
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
                  child:TotalPendingCompletedItem(
                    title: "ACCEPTED",
                    value: stateChanger.dashCounts.CompletedCharacterCertificate.toString(),
                  ),
                ),
              ]),
        ),
      ),
    );
  }


  dynamic getSelectedView() {
    if (selectedTab == 0) {
      return const UnassignedCharacterCertificateListFragment();
    } else if (selectedTab == 1) {
      return const PendingCharacterCertificateListFragment();
    } else if (selectedTab == 2) {
      return const CompletedCharacterListFragment();
    } else {
      return const ShoCompletedCharacterListFragment();
    }
  }
}
