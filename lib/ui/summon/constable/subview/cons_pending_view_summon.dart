// ignore_for_file: camel_case_types, library_prefixes, use_build_context_synchronously

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/constants/enums/summon_detail_type_enum.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/response/summon_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/ui/summon/summon_detail_view.dart';
import 'package:beatapp/utility/extentions/context_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ConsPendingFragment_Summon extends StatefulWidget {
  final Map<String, String?> data;

  /// 1 for summon 2 for warrant
  final int SUMM_WARR_NATURE;
  const ConsPendingFragment_Summon({
    Key? key,
    required this.data,
    required this.SUMM_WARR_NATURE,
  }) : super(key: key);

  @override
  State<ConsPendingFragment_Summon> createState() =>
      _ConsPendingFragment_SummonState();
}

class _ConsPendingFragment_SummonState
    extends BaseFullState<ConsPendingFragment_Summon> {
  String title = "";
  List<SummonResponse> _lstSummon = [];
  List<SummonResponse> _lstSummonAll = [];

  @override
  void initState() {
    title = widget.data["title"] ?? "";
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _getSummonList();
    });
  }

  Future<void> _getSummonList() async {
    _lstSummon = [];
    _lstSummonAll = [];
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "PS_CD": userData.psCd,
      "SUMM_WARR_NATURE": widget.SUMM_WARR_NATURE,
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.PENDING_SUMMON_BEAT, data, true);
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = SummonResponse.fromJson(i);
          _lstSummon.add(data);
          _lstSummonAll.add(data);
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
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString(title)),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: Container(
            alignment: Alignment.topCenter,
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
                          borderRadius: BorderRadius.all(Radius.circular(5)),
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
                    child: CustomView.getCountView(context, _lstSummon.length),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Color(ColorProvider.indigo_100),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              //sortData(1);
                            },
                            child: Text(
                              getTranlateString("fir_patty_case_no"),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                              onTap: () {
                                //sortData(2);
                              },
                              child: Text(
                                  getTranlateString("fir_patty_case_date"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                              onTap: () {
                                //sortData(3);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                    getTranlateString("beat_person_name"),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                              onTap: () {
                                //sortData(3);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(getTranlateString("rank"),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                              onTap: () {
                                //sortData(3);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                    getTranlateString("disposal_last_date"),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              _lstSummon.isNotEmpty
                  ? Expanded(
                      flex: 1,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _lstSummon.length,
                          itemBuilder: (BuildContext context, int index) {
                            return getRowForConst(index);
                          }),
                    )
                  : CustomView.getNoRecordView(context),
              InkWell(
                onTap: () {
                  if (_lstSummon.isNotEmpty) {
                    showDownloadOption(
                        onPdfClick: () {},
                        onXlsxClick: () {
                          SummonResponse.generateExcel(
                              context, _lstSummon, "PendingSummon");
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
            ])));
  }

  // Widget getRowForConst(int index) {
  //   var data = _lstSummon[index];
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => SummonDetailActivity(
  //               data: {"SUMM_WARR_NUM": data.SUMM_WARR_NUM},
  //             ),
  //           ));
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.only(top: 5, right: 1),
  //       padding: const EdgeInsets.all(10),
  //       width: MediaQuery.of(context).size.width * .98,
  //       decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.all(Radius.circular(5)),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Color(0x10000000),
  //               offset: Offset(
  //                 2.0,
  //                 2.0,
  //               ),
  //               blurRadius: 2.0,
  //               spreadRadius: 2.0,
  //             ), //BoxShadow
  //             //BoxShadow
  //           ]),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             margin: const EdgeInsets.only(top: 5),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   flex: 1,
  //                   child: Text(getTranlateString("date_and_time"),
  //                       style: getHeaderStyle()),
  //                 ),
  //                 Expanded(
  //                   flex: 1,
  //                   child: Text(data.OFFICER_RANK.toString()),
  //                 )
  //               ],
  //             ),
  //           ),
  //           Container(
  //             margin: const EdgeInsets.only(top: 5),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   flex: 1,
  //                   child: Text(getTranlateString("name_of_person"),
  //                       style: getHeaderStyle()),
  //                 ),
  //                 Expanded(
  //                   flex: 1,
  //                   child: Text(data.OFFICER_RANK),
  //                 )
  //               ],
  //             ),
  //           ),
  //           Container(
  //             margin: const EdgeInsets.only(top: 5),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   flex: 1,
  //                   child: Text(getTranlateString("rank"),
  //                       style: getHeaderStyle()),
  //                 ),
  //                 Expanded(
  //                   flex: 1,
  //                   child: Text(data.OFFICER_RANK),
  //                 )
  //               ],
  //             ),
  //           ),
  //           Container(
  //             margin: const EdgeInsets.only(top: 5),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   flex: 1,
  //                   child: Text(getTranlateString("type_of_information"),
  //                       style: getHeaderStyle()),
  //                 ),
  //                 Expanded(
  //                   flex: 1,
  //                   child: Text(data.OFFICER_RANK),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget getRowForConst(int index) {
    var data = _lstSummon[index];
    return InkWell(
        onTap: () async {
          final result = await context.push(SummonDetailActivity(
            SUMM_WARR_NUM: data.SUMM_WARR_NUM,
            detailType: SummonDetailType.pending,
            SUMM_WARR_NATURE: widget.SUMM_WARR_NATURE,
          ));

          if (result is bool && result) {
            _getSummonList();
          }
        },
        child: Container(
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
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  data.FIR_REG_NUM,
                  maxLines: 2,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(data.ASSIGNED_ON, maxLines: 2),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(data.ASSIGNED_TO_NAME, maxLines: 2),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(data.ASSIGNED_TO_RANK, maxLines: 2),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(data.COMPLETION_DATE, maxLines: 2),
                ),
              ),
            ],
          ),
        ));
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
                      AppTranslations.of(context)!.text(
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
                  const Text("Filter Based On Assigned Date"),
                  Row(
                    children: [
                      Checkbox(
                          value: checkedFilter == 1 ? true : false,
                          onChanged: (value) {
                            checkedFilter = 1;
                            selectedFilterText = "All";
                            setFilterData();
                            Navigator.pop(context);
                          }),
                      const Text("All")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: checkedFilter == 2 ? true : false,
                          onChanged: (value) {
                            checkedFilter = 2;
                            selectedFilterText = "15 days";
                            setFilterData();
                            Navigator.pop(context);
                          }),
                      const Text("15 days")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: checkedFilter == 3 ? true : false,
                          onChanged: (value) {
                            checkedFilter = 3;
                            selectedFilterText = "15 to 30 days";
                            setFilterData();
                            Navigator.pop(context);
                          }),
                      const Text("15 to 30 days")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: checkedFilter == 4 ? true : false,
                          onChanged: (value) {
                            checkedFilter = 4;
                            selectedFilterText = "After 30 days";
                            setFilterData();
                            Navigator.pop(context);
                          }),
                      const Text("After 30 days")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: checkedFilter == 5 ? true : false,
                          onChanged: (value) {
                            checkedFilter = 5;
                            selectedFilterText = "All";
                            Navigator.pop(context);
                            setFilterData();
                          }),
                      const Text("Select From And To Date")
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }

  String selectedFDate = "";
  String selectedTDate = "";

  void showDateSelectDialog() {
    selectedFDate = "";
    selectedTDate = "";
    showGeneralDialog(
      context: context,
      barrierLabel: "Date Selection",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(// You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(10),
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
                        AppTranslations.of(context)!.text(
                          "Select From And To Date",
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
                      margin: const EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width * .96,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          getTranlateString("From Date"),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .96,
                        height: 35,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
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
                              selectedFDate,
                            )),
                            InkWell(
                                onTap: () async {
                                  selectedFDate =
                                      await DialogHelper.openDatePickerDialog(
                                          context);
                                  setState(() {});
                                },
                                child: const Icon(Icons.date_range))
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
                          getTranlateString("To Date"),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .96,
                        height: 35,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
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
                              selectedTDate,
                            )),
                            InkWell(
                                onTap: () async {
                                  selectedTDate =
                                      await DialogHelper.openDatePickerDialog(
                                          context);
                                  setState(() {});
                                },
                                child: const Icon(Icons.date_range))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: InkWell(
                        onTap: onTapSubmit,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          height: 40,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                            color: Color(ColorProvider.colorPrimary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text(
                            AppTranslations.of(context)!.text("submit"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
        });
      },
    );
  }

  setFilterData() {
    _lstSummon = [];
    if (checkedFilter == 1) {
      _lstSummon = _lstSummonAll;
    } else if (checkedFilter == 2) {
      _lstSummon = SummonResponse.getLast15DaysListAssigned(_lstSummonAll);
    } else if (checkedFilter == 3) {
      _lstSummon = SummonResponse.getLast15To30DaysListAssigned(_lstSummonAll);
    } else if (checkedFilter == 4) {
      _lstSummon = SummonResponse.getBefore30DaysListAssigned(_lstSummonAll);
    } else {
      _lstSummon = _lstSummonAll;
      showDateSelectDialog();
    }
    setState(() {});
  }

  void onTapSubmit() {
    if (selectedFDate == "") {
      MessageUtility.showToast(context, "Please Select From Date");
      return;
    } else if (selectedTDate == "") {
      MessageUtility.showToast(context, "Please Select To Date");
      return;
    }
    _lstSummon = SummonResponse.getDataFromToDateList(
        selectedFDate, selectedTDate, _lstSummonAll);
    selectedFilterText = "$selectedFDate - $selectedTDate";
    Navigator.pop(context);
    super.setState(() {});
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
