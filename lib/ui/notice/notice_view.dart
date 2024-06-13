import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/alerts_reminder_response.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;

class NoticeActivity extends StatefulWidget {
  const NoticeActivity({Key? key}) : super(key: key);

  @override
  State<NoticeActivity> createState() => _NoticeActivityState();
}

class _NoticeActivityState extends State<NoticeActivity> {
  final List<AlertsReminderResponse> _lstData = [];

  @override
  void initState() {
    _getHSList();
    super.initState();
  }

  void _getHSList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd, "USER_ROLE": userData.userType};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_REMINDER, data, true);
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = AlertsReminderResponse.fromJson(i);
          _lstData.add(data);
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
          title: Text(getTranlateString("notification")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: _lstData.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: _lstData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return getRowForConst(index);
                  })
              : CustomView.getNoRecordView(context),
        ));
  }

  Widget getRowForConst(int index) {
    var data = _lstData[index];
    return InkWell(
      onTap: () {
        if (data.iSRESPONSEREQUIRED == "Y") {}
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(data.tEXTMESSAGE ?? "",
                        style: getHeaderStyle(data.iSRESPONSEREQUIRED == "Y")),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle getHeaderStyle(bool isRespocible) {
  return TextStyle(
      color: isRespocible ? Colors.blue : Colors.black,
      fontWeight: FontWeight.bold);
}
