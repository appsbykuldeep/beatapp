// ignore_for_file: use_build_context_synchronously

import 'package:beatapp/api/api_connection.dart' as httprequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/beat_assignment_list_response.dart';
import 'package:beatapp/model/response/get_constable_details.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class BeatListFragment extends StatefulWidget {
  const BeatListFragment({Key? key}) : super(key: key);

  @override
  State<BeatListFragment> createState() => _BeatListFragmentState();
}

class _BeatListFragmentState extends BaseFullState<BeatListFragment> {
  late List<BeatAssignmentListResponse> lstBeatAllocation = [];

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    _getBeatAllocationList();
    super.initState();
  }

  void _getBeatAllocationList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await httprequst.postRequestWithTokenAndBody(
      context,
      EndPoints.VIEW_BEAT_ASSIGNMENT_LIST,
      data,
      true,
    );
    if (response.statusCode == 200) {
      lstBeatAllocation = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = BeatAssignmentListResponse.fromJson(i);
          if (data.beatPersonDetails != null) {
            lstBeatAllocation.add(data);
          }
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

  void _deleteConstable(String beatCd, String CUG) async {
    var data = {"BEAT_CD": beatCd, "BEAT_CUG": CUG};
    var response = await httprequst.postRequestWithTokenAndBody(
        context, EndPoints.REMOVE_BEAT_ASSIGNMENT, data, true);
    if (response.statusCode == 200) {
      if (response.data.toString() == "1") {
        _getBeatAllocationList();
        MessageUtility.showToast(
            context, getTranlateString("delete_beat_success_msg"));
      } else {
        MessageUtility.showToast(context, getTranlateString("error_msg"));
      }
    } else {
      MessageUtility.showToast(context, getTranlateString("error_msg"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(3, 5, 12, 8),
        child: CustomView.getCountView(context, lstBeatAllocation.length),
      ),
      lstBeatAllocation.isNotEmpty
          ? Expanded(
              flex: 1,
              child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                  itemCount: lstBeatAllocation.length,
                  physics: const RangeMaintainingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return getRowForConst(index);
                  }),
            )
          : CustomView.getNoRecordView(context),
      InkWell(
        onTap: () {
          if (lstBeatAllocation.isNotEmpty) {
            showDownloadOption(
                onXlsxClick: () {
                  BeatAssignmentListResponse.generateExcel(
                      context, lstBeatAllocation);
                },
                onPdfClick: () {});
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
    ]);
  }

  Widget getRowForConst(int index) {
    var data = lstBeatAllocation[index];
    List<GetConstableDetails> lstCons =
        GetConstableDetails.fromString(data.beatPersonDetails!);
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
                  child: Text(AppTranslations.of(context)!.text("beat_name"),
                      style: getHeaderStyle()),
                ),
                Expanded(
                  flex: 1,
                  child: Text(data.beatName ?? ""),
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
                      AppTranslations.of(context)!.text("distribution_date"),
                      style: getHeaderStyle()),
                ),
                Expanded(
                  flex: 1,
                  child: Text(data.assignmentDt ?? ""),
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
                    AppTranslations.of(context)!.text("beat_area"),
                    style: getHeaderStyle(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(data.beatName ?? ""),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * .96,
            decoration: BoxDecoration(
                color: Color(ColorProvider.indigo_100),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    getTranlateString("beat_constable"),
                    style: getHeaderStyle(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child:
                      Text(getTranlateString("pno"), style: getHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Text(getTranlateString("rank"),
                        style: getHeaderStyle()),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .96,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Color(ColorProvider.white),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: lstCons.length,
                physics: const RangeMaintainingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return getRowForChild(data.beatCd, lstCons[index]);
                }),
          )
        ],
      ),
    );
  }

  Widget getRowForChild(beatCd, data) {
    return Container(
      width: MediaQuery.of(context).size.width * .90,
      decoration: BoxDecoration(
        color: Color(ColorProvider.white),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    data.NAME ?? "",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    data.CUG ?? "",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    data.OFFICER_RANK ?? "",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        DialogHelper.showCallDialog(
                            context,
                            "${getTranlateString("delete")} : " + data.NAME!,
                            getTranlateString("constable_delete_prompt"),
                            () => {_deleteConstable(beatCd, data.CUG)});
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width * .96,
            decoration: const BoxDecoration(color: Colors.grey),
          )
        ],
      ),
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
