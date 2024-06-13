import 'dart:async';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/group_comments.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class GroupChatActivity extends StatefulWidget {
  final data;

  const GroupChatActivity({Key? key, required this.data}) : super(key: key);

  @override
  State<GroupChatActivity> createState() => _GroupChatActivityState(data);
}

class _GroupChatActivityState extends State<GroupChatActivity> {
  var con_Comment = TextEditingController();
  String GROUP_ID = "";

  _GroupChatActivityState(data) {
    GROUP_ID = data["GROUP_ID"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  late List<GroupComments> listComment = [];

  final formKey=GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      _getChatList();
    });
  }

  void _getChatList() async {
    var data = {"GROUP_ID": GROUP_ID};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_NOTIFICATION, data, true);
    if (response.statusCode == 200) {
      listComment = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = GroupComments.fromJson(i);
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

    var data = {"GROUP_ID": GROUP_ID, "NOTIFICATION_TEXT": con_Comment.text};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SEND_NOTIFICATION, data, true);
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
          title: Text(getTranlateString("comments")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              listComment.isNotEmpty
                  ? Expanded(
                      flex: 1,
                      child: ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: listComment.length,
                          itemBuilder: (BuildContext context, int index) {
                            return getRowForConst(index);
                          }))
                  : CustomView.getNoRecordView(context),

              5.height,
              Form(
                key: formKey,
                child: EditTextBorder(
                  hintText: getTranlateString("comment_hint"),
                  controller: con_Comment,
                  validator: Validations.emptyValidator,
                  suffixIcon:  InkWell(
                      onTap: () {
                        if(formKey.currentState!.validate()){
                          _saveComment();
                        }
                      },
                      child: const Icon(Icons.send)),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(data.sentByName ?? "",
                      style: TextStyle(
                          color: Color(
                            ColorProvider.colorPrimary,
                            ),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(data.sentByRank ?? "",
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w100)),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(data.notificationText ?? "",
                        style: const TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(data.sentOn ?? "",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.grey,
                        )),
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
