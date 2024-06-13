import 'dart:async';
import 'dart:io';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/information_detail_table.dart';
import 'package:beatapp/ui/citizen_messages/sho/citizen_messages_Sho_feedback_view.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/loaction_utils.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/navigator_utils.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class ConsCitizenMessagesInfoSubmitActivity extends StatefulWidget {
  final data;
  const ConsCitizenMessagesInfoSubmitActivity({Key? key,this.data}) : super(key: key);

  @override
  State<ConsCitizenMessagesInfoSubmitActivity> createState() => _ConsCitizenMessagesInfoSubmitActivityState(data);
}

class _ConsCitizenMessagesInfoSubmitActivityState extends BaseFullState<ConsCitizenMessagesInfoSubmitActivity> {
  InformationDetail_Table infoDetails = InformationDetail_Table.emptyData();
  final formKey = GlobalKey<FormState>();
  var PERSONID;
  bool IS_RESOLVED = false;
  String PHOTO = "";
  var con_Details = TextEditingController();

  _ConsCitizenMessagesInfoSubmitActivityState(data) {
    PERSONID = data["PERSONID"];
  }

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      _getShareInfoDetails();
    });
  }

  void _getShareInfoDetails() async {
    var data = {"PERSONID": PERSONID};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_CITIZEN_MESSAGE_DETAIL, data, true);
    if (response.statusCode == 200) {
      try {
        infoDetails =
            InformationDetail_Table.fromJson(response.data["Table"][0]);
        setState(() {});
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
  }

  void saveData() async {
    var position = await LocationUtils().determinePosition();


    var data = {
      "PERSONID":PERSONID,
      "IS_RESOLVED":IS_RESOLVED ? "Y" : "N",
      "LAT": position.latitude.toString(),
      "LONG": position.longitude.toString(),
      "PHOTO":PHOTO,
      "REMARKS":con_Details.text.toString(),
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.SUBMIT_CS_SHARED_INFO_VERIFICATION, data, false);
    Navigator.pop(context);
    if (response.statusCode == 200 && response.data == 1) {
      getDashBoardCount();
      MessageUtility.showToast(context, getTranlateString("success_msg"));
      Navigator.pop(context, true);
    } else {
      MessageUtility.showToast(context, getTranlateString("error_msg"));
    }
  }

  radioOnchangeResolve(value) {
    IS_RESOLVED = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("citizens_messages")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                getTranlateString("completed"),
                textAlign: TextAlign.left,
              ),
              5.height,
              Container(
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
                              value: IS_RESOLVED,
                              onChanged:(v)=> radioOnchangeResolve(true),
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
                              value: !IS_RESOLVED,
                              onChanged:(v)=> radioOnchangeResolve(false),
                              activeColor: Colors.red),
                          Text(getTranlateString("no"))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              5.height,
              Text(
                getTranlateString("remarks"),
              ),
              5.height,
              Form(
                key: formKey,
                child: EditTextBorder(
                  controller: con_Details,
                  validator: Validations.emptyValidator,
                  suffixIcon: const Icon(Icons.mic,size: 18,),
                ),
              ),

              5.height,
              Text(
                getTranlateString("upload_photo"),
              ),
              5.height,
              Container(
                height: 100,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                  right: 5,
                  left: 5,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                        color: Colors.black, width: 1.0)),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () async {
                          File? image = await CameraAndFileProvider()
                              .pickImageFromCamera();
                          if(image!=null){
                            PHOTO = Base64Helper.encodeImage(image);
                            setState(() {});
                          }

                        },
                        child: const Icon(Icons.camera_alt)),
                    if (PHOTO!="")
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 26),
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ImageViewer(
                                              data: {"image": PHOTO},
                                            ),
                                      ));
                                },
                                child:Image.memory(
                                  Base64Helper.decodeBase64Image(PHOTO),
                                  height: 80,
                                  width: 80,
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 26),
                            child: InkWell(
                              onTap: () {
                                PHOTO = "";
                                setState(() {});
                              },
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
              12.height,
              Button(
                width: double.maxFinite,
                title: "submit",
                onPressed: (){
                  if(formKey.currentState!.validate()){
                    DialogHelper.showLoaderDialog(context);
                    saveData();
                  }

                },
              ),

              Container(
                margin: const EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width * .96,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    getTranlateString("information_type"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            infoDetails.sHAREINFOTYPE ?? "",
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
                    getTranlateString("date_time_information_sharing"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            infoDetails.rECORDDATETIME ?? "",
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
                    getTranlateString("name_of_informer"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            infoDetails.nAME ?? "",
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
                    top: 8,
                    bottom: 8,
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
                          child: Text(
                            infoDetails.dISTRICT ?? "",
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
                    top: 8,
                    bottom: 8,
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
                          child: Text(
                            infoDetails.pS ?? "",
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
                    getTranlateString("village_town_city"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            infoDetails.address ?? "",
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            infoDetails.mOBILENO ?? "",
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
                    getTranlateString("suspect_name_object"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            infoDetails.sUSpectNAme ?? "",
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
                    getTranlateString("place_of_occurrence"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            infoDetails.occPLace ?? "",
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
                    getTranlateString("information_detail"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            infoDetails.dESCRIPTION ?? "",
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                              width: MediaQuery.of(context).size.width * .96,
                              height: 100,
                              margin: const EdgeInsets.only(right: 5),
                              alignment: Alignment.center,
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
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: infoDetails.iMAGE != null
                                  ? Image.memory(
                                Base64Helper.decodeBase64Image(
                                    infoDetails.iMAGE!),
                                height: 80,
                                width: 80,
                                alignment: Alignment.center,
                                fit: BoxFit.fill,
                              )
                                  : Image.asset(
                                'assets/images/ic_image_placeholder.png',
                                height: 80,
                                width: 80,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              width: MediaQuery.of(context).size.width * .96,
                              height: 100,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 5),
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
                                  border: Border.all(
                                      color: Colors.black, width: 1.0)),
                              child: InkWell(
                                onTap: () => {
                                  NavigatorUtils.launchMapsUrlFromLatLong(
                                      double.parse(infoDetails.lAT ?? "0"),
                                      double.parse(infoDetails.lONG ?? "0"))
                                },
                                splashColor: Colors.grey,
                                child: Image.asset(
                                  'assets/images/ic_map.png',
                                  height: 80,
                                  width: 80,
                                ),
                              )),
                        ),
                      ],
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10),
                child: InkWell(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CitizenMessagesShoFeedbackActivity(
                                data: {"SR_NUM": PERSONID},
                              ),
                        ))
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 40,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      color: Color(ColorProvider.colorPrimary),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      AppTranslations.of(context)!.text("progress_report"),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
