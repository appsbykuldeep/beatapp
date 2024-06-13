import 'dart:async';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/entities/district.dart';
import 'package:beatapp/entities/police_station.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/summary_response.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({Key? key}) : super(key: key);

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  SummaryResponse? summaryResponse;

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

   String dropdownValueDistrict="Select";
  List<String> spinnerItemsDistrict = ["Select"];
   String dropdownValuePS="Select";
  List<String> spinnerItemsPS = ["Select"];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      getDistrictList();
    });
  }

  void getDistrictList() async {
    var response = await HttpRequst.postRequestWithToken(
        context, EndPoints.GET_ROLE_BASED_DISTRICT, true);
    if (response.statusCode == 200) {
      try {

        for (Map<String, dynamic> i in response.data) {
          var data = District.fromJson(i);
          spinnerItemsDistrict.add("${data.district!}#${data.districtCD!}");
        }
      } catch (e) {
        e.toString();
      }
      setState(() {});
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
      Navigator.pop(context);
    }
  }

  String getSelectedDistrictId() {
    return dropdownValueDistrict.split("#")[1].toString();
  }

  String getSelectedPSId() {
    return dropdownValuePS.split("#")[1].toString();
  }

  void getPSList() async {
    var lst = await PoliceStation.searchPS(getSelectedDistrictId());
    for (int i = 0; i < lst.length; i++) {
      spinnerItemsPS.add("${lst[i].ps!}#${lst[i].psCD!}");
    }
    setState(() {});
  }

  void _getSummuryData() async {

    var data = {
      "DISTRICT_CD": getSelectedDistrictId(),
      "PS_CD": getSelectedPSId()
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.DASHBOARD_SUMMARY, data, true);
    if (response.statusCode == 200) {
      summaryResponse = SummaryResponse.fromJson(response.data[0]);
      setState(() {});
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color(ColorProvider.colorPrimary),
          title: Text(getTranlateString("Summary")),

        ),
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      getTranlateString("district"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 45,
                    child: InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .90,
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: spinnerItemsDistrict.isNotEmpty
                            ? DropdownButton<String>(
                                isExpanded: true,
                                value: dropdownValueDistrict,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                                underline: Container(
                                  height: 0,
                                  color: Colors.transparent,
                                ),
                                onChanged: (String? data) {
                                  dropdownValueDistrict = data!;
                                  if(dropdownValueDistrict!="Select"){
                                    getPSList();
                                  }

                                  setState(() {});
                                },
                                items: spinnerItemsDistrict
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value.split("#")[0],
                                        style: const TextStyle(color: Colors.black)),
                                  );
                                }).toList(),
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: Text(
                      getTranlateString("police_station"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 45,
                    child: InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .90,
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: spinnerItemsPS.isNotEmpty
                            ? DropdownButton<String>(
                                isExpanded: true,
                                value: dropdownValuePS,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                                underline: Container(
                                  height: 0,
                                  color: Colors.transparent,
                                ),
                                onChanged: (String? data) {
                                  setState(() {
                                    dropdownValuePS = data!;
                                  });
                                },
                                items: spinnerItemsPS
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value.split("#")[0],
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ),
                  16.height,
                  Align(
                    alignment: Alignment.topRight,
                    child: Button(
                      title: "search",
                      onPressed: (dropdownValueDistrict == getTranlateString("select")||dropdownValuePS == getTranlateString("select")) ?null:
                      (){
                        _getSummuryData();
                      },
                    ),
                  ),
                  summaryResponse != null ? getchildAfterSearch() : const SizedBox()
                ],
              )),
        ));
  }

  getchildAfterSearch() {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("sho_shared_notice"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("total_count"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.sHAREDINFO ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("beat_shared_information"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("total_count"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.sOOCHNAINFO ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("employee_verification"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("unalloted"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.tOTALEMPLOYEECOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              AppTranslations.of(context)!.text("pending"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.pENDINGEMPLOYEECOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.cOMPLETEDEMPLOYEECOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("domestic_help_verification"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("unalloted"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.tOTALDOMESTICCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              AppTranslations.of(context)!.text("pending"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.pENDINGDOMESTICCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.cOMPLETEDDOMESTICCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("character_certificate_verification"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("unalloted"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.tOTALCHARCACTERCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              AppTranslations.of(context)!.text("pending"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.pENDINGCHARCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.cOMPLETEDCHARCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("tenant_verification"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("unalloted"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.tOTALTENANTCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              AppTranslations.of(context)!.text("pending"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.pENDINGTENANTCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.cOMPLETEDTENANTCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("citizens_messages"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("unalloted"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.tOTALCSSHAREDCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              AppTranslations.of(context)!.text("pending"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.pENDINGCSSHAREDINFOCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.cOMPLETEDCSSHAREDINFOCOUNT ??
                                  "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("pending_arrest"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("unalloted"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.pENDINGARREST ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              AppTranslations.of(context)!.text("pending"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.aSSIGNEDARR ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.cOMPLETEDARR ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("summon_warrant_notice"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("unalloted"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.rEGISTEREDSUMMON ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              AppTranslations.of(context)!.text("pending"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.aSSIGNEDSUMMON ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.cOMPLETEDSUMMON ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("beat"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("total_count"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.bEATS ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("beat_constable"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("total_count"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.bEATUSERS ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("beatapp_alotment_roaster"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("total_count"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.dUITYASSIGNED ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("arms_weapon_verification"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("unverified"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.uNVERIFIEDWEAPONCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              AppTranslations.of(context)!.text("verified"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.vERIFIEDWEAPONCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getHeaderText("history_sheeters"),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              AppTranslations.of(context)!.text("unverified"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.uNVERIFIEDHSTCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
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
                              AppTranslations.of(context)!.text("verified"),
                              style: getHeaderStyle()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            child: Text(
                              summaryResponse!.vERIFIEDHSTCOUNT ?? "0",
                              style: getTextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  getHeaderText(String text) {
    return Container(
      child: Text(getTranlateString(text)),
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}

TextStyle getTextStyle() {
  return const TextStyle(color: Colors.blue, fontWeight: FontWeight.normal);
}
