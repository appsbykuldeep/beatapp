import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/common_list_item.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/character_certificate/constable/subview/completed_view_character_cons.dart';
import 'package:beatapp/ui/character_certificate/constable/subview/pending_view_character_cons.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';


class CharacterVerificationConsActivity extends StatefulWidget {
  final data;

  const CharacterVerificationConsActivity({Key? key, this.data})
      : super(key: key);

  @override
  State<CharacterVerificationConsActivity> createState() =>
      _CharacterVerificationConsActivityState();
}

class _CharacterVerificationConsActivityState extends BaseFullState<CharacterVerificationConsActivity> {
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
        title: Text(getTranlateString("character_certificate")),
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
                    value: stateChanger.dashCounts.PendingCharacterCertificate.toString(),
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
                        )).then((value) async{

                    });
                  },
                  child: TotalPendingCompletedItem(
                    title: "COMPLETED",
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
      return const PendingFragmentCharacterCons();
    } else if (selectedTab == 1) {
      return const CompletedFragmentCharacterCons();
    }
  }
}
