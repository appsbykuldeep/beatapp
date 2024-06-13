import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/history_sheeter_detail_table.dart';
import 'package:beatapp/model/response/history_sheeters_beat_report_table.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class HSPendingEditActivity extends StatefulWidget {
  final data;

  const HSPendingEditActivity({Key? key, required this.data}) : super(key: key);

  @override
  State<HSPendingEditActivity> createState() =>
      _HSPendingEditActivityState(data);
}

class _HSPendingEditActivityState extends State<HSPendingEditActivity> {
  var con_HSno = TextEditingController();
  var con_Remark = TextEditingController();
  final openingDateCtrl = TextEditingController();
  final bandDateCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  HistorySheeterDetail_Table? details;
  List<HistorySheetersBeatReport_Table> lstBeat = [];
  String HST_SR_NUM = "";
  bool isApproved = false;
  String DATE_OF_OPENING = "", NIGRANI_BAND_DATE = "";

  _HSPendingEditActivityState(data) {
    HST_SR_NUM = data["HST_SR_NUM"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    _getArrestDetails();
    super.initState();
  }

  void _getArrestDetails() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"HST_SR_NUM": HST_SR_NUM, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_HST_SP_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        details = response.data["Table"].toList().length != 0
            ? HistorySheeterDetail_Table.fromJson(response.data["Table"][0])
            : null;
        var formData = response.data["Table2"].toList();
        if (formData.length > 0) {
          con_HSno.text =
              formData[formData.length - 1]["HISTORY_SHEET_NO"] ?? "";
          DATE_OF_OPENING =
              formData[formData.length - 1]["DATE_OF_OPENING"] ?? "";
          NIGRANI_BAND_DATE =
              formData[formData.length - 1]["NIGRANI_BAND_DATE"] ?? "";
          isApproved =
              formData[formData.length - 1]["SP_APPROVED_STATUS"].toString() ==
                      "Y"
                  ? true
                  : false;
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  void _saveData() async {
    var data = {
      "APPROVAL_TYPE": details!.PENDING_TYPE ?? "O",
      "DATE_OF_OPENING": DATE_OF_OPENING,
      "HISTORY_SHEET_NO": con_HSno.text.toString().trim(),
      "HIST_SR_NUM": HST_SR_NUM,
      "IS_APPROVED": isApproved ? "Y" : "N",
      "NIGRANI_BAND_DATE": NIGRANI_BAND_DATE,
      "SP_REMARKS": con_Remark.text.toString().trim()
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_HST_SP_DATA, data, false);
    Navigator.pop(context);
    if (response.statusCode == 200 && response.data.toString() == "1") {
      MessageUtility.showToast(
          context, getTranlateString("record_successfully_submitted"));
      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text("error_msg"));
    }
  }

  radioOnchangeApproved(value) {
    isApproved = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(getTranlateString("history_sheeters")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: details != null
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  getTranlateString("information_detail"),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                          if (details!.PENDING_TYPE == "D")
                            Container(
                              margin: const EdgeInsets.only(top: 5, right: 5),
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  getTranlateString("deletion_req"),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            )
                        ],
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
                                details!.dISTRICT ?? "",
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
                                details!.pS ?? "",
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
                                details!.bEATNAME ?? "",
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
                                details!.vILLSTREETNAME ?? "",
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
                            getTranlateString("history_sheeter_name"),
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
                                details!.nAME ?? "",
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
                            getTranlateString("father_name"),
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
                                details!.fATHERNAME ?? "",
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
                                details!.mOBILE ?? "",
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
                            getTranlateString("remark"),
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
                                details!.rEMARKS ?? "",
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
                            getTranlateString("sp_approval_hs_num"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          height: 60,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            right: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Checkbox(
                                        value:
                                            details!.SP_APPROVED_STATUS == "Y"
                                                ? true
                                                : false,
                                        onChanged: null,
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
                                        value:
                                            details!.SP_APPROVED_STATUS == "Y"
                                                ? false
                                                : true,
                                        onChanged: null,
                                        activeColor: Colors.red),
                                    Text(getTranlateString("no"))
                                  ],
                                ),
                              )
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
                            getTranlateString("sp_hs_approval"),
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
                            "${getTranlateString("history_sheeter_num")}*",
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      4.height,
                      EditTextBorder(
                        controller: con_HSno,
                        validator: Validations.emptyValidator,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            "${getTranlateString("dt_of_opening")}*",
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      4.height,
                      EditTextBorder(
                        controller: openingDateCtrl,
                        validator: Validations.emptyValidator,
                        readOny: true,
                        suffixIcon: InkWell(
                          onTap: () async {
                            openingDateCtrl.text =
                                await DialogHelper.openDatePickerDialog(
                                    context);
                          },
                          child: const Icon(Icons.date_range),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            "${getTranlateString("nigrani_band_dt")}*",
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      4.height,
                      EditTextBorder(
                        controller: bandDateCtrl,
                        validator: Validations.emptyValidator,
                        readOny: true,
                        suffixIcon: InkWell(
                          onTap: () async {
                            bandDateCtrl.text =
                                await DialogHelper.openDatePickerDialog(
                                    context);
                          },
                          child: const Icon(Icons.date_range),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Text(
                            getTranlateString("approved"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .96,
                          height: 60,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            right: 5,
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Checkbox(
                                        value: isApproved,
                                        onChanged: (v) =>
                                            radioOnchangeApproved(true),
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
                                        value: !isApproved,
                                        onChanged: (v) =>
                                            radioOnchangeApproved(false),
                                        activeColor: Colors.red),
                                    Text(getTranlateString("no"))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .96,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            "${getTranlateString("remark")}*",
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      4.height,
                      EditTextBorder(
                        controller: con_Remark,
                        validator: Validations.emptyValidator,
                      ),
                      12.height,
                      Button(
                        title:
                            details!.PENDING_TYPE == "D" ? "delete" : "submit",
                        width: double.maxFinite,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            DialogHelper.showLoaderDialog(context);
                            _saveData();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox());
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
