import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/comment.dart';
import 'package:beatapp/model/request/save_comment_request.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class CharacterShoFeedbackActivity extends StatefulWidget {
  final data;

  const CharacterShoFeedbackActivity({Key? key, required this.data})
      : super(key: key);

  @override
  State<CharacterShoFeedbackActivity> createState() =>
      _CharacterShoFeedbackActivityState(data);
}

//END_POINT_GET_CITIZEN_MESSAGE_REMARK
class _CharacterShoFeedbackActivityState
    extends State<CharacterShoFeedbackActivity> {
  var con_Comment = TextEditingController();
  String? sR_NUM;

  _CharacterShoFeedbackActivityState(data) {
    sR_NUM = data["SR_NUM"];
  }

  late List<Comment> listComment = [];

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    _getChatList();
    super.initState();
  }

  void _getChatList() async {
    var data = {"PERSONID": sR_NUM};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_CITIZEN_MESSAGE_REMARK, data, true);
    if (response.statusCode == 200) {
      listComment = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = Comment.fromJson(i);
          listComment.add(data);
        }
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  void _saveComment() async {
    var userData = await LoginResponseModel.fromPreference();
    SaveCommentRequest request = SaveCommentRequest(
        userData.psCd,
        userData.personName,
        userData.officerRank,
        con_Comment.text,
        sR_NUM,
        sR_NUM,
        "00.1",
        "00.2");
    var data = request.toCitizenMsgJson();
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_SAVE_CITIZENS_MESSAGE_REMARK, data, true);
    if (response.statusCode == 200) {
      con_Comment.text = "";
      _getChatList();
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("important_information")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: listComment.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: listComment.length,
                        itemBuilder: (BuildContext context, int index) {
                          return getRowForConst(index);
                        })
                    : CustomView.getNoRecordView(context),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width * .96,
                  height: 35,
                  margin: const EdgeInsets.only(bottom: 5),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: con_Comment,
                          style: const TextStyle(),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              counterText: "",
                              hintText: getTranlateString("comment_hint"),
                              contentPadding:
                                  const EdgeInsets.only(bottom: 15)),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            con_Comment.text.trim().isNotEmpty
                                ? _saveComment()
                                : "";
                          },
                          child: const Icon(Icons.send))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget getRowForConst(int index) {
    var data = listComment[index];
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
      child: Expanded(
        flex: 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(AppTranslations.of(context)!.text("name"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.appUserName ?? ""),
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
                    child: Text(AppTranslations.of(context)!.text("rank"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.appUserRank ?? ""),
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
                    child: Text(AppTranslations.of(context)!.text("remark"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.remarks ?? ""),
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
                    child: Text(AppTranslations.of(context)!.text("date"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.fillDt ?? ""),
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

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
