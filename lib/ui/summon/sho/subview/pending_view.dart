import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/constants/enums/summon_detail_type_enum.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/summon_response.dart';
import 'package:beatapp/preferences/preference_util.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/ui/summon/summon_detail_view.dart';
import 'package:beatapp/utility/extentions/context_ext.dart';
import 'package:beatapp/utility/extentions/string_ext.dart';
import 'package:beatapp/utility/extentions/widget_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PendingFragment extends StatefulWidget {
  final String title;
  final int SUMM_WARR_NATURE;
  const PendingFragment({
    Key? key,
    required this.title,
    required this.SUMM_WARR_NATURE,
  }) : super(key: key);

  @override
  State<PendingFragment> createState() => _PendingFragmentState();
}

class _PendingFragmentState extends State<PendingFragment> {
  List<SummonResponse> _lstSummon = [];
  List<SummonResponse> lstSummonAll = [];

  final pref = PreferenceHelper();
  bool isDataSubmitted = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _getUnAssignedList();
    });
  }

  Future<void> _getUnAssignedList() async {
    _lstSummon = [];
    lstSummonAll = [];
    var pscd = AppUser.PS_CD;
    var data = {
      "PS_CD": pscd,
      "SUMM_WARR_NATURE": widget.SUMM_WARR_NATURE,
    };
    /*final res=await callApi(endPoint: EndPoints.PENDING_SUMMON,request: data);
    print(res.body);
    if(res.statusCode==200){
     */ /* var data = SummonResponse.fromJson(i);
      _lstSummon.add(data);
      lstSummonAll.add(data);*/ /*
    }*/
    late Response response;
    response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.PENDING_SUMMON, data, true);
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = SummonResponse.fromJson(i);
          _lstSummon.add(data);
          lstSummonAll.add(data);
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      if (response.data != null) {
        MessageUtility.showToast(context, response.data!.toString());
      } else {
        MessageUtility.showToast(context, response.toString());
      }
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
          title: Text(getTranlateString(widget.title)),
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
                    Container(
                      child: Row(
                        children: [
                          "FIR/Petty\nCase No."
                              .text(fontWeight: FontWeight.bold)
                              .expand(),
                          "FIR/Petty\nCase Date."
                              .text(fontWeight: FontWeight.bold)
                              .expand(),
                          "Beat Constable"
                              .text(fontWeight: FontWeight.bold)
                              .expand(),
                          "Rank".text(fontWeight: FontWeight.bold).expand(),
                          "Execution Last\nDate"
                              .text(fontWeight: FontWeight.bold)
                              .expand(),
                        ],
                      ),
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
                  SummonResponse.generateExcel(
                      context, _lstSummon, "PendingSummon");
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

  Widget getRowForConst(int index) {
    var data = _lstSummon[index];
    return InkWell(
        onTap: () async {
          isDataSubmitted = false;
          await context.push(
            SummonDetailActivity(
              SUMM_WARR_NUM: data.SUMM_WARR_NUM,
              detailType: SummonDetailType.pending,
              SUMM_WARR_NATURE: widget.SUMM_WARR_NATURE,
              onSubmitDetail: () {
                isDataSubmitted = true;
              },
            ),
          );

          if (isDataSubmitted) {
            _getUnAssignedList();
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
                  Container(
                    child: const Text("Filter Based On Assigned Date"),
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
                  ),
                  Container(
                    child: Row(
                      children: [
                        Checkbox(
                            value: checkedFilter == 5 ? true : false,
                            onChanged: (value) {
                              checkedFilter = 5;
                              selectedFilterText = "All";
                              Navigator.pop(context);
                              setFilterData();
                            }),
                        Container(
                          child: const Text("Select From And To Date"),
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
      _lstSummon = lstSummonAll;
    } else if (checkedFilter == 2) {
      _lstSummon = SummonResponse.getLast15DaysListAssigned(lstSummonAll);
    } else if (checkedFilter == 3) {
      _lstSummon = SummonResponse.getLast15To30DaysListAssigned(lstSummonAll);
    } else if (checkedFilter == 4) {
      _lstSummon = SummonResponse.getBefore30DaysListAssigned(lstSummonAll);
    } else {
      _lstSummon = lstSummonAll;
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
        selectedFDate, selectedTDate, lstSummonAll);
    selectedFilterText = "$selectedFDate - $selectedTDate";
    Navigator.pop(context);
    super.setState(() {});
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
