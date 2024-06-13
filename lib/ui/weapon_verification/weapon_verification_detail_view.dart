import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/response/weapon_beat_report_table.dart';
import 'package:beatapp/model/response/weapon_detail_table.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/navigator_utils.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class WeaponVerificationDetailActivity extends StatefulWidget {
  final data;

  const WeaponVerificationDetailActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<WeaponVerificationDetailActivity> createState() =>
      _WeaponVerificationDetailActivityState(data);
}

class _WeaponVerificationDetailActivityState
    extends State<WeaponVerificationDetailActivity> {
  var con_Details = TextEditingController();
  WeaponDetail_Table? _details;
  List<WeaponBeatReport_Table> lst_assignHistory = [];
  String role = "0";
  bool isImageLoaded = false;
  String WEAPON_SR_NUM = "";

  _WeaponVerificationDetailActivityState(data) {
    WEAPON_SR_NUM = data["WEAPON_SR_NUM"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    _getWeaponDetails();
    super.initState();
  }

  void _getWeaponDetails() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"WEAPON_SR_NUM": WEAPON_SR_NUM, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_LSCD_WPN_DETAILS, data, true);
    if (response.statusCode == 200) {
      try {
        _details = response.data["Table"].toList().length != 0
            ? WeaponDetail_Table.fromJson(response.data["Table"][0])
            : null;
        for (Map<String, dynamic> i in response.data["Table1"]) {
          var data = WeaponBeatReport_Table.fromJson(i);
          lst_assignHistory.add(data);
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  radioOnchange(value) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("arms_weapon")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: _details != null
            ? SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .96,
                        child: lst_assignHistory.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const RangeMaintainingScrollPhysics(),
                                itemCount: lst_assignHistory.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return getBeatView(index);
                                })
                            : CustomView.getNoRecordView(context),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("information_detail"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      CustomView.getHorizontalDevider(context),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("district"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            right: 5,
                            top: 8,
                            bottom: 8,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.dISTRICT ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("police_station"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            right: 5,
                            top: 8,
                            bottom: 8,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.pS ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("beat_name"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            right: 5,
                            top: 8,
                            bottom: 8,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details?.bEATNAME ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("village_street"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            right: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.vILLSTREETNAME ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("license_holder_name"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            right: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.lISCENSEHOLDERNAME ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("mobile_number"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            right: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.mOBILE ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("age"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            right: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.aGE ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("address"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            right: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.aDDRESS ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("weapon_details"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      CustomView.getHorizontalDevider(context),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("weapon_type"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            right: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.wEAPON ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("weapon_model"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            right: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.aRMSMODEL ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("weapon_license_number"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            right: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.aRMSLISCENSENO ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            getTranlateString("weapon_validity"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            right: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _details!.wEAPONEXPIRTDATE ?? "",
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox());
  }

  getBeatView(int index) {
    var beatData = lst_assignHistory[index];
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * .96,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(
          right: 5,
          left: 5,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.black, width: 1.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                        AppTranslations.of(context)!.text("beat_person_name"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.bEATCONSTABLENAME ?? ""),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(AppTranslations.of(context)!.text("date"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.fILLDT ?? ""),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      AppTranslations.of(context)!.text("completed"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.iSRESOLVED == "N" ? "No" : "Yes"),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      AppTranslations.of(context)!.text("verification"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.vARIFICATIONSTATUS ?? ""),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      AppTranslations.of(context)!.text("constable_remarks"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(beatData.rEMARKS ?? ""),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      AppTranslations.of(context)!.text("photo"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => {
                          /*NavigatorUtils
                                                      .launchMapsUrlFromLatLong(
                                                      double.parse(
                                                          _assignHistory!
                                                              .lat ??
                                                              "0"),
                                                      double.parse(
                                                          _assignHistory!
                                                              .lng ??
                                                              "0"))*/
                        },
                        splashColor: Colors.grey,
                        child: beatData.pHOTO != null
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageViewer(
                                          data: {"image": beatData.pHOTO},
                                        ),
                                      ));
                                },
                                child: Image.memory(
                                  Base64Helper.decodeBase64Image(
                                      beatData.pHOTO ?? ""),
                                  height: 80,
                                  width: 80,
                                ))
                            : Image.asset(
                                'assets/images/ic_image_placeholder.png',
                                height: 80,
                                width: 80,
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      AppTranslations.of(context)!.text("location"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => {
                          NavigatorUtils.launchMapsUrlFromLatLong(
                              double.parse(beatData.lAT ?? "0"),
                              double.parse(beatData.lONG ?? "0"))
                        },
                        splashColor: Colors.grey,
                        child: Image.asset(
                          'assets/images/ic_map.png',
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
