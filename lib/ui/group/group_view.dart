import 'dart:async';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/get_group_list_response.dart';
import 'package:beatapp/ui/group/groupchat/group_chat_view.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class GroupActivity extends StatefulWidget {
  final data;

  const GroupActivity({Key? key, this.data}) : super(key: key);

  @override
  State<GroupActivity> createState() => _GroupActivityState();
}

class _GroupActivityState extends State<GroupActivity> {
  late List<GetGroupListResponse> lstGroup = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      _getGroupList();
    });
  }

  void _getGroupList() async {
    var data = {};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_GROUP_LIST, data, true);
    if (response.statusCode == 200) {
      lstGroup = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var office = GetGroupListResponse.fromJson(i);
          lstGroup.add(office);
        }
        setState(() {});
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
        title: Text(getTranlateString("group")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Container(
        child: Column(
          children: [
            lstGroup.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: lstGroup.length,
                        itemBuilder: (BuildContext context, int index) {
                          return getRowForConst(index);
                        }))
                : CustomView.getNoRecordView(context)
          ],
        ),
      ),
    );
  }

  Widget getRowForConst(int index) {
    var data = lstGroup[index];
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    GroupChatActivity(data: {"GROUP_ID": data.gROUPID}),
              ));
        },
        child: Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  //BoxShadow
                ]),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/team.png",
                    height: 60,
                    width: 60,
                  ),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            data.gROUPNAME ?? "",
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Text(
                            "${data.tOTALUSERS ?? ""} Members",
                            style: const TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            )));
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
