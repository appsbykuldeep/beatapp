import 'dart:async';
import 'dart:io';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/beat.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;

class SaveImportantInformationFragment extends StatefulWidget {
  const SaveImportantInformationFragment({Key? key}) : super(key: key);

  @override
  State<SaveImportantInformationFragment> createState() =>
      _SaveImportantInformationFragmentState();
}

class _SaveImportantInformationFragmentState
    extends State<SaveImportantInformationFragment> {
  var con_Details = TextEditingController();
  String isInformation = "Y";
  String isHeinous = "N";
  String FILEDETAIL = "";
  String FILE_NAME = "";
  double FILE_SIZE = 0;
  String FILE_TYPE = "";

  late String dropdownValueBeat;
  List<String> spinnerItemsBeat = [];

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      _getBeatList();
    });
  }

  void _getBeatList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_GET_BEAT_MASTER, data, true);
    if (response.statusCode == 200) {
      dropdownValueBeat = "${getTranlateString("all_beat")}#-1";
      spinnerItemsBeat = [dropdownValueBeat];
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = Beat.fromJson(i);
          spinnerItemsBeat.add("${data.beatName!}#${data.beatCD!}");
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

  void saveInformation() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "BEAT_CD": getSelectedBeatId(),
      "DISTRICT_CD": userData.districtCD,
      "FILEDETAIL": FILEDETAIL,
      "FILE_NAME": FILE_NAME,
      "FILE_SIZE": FILE_SIZE,
      "FILE_TYPE": FILE_TYPE,
      "INFO_DETAIL": con_Details.text,
      "IS_ALL": "Y",
      "IS_HENIOUS": isHeinous,
      "IS_INFO": isInformation,
      "PS_CD": userData.psCd
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_SAVE_SOOCHNA, data, false);
    Navigator.pop(context);
    if (response.statusCode == 200 && response.data == 1) {
      con_Details.text = "";
      FILEDETAIL = "";
      MessageUtility.showToast(context, getTranlateString("success_msg"));
      setState(() {});
    } else {
      MessageUtility.showToast(context, getTranlateString("error_msg"));
    }
  }

  String getSelectedBeatId() {
    return dropdownValueBeat.split("#")[1];
  }

  radioOnchange(value) {}

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: formKey,
        child: Column(
          children: [
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
                              value: isInformation == "Y" ? false : true,
                              onChanged: (value) {
                                isInformation = "N";
                                setState(() {});
                              },
                              activeColor: Colors.red),
                          Text(getTranlateString("incident"))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Checkbox(
                              value: isInformation == "Y" ? true : false,
                              onChanged: (value) {
                                isInformation = "Y";
                                setState(() {});
                              },
                              activeColor: Colors.red),
                          Text(getTranlateString("information"))
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
                  getTranlateString("heinous"),
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
                              value: isHeinous == "Y" ? true : false,
                              onChanged: (value) {
                                isHeinous = "Y";
                                setState(() {});
                              },
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
                              value: isHeinous == "Y" ? false : true,
                              onChanged: (value) {
                                isHeinous = "N";
                                setState(() {});
                              },
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
                  getTranlateString("details"),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            4.height,
            EditTextBorder(
              controller: con_Details,
              validator: Validations.emptyValidator,
              suffixIcon: const Icon(Icons.mic),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: MediaQuery.of(context).size.width * .96,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  getTranlateString("upload_photo"),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Container(
                width: MediaQuery.of(context).size.width * .96,
                height: 100,
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
                    InkWell(
                        onTap: () async {
                          File? image = await CameraAndFileProvider()
                              .pickImageFromCamera();
                          if (image != null) {
                            FILEDETAIL = Base64Helper.encodeImage(image);
                            FILE_NAME =
                                "${DateTime.now().microsecondsSinceEpoch}BeatPolicing";
                            FILE_TYPE = ".png";
                            final bytes =
                                (await image.readAsBytes()).lengthInBytes;
                            FILE_SIZE = bytes / 1024;
                            setState(() {});
                          }
                        },
                        child: const Icon(Icons.camera_alt)),
                    FILEDETAIL != ""
                        ? Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 26),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImageViewer(
                                              data: {"image": FILEDETAIL},
                                            ),
                                          ));
                                    },
                                    child: Image.memory(
                                      Base64Helper.decodeBase64Image(
                                          FILEDETAIL),
                                      height: 80,
                                      width: 80,
                                    )),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 26),
                                child: InkWell(
                                  onTap: () {
                                    FILEDETAIL = "";
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
                        : const SizedBox()
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
              margin: const EdgeInsets.only(top: 2),
              child: InkWell(
                child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: spinnerItemsBeat.length > 1
                        ? DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValueBeat,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (String? data) {
                              setState(() {
                                dropdownValueBeat = data!;
                              });
                            },
                            items: spinnerItemsBeat
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.split("#")[0],
                                    style:
                                        const TextStyle(color: Colors.black)),
                              );
                            }).toList(),
                          )
                        : const SizedBox()),
              ),
            ),
            8.height,
            Button(
              title: "submit",
              width: double.maxFinite,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  DialogHelper.showLoaderDialog(context);
                  saveInformation();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
