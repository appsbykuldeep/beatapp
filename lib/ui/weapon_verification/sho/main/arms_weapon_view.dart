import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/license_weapon_list_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/weapon_verification/sho/main/arms_weapon_delete_view.dart';
import 'package:beatapp/ui/weapon_verification/sho/main/arms_weapon_detail_view.dart';
import 'package:beatapp/ui/weapon_verification/sho/main/arms_weapon_edit_view.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class ArmsWeaponViewActivity extends StatefulWidget {
  const ArmsWeaponViewActivity({Key? key}) : super(key: key);

  @override
  State<ArmsWeaponViewActivity> createState() => _ArmsWeaponViewActivityState();
}

class _ArmsWeaponViewActivityState extends State<ArmsWeaponViewActivity> {
  late List<LicenseWeaponListResponse> lstArms = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      _getArmsList();
    });
  }

  void _getArmsList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_SHO_ARMS_WPN_LIST, data, true);
    if (response.statusCode == 200) {
      lstArms = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var office = LicenseWeaponListResponse.fromJson(i);
          lstArms.add(office);
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("arms_weapon")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Container(
          alignment: Alignment.topCenter,
          child: Column(children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
              child: CustomView.getCountView(context, lstArms.length),
            ),
            SizedBox(
              height: 50,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: ColorProvider.redColor,
                          height: 5,
                          width: double.maxFinite,
                        ),
                        Container(
                          color: ColorProvider.blueColor,
                          height: 5,
                          width: double.maxFinite,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            getTranlateString("beat"),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            getTranlateString("village_street"),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            getTranlateString("license_holder_name"),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            getTranlateString("weapon_type"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            lstArms.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(2),
                        itemCount: lstArms.length,
                        itemBuilder: (BuildContext context, int index) {
                          return getRowForConst(index);
                        }))
                : CustomView.getNoRecordView(context),
          ])),
      bottomNavigationBar: InkWell(
        onTap: () {
          LicenseWeaponListResponse.generateExcel(context, lstArms);
        },
        child: Container(
          height: 50,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.file_download_outlined),
              Text(getTranlateString("download").toUpperCase())
            ],
          ),
        ),
      ),
    );
  }

  Widget getRowForConst(int index) {
    var data = lstArms[index];
    return InkWell(
        onTap: () async {
          showOptionDialog(data);
        },
        child: Container(
            padding: const EdgeInsets.only(left: 4, right: 4),
            color: index % 2 == 0
                ? ColorProvider.redColor.withOpacity(0.05)
                : ColorProvider.blueColor.withOpacity(0.05),
            constraints: const BoxConstraints(minHeight: 40),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    data.bEATNAME,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    data.vILLSTREETNAME ?? "",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      data.lISCENSEHOLDERNAME ?? "",
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    data.WEAPON ?? "",
                  ),
                ),
              ],
            )));
  }

  showOptionDialog(data) {
    // set up the AlertDialog
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      bool result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArmsWeaponDetailActivity(
                                data: {"WEAPON_SR_NUM": data.SR_NUM}),
                          ));
                      if (result) {
                        _getArmsList();
                      }
                    },
                    child: const Text(
                      "Show Details",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      bool result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArmsWeaponEditActivity(
                                data: {"WEAPON_SR_NUM": data.SR_NUM})),
                      );
                      if (result) {
                        _getArmsList();
                      }
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      bool result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArmsWeaponDeleteActivity(
                              data: {"WEAPON_SR_NUM": data.SR_NUM},
                            ),
                          ));
                      if (result) {
                        _getArmsList();
                      }
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
