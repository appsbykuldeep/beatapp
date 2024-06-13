import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class ShoActionActivity extends StatefulWidget {
  final data;

  const ShoActionActivity({Key? key, required this.data}) : super(key: key);

  @override
  State<ShoActionActivity> createState() => _ShoActionActivityState(data);
}

class _ShoActionActivityState extends State<ShoActionActivity> {
  var con_Remark = TextEditingController();
  bool IS_ACCEPTED = false;
  var SR_NUM;

  _ShoActionActivityState(data) {
    SR_NUM = data["SR_NUM"];
    con_Remark.text = "Case Accepted";
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  void _saveRemark() async {
    if (con_Remark.text.toString().trim() == "") {
      MessageUtility.showToast(
          context, getTranlateString("remark_is_compulsory"));
      return;
    }
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "DESCRIPTION": con_Remark.text.toString().trim(),
      "IS_ACCEPTED": IS_ACCEPTED ? "Y" : "N",
      "PERSONID": SR_NUM,
      "PS_CD": userData.psCd
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_CS_SHARED_INFO_SHO, data, true);
    if (response.statusCode == 200 && response.data == 1) {
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  radioOnchangeAccepted(value) {
    IS_ACCEPTED = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("sho_action")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Container(
          margin:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width * .96,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    getTranlateString("action"),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Checkbox(
                                value: IS_ACCEPTED,
                                onChanged: (v) => radioOnchangeAccepted(true),
                                activeColor: Colors.red),
                            Text(getTranlateString("accepted"))
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Checkbox(
                                value: !IS_ACCEPTED,
                                onChanged: (v) => radioOnchangeAccepted(false),
                                activeColor: Colors.red),
                            Text(getTranlateString("rejected"))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  getTranlateString("remark_mandatory"),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .90,
                    padding: const EdgeInsets.only(
                        right: 5, top: 8, left: 5, bottom: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: TextField(
                      controller: con_Remark,
                      style: const TextStyle(),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 25),
                child: InkWell(
                  onTap: () => {_saveRemark()},
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    decoration: BoxDecoration(
                      color: Color(ColorProvider.colorPrimary),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      getTranlateString("submit"),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
