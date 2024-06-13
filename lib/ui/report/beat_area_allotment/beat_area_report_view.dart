import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/entities/police_station.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/beat_assignment_list_response.dart';
import 'package:beatapp/model/response/get_constable_details.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class BeatAreaReportActivity extends StatefulWidget {
  const BeatAreaReportActivity({Key? key}) : super(key: key);

  @override
  State<BeatAreaReportActivity> createState() => _BeatAreaReportActivityState();
}

class _BeatAreaReportActivityState extends State<BeatAreaReportActivity> {
  late List<BeatAssignmentListResponse> lstBeatAllocation = [];
  var districtName = "";
  var psName = "";
  String districtId = "";
  var psId = "";
  String role = "";
  List<PoliceStation> psList = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () async {
      role = AppUser.ROLE_CD;
      print("Role $role");
      if (role == "16" || role == "17") {
        getPSList();
      } else {
        _getHSList();
      }
    });
  }

  void getPSList() async {
    var userData = await LoginResponseModel.fromPreference();
    psList = await PoliceStation.searchPS(userData.districtCD!);
    print("len ${psList.length}");
    psName = psList[0].ps ?? "";
    psId = psList[0].psCD ?? "";
    _getHSList();
    setState(() {});
  }

  void _getHSList() async {
    var userData = await LoginResponseModel.fromPreference();
    districtName = userData.district ?? "";
    if (role != "16" && role != "17") {
      psName = userData.ps ?? "";
      // psId = psList[0].psCD??"";
      psId = userData.psCd ?? "";
    }
    var data = {"DISTRICT_CD": userData.districtCD, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_REPORT_BEAT_DETAILS, data, true);
    if (response.statusCode == 200) {
      try {
        lstBeatAllocation = [];
        for (Map<String, dynamic> i in response.data) {
          var data = BeatAssignmentListResponse.fromJson(i);
          lstBeatAllocation.add(data);
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(
          context,
          AppTranslations.of(context)!
              .text(response.statusMessage ?? "Bad response"));
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
        foregroundColor: Colors.white,
        title: Text(getTranlateString("beat_area_allotment_report")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                  margin: const EdgeInsets.only(left: 12, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(color: Colors.black, width: .5)),
                  child: Text(districtName),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                    margin: const EdgeInsets.only(left: 12, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(color: Colors.black, width: .5)),
                    child: InkWell(
                      onTap: () {
                        if (role == "16" || role == "17") {
                          showPSListDialog();
                        }
                      },
                      child: Row(children: [
                        if (role == "16" || role == "17")
                          const Icon(
                            Icons.filter_alt,
                            size: 18,
                          ),
                        Text(psName),
                      ]),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                  child: CustomView.getCountViewWithOutShadow(
                      context, lstBeatAllocation.length),
                )
              ],
            ),
            lstBeatAllocation.isNotEmpty
                ? Expanded(
                    flex: 1,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: lstBeatAllocation.length,
                        itemBuilder: (BuildContext context, int index) {
                          return getRowForConst(index);
                        }),
                  )
                : CustomView.getNoRecordView(context),
            InkWell(
              onTap: () {
                BeatAssignmentListResponse.generateExcel(
                    context, lstBeatAllocation);
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.file_download_outlined),
                    Text(getTranlateString("download").toUpperCase())
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getRowForConst(int index) {
    var data = lstBeatAllocation[index];
    List<GetConstableDetails> lstCons =
        GetConstableDetails.fromString(data.beatPersonDetails!);
    return Container(
      margin: const EdgeInsets.only(top: 5, right: 1),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * .98,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Color(0x10000000),
              offset: Offset(
                2.0,
                2.0,
              ),
              blurRadius: 2.0,
              spreadRadius: 2.0,
            ), //BoxShadow
            //BoxShadow
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(AppTranslations.of(context)!.text("beat_name"),
                      style: getHeaderStyle()),
                ),
                Expanded(
                  flex: 1,
                  child: Text(data.beatName ?? ""),
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
                    AppTranslations.of(context)!.text("beat_area"),
                    style: getHeaderStyle(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(data.area ?? ""),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * .96,
            decoration: BoxDecoration(
                color: Color(ColorProvider.indigo_100),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    getTranlateString("beat_constable"),
                    style: getHeaderStyle(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child:
                      Text(getTranlateString("pno"), style: getHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Text(getTranlateString("rank"),
                        style: getHeaderStyle()),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .96,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Color(ColorProvider.white),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: lstCons.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: lstCons.length,
                    physics: const RangeMaintainingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return getRowForChild(data.beatCd, lstCons[index]);
                    })
                : Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(getTranlateString("no_record_found")),
                  ),
          )
        ],
      ),
    );
  }

  Widget getRowForChild(beatCd, data) {
    return Container(
      width: MediaQuery.of(context).size.width * .90,
      decoration: BoxDecoration(
        color: Color(ColorProvider.white),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    data.NAME ?? "",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    data.CUG ?? "",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    data.OFFICER_RANK ?? "",
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width * .96,
            decoration: const BoxDecoration(color: Colors.grey),
          )
        ],
      ),
    );
  }

  void getFilteredData() {
    _getHSList();
  }

  showPSListDialog() async {
    AlertDialog alert = AlertDialog(
      content: SizedBox(
        height: 300,
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(getTranlateString("police_station")),
            ),
            CustomView.getHorizontalDevider(context),
            psList.isNotEmpty
                ? Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: psList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return getRowForPS(index);
                      },
                    ),
                  )
                : CustomView.getNoRecordView(context),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget getRowForPS(int index) {
    var data = psList[index];
    return InkWell(
        onTap: () {
          psId = data.psCD ?? "";
          psName = data.ps ?? "";
          Navigator.pop(context);
          getFilteredData();
        },
        child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      1.0,
                      1.0,
                    ),
                    blurRadius: 2.0,
                    spreadRadius: 1.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Text(data.ps ?? ""),
            )));
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
