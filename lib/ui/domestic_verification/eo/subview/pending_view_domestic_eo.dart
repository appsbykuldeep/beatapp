import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/cs_eo_action_list_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/feedback/eo_feefback_view.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class PendingFragmentDomesticEo extends StatefulWidget {
  const PendingFragmentDomesticEo({Key? key}) : super(key: key);

  @override
  State<PendingFragmentDomesticEo> createState() =>
      _PendingFragmentDomesticEoState();
}

class _PendingFragmentDomesticEoState
    extends BaseFullState<PendingFragmentDomesticEo> {
  List<CsEoActionListResponse> lstData = [];
  List<CsEoActionListResponse> lstDataAll = [];

  @override
  void initState() {
    _getDomesticHelpList();
    super.initState();
  }

  void _getDomesticHelpList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd, "SERVICE_TYPE": "2"};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.CS_EO_ACTION_LIST, data, true);
    lstData = [];
    lstDataAll = [];
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = CsEoActionListResponse.fromJson(i);
          lstData.add(data);
          lstDataAll.add(data);
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: lstData.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x80000000),
                                  offset: Offset(
                                    2.0,
                                    2.0,
                                  ),
                                  blurRadius: 3.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                                //BoxShadow
                              ]),
                          child: InkWell(
                            onTap: () {
                              showFilterDialog(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.filter_alt,
                                  size: 18,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  child: Text(selectedFilterText),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
                        child: CustomView.getCountView(context, lstData.length),
                      ),
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
                                width: 758,
                              ),
                              Container(
                                color: ColorProvider.blueColor,
                                height: 5,
                                width: 758,
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
                              const SizedBox(
                                width: 100,
                                child: Text("Beat"),
                              ),
                              SizedBox(
                                width: 130,
                                child: Text(
                                  getTranlateString(
                                      "application_serial_number"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width: 130,
                                child: Text(
                                  getTranlateString("applicant_name"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width: 130,
                                child: Text(
                                  getTranlateString("application_date"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width: 130,
                                child: Text(
                                  getTranlateString(
                                      "completed_by_constable_on"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width: 130,
                                child: Text(
                                  getTranlateString("beat_constable"),
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
                        lstData.length, (index) => getRowForConst(index)),
                  ),
                  InkWell(
                    onTap: () {
                      if (lstData.isNotEmpty) {
                        showDownloadOption(
                            onPdfClick: () {},
                            onXlsxClick: () {
                              CsEoActionListResponse.generateExcelUnAssigned(
                                  context, lstData);
                            });
                      }
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
                ]),
              )
            : CustomView.getNoRecordView(context));
  }

  Widget getRowForConst(int index) {
    var data = lstData[index];
    return InkWell(
      onTap: () async {
        bool result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EoFeedbackActivity(
                data: {
                  "APPLICATION_SR_NUM": data.aPPLICATIONSRNUM,
                  "SERVICE_TYPE": "2"
                },
              ),
            ));
        if (result) {
          _getDomesticHelpList();
        }
      },
      child: Container(
          padding: const EdgeInsets.only(left: 4, right: 4),
          color: index % 2 == 0
              ? ColorProvider.redColor.withOpacity(0.05)
              : ColorProvider.blueColor.withOpacity(0.05),
          constraints: const BoxConstraints(minHeight: 40),
          child: Row(
            children: [
              const SizedBox(
                width: 100,
                child: Text("Beat1"),
              ),
              SizedBox(
                width: 130,
                child: Text(
                  data.aPPLICATIONSRNUM ?? "",
                ),
              ),
              SizedBox(
                width: 130,
                child: Text(
                  data.rEQUESTERNAME ?? "",
                ),
              ),
              SizedBox(
                width: 130,
                child: Text(
                  data.aPPLICATIONDT ?? "",
                ),
              ),
              SizedBox(
                width: 130,
                child: Text(
                  data.cOMPLDT ?? "",
                ),
              ),
              SizedBox(
                width: 130,
                child: Text(
                  data.bEATCONSTABLENAME ?? "",
                ),
              ),
            ],
          )),
    );
  }

  int checkedFilter = 1;
  String selectedFilterText = "All";

  void showFilterDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "filter",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, __, ___) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * .90,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF000000),
                      offset: Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    //BoxShadow
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Text(
                      getTranlateString(
                        "Filter",
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  CustomView.getHorizontalDevider(context),
                  Container(
                    child: const Text("Filter Based On Registered Date"),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Checkbox(
                            value: checkedFilter == 1 ? true : false,
                            onChanged: (value) {
                              checkedFilter = 1;
                              selectedFilterText = "All";
                              setFilterData();
                              Navigator.pop(context);
                            }),
                        Container(
                          child: const Text("All"),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Checkbox(
                            value: checkedFilter == 2 ? true : false,
                            onChanged: (value) {
                              checkedFilter = 2;
                              selectedFilterText = "15 days";
                              setFilterData();
                              Navigator.pop(context);
                            }),
                        Container(
                          child: const Text("15 days"),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Checkbox(
                            value: checkedFilter == 3 ? true : false,
                            onChanged: (value) {
                              checkedFilter = 3;
                              selectedFilterText = "15 to 30 days";
                              setFilterData();
                              Navigator.pop(context);
                            }),
                        Container(
                          child: const Text("15 to 30 days"),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Checkbox(
                            value: checkedFilter == 4 ? true : false,
                            onChanged: (value) {
                              checkedFilter = 4;
                              selectedFilterText = "After 30 days";
                              setFilterData();
                              Navigator.pop(context);
                            }),
                        Container(
                          child: const Text("After 30 days"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }

  setFilterData() {
    lstData = [];
    if (checkedFilter == 1) {
      lstData = lstDataAll;
    } else if (checkedFilter == 2) {
      lstData = CsEoActionListResponse.getLast15DaysList(lstDataAll);
    } else if (checkedFilter == 3) {
      lstData = CsEoActionListResponse.getLast15To30DaysList(lstDataAll);
    } else {
      lstData = CsEoActionListResponse.getBefore30DaysList(lstDataAll);
    }
    setState(() {});
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
