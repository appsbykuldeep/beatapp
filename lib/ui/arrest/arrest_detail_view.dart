import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/arrest.dart';
import 'package:beatapp/model/assign_history.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/navigator_utils.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;

class ArrestDetailActivity extends StatefulWidget {
  final Arrest arrest;

  const ArrestDetailActivity({Key? key, required this.arrest})
      : super(key: key);

  @override
  State<ArrestDetailActivity> createState() =>
      _ArrestDetailActivityState(arrest);
}

class _ArrestDetailActivityState extends State<ArrestDetailActivity> {
  Arrest _arrest;
  AssignHistory? _assignHistory;

  _ArrestDetailActivityState(this._arrest);

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    _getArrestDetails();
    _getAssignHistoryDetails();
    super.initState();
  }

  void _getArrestDetails() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"ACCUSED_SRNO": _arrest.accusedSrNo, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_ACCUSED_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        _arrest = Arrest.fromJson(response.data[0]);
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  void _getAssignHistoryDetails() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"ACCUSED_SRNO": _arrest.accusedSrNo, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_ARREST_HISTORY, data, true);
    if (response.statusCode == 200) {
      try {
        _assignHistory = AssignHistory.fromJson(response.data[0]);
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
          title: Text(getTranlateString("arrest_detail")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * .96,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      getTranlateString("accused_name"),
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.accusedName ?? "",
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
                      getTranlateString("fir_no"),
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.firNum ?? "",
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
                      getTranlateString("fir_date"),
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.firDate ?? "",
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
                      getTranlateString("act_section"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 70,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      right: 5,
                      left: 5,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.actSection ?? "",
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
                      getTranlateString("accused_present_address"),
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.accusedPresentAddress ?? "",
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
                      getTranlateString("accused_permanent_address"),
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.accusedPermanentAddress ?? "",
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
                      getTranlateString("mobile_num"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 5,
                  ),
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
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          _arrest.mobile ?? "",
                        )),
                      ],
                    ),
                  ),
                ),
                if (_assignHistory != null)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: MediaQuery.of(context).size.width * .96,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        getTranlateString("allotment_detail"),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                if (_assignHistory != null)
                  Container(
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
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
                                      AppTranslations.of(context)!
                                          .text("completed"),
                                      style: getHeaderStyle()),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        right: 5,
                                        left: 5,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                    value: _assignHistory!
                                                                .isResolved ==
                                                            "Y"
                                                        ? true
                                                        : false,
                                                    onChanged: radioOnchange,
                                                    activeColor: Colors.red),
                                                Text(getTranlateString("yes"))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                    value: _assignHistory!
                                                                .isResolved ==
                                                            "Y"
                                                        ? false
                                                        : true,
                                                    onChanged: radioOnchange,
                                                    activeColor: Colors.red),
                                                Text(getTranlateString("no"))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
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
                                      AppTranslations.of(context)!
                                          .text("been_arrested"),
                                      style: getHeaderStyle()),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        right: 5,
                                        left: 5,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                    value: _assignHistory!
                                                                .isArrested ==
                                                            "Y"
                                                        ? true
                                                        : false,
                                                    onChanged: radioOnchange,
                                                    activeColor: Colors.red),
                                                Text(getTranlateString("yes"))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                    value: _assignHistory!
                                                                .isArrested ==
                                                            "Y"
                                                        ? false
                                                        : true,
                                                    onChanged: radioOnchange,
                                                    activeColor: Colors.red),
                                                Text(getTranlateString("no"))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
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
                                    AppTranslations.of(context)!
                                        .text("beat_name"),
                                    style: getHeaderStyle(),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(_assignHistory!.beatName ?? ""),
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
                                      AppTranslations.of(context)!
                                          .text("beat_person_name"),
                                      style: getHeaderStyle()),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(_assignHistory!.assignedTo ?? ""),
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
                                      AppTranslations.of(context)!
                                          .text("assigned_date"),
                                      style: getHeaderStyle()),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:
                                      Text(_assignHistory!.assignedDate ?? ""),
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
                                    AppTranslations.of(context)!
                                        .text("constable_remark_date"),
                                    style: getHeaderStyle(),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(_assignHistory!.fillDt ?? ""),
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
                                    AppTranslations.of(context)!.text("remark"),
                                    style: getHeaderStyle(),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(_assignHistory!.remark ?? ""),
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
                                    AppTranslations.of(context)!
                                        .text("location"),
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
                                            double.parse(
                                                _assignHistory!.lat ?? "0"),
                                            double.parse(
                                                _assignHistory!.lng ?? "0"))
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
                  )
              ],
            ),
          ),
        ));
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
