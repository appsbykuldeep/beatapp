import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/history_sheeters_details_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/history_sheeters/sho/main/history_sheeter_delete_view.dart';
import 'package:beatapp/ui/history_sheeters/sho/main/history_sheeter_edit_view.dart';
import 'package:beatapp/ui/history_sheeters/sho/main/history_sheeter_sho_detail_view.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class HistorySheetersViewActivity extends StatefulWidget {
  const HistorySheetersViewActivity({Key? key}) : super(key: key);

  @override
  State<HistorySheetersViewActivity> createState() =>
      _HistorySheetersViewActivityState();
}

class _HistorySheetersViewActivityState
    extends State<HistorySheetersViewActivity> {
  late List<HistorySheetersDetailsResponse> lstHS = [];
  late List<HistorySheetersDetailsResponse> lstHSAll = [];
  bool isActiveSelcted = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      _getHsList();
    });
  }

  getSelectedList() {
    if (isActiveSelcted) {
      lstHS = HistorySheetersDetailsResponse.getActiveList(lstHSAll);
    } else {
      lstHS = HistorySheetersDetailsResponse.getInActiveList(lstHSAll);
    }
    setState(() {});
  }

  void _getHsList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_HST_LIST_SHO, data, true);
    lstHS = [];
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = HistorySheetersDetailsResponse.fromJson(i);
          lstHSAll.add(data);
        }
        getSelectedList();
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
        title: Text(getTranlateString("history_sheeters")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: lstHS.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                              child: CustomView.getCountView(
                                  context, lstHS.length),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                              child: InkWell(
                                onTap: () {
                                  isActiveSelcted = true;
                                  getSelectedList();
                                },
                                child: CustomView.getTextView(
                                    context, getTranlateString("active")),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                              child: InkWell(
                                onTap: () {
                                  isActiveSelcted = false;
                                  getSelectedList();
                                },
                                child: CustomView.getTextView(
                                    context, getTranlateString("inactive")),
                              ),
                            )
                          ],
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
                                      width: 688,
                                    ),
                                    Container(
                                      color: ColorProvider.blueColor,
                                      height: 5,
                                      width: 688,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 40,
                                color: Colors.white,
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      child: Text(
                                        "Beat",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: Text(
                                        getTranlateString("village_street"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: Text(
                                        getTranlateString(
                                            "history_sheeter_name"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 130,
                                      child: Text(
                                        "HSR No.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: Text(
                                        getTranlateString("activity_status"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        getTranlateString("routine_status"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: List.generate(
                              lstHS.length, (index) => getRowForConst(index)),
                        ),
                      ]),
                )
              : CustomView.getNoRecordView(context)),
      bottomNavigationBar: InkWell(
        onTap: () {
          HistorySheetersDetailsResponse.generateExcel(context, lstHS);
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
    var data = lstHS[index];
    return InkWell(
        onTap: () {
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
                SizedBox(
                  width: 100,
                  child: Text(
                    data.BEAT_NAME,
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: Text(
                    data.vILLSTREETNAME ?? "",
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: Text(
                    data.nAME ?? "",
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: Text(
                    data.hSTSRNUM ?? "",
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: Text(
                    data.iSACTIVE ?? "",
                  ),
                ),
                SizedBox(
                    width: 60,
                    child: Icon(
                      data.ROUTINE_VERIFICATION_STATUS == "VERIFIED"
                          ? Icons.verified
                          : Icons.unpublished_rounded,
                      color:
                          data.PENDING_TYPE == "D" ? Colors.green : Colors.red,
                      size: 24,
                    ))
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HistorySheeterSHODetailActivity(
                                    data: {"HST_SR_NUM": data.hSTSRNUM}),
                          ));
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
                      bool res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistorySheeterEditActivity(
                                data: {"HST_SR_NUM": data.hSTSRNUM}),
                          ));
                      if (res) {
                        _getHsList();
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
                      bool res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistorySheeterDeleteActivity(
                                data: {"HST_SR_NUM": data.hSTSRNUM}),
                          ));
                      if (res) {
                        _getHsList();
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
