// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/entities/information_type.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/loaction_utils.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/validations.dart';
import 'package:flutter/material.dart';

class ShareInformationFragment extends StatefulWidget {
  const ShareInformationFragment({Key? key}) : super(key: key);

  @override
  State<ShareInformationFragment> createState() =>
      _ShareInformationFragmentState();
}

class _ShareInformationFragmentState extends State<ShareInformationFragment> {
  final conDetails = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isInformation = false;
  bool isHeinous = false;
  bool isAll = false;
  String FILEDETAIL = "";
  String FILE_NAME = "";
  double FILE_SIZE = 0;
  String FILE_TYPE = "";

  late String dropdownValueInfoType;
  List<String> spinnerItemsInfoType = [];

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      getInformationTypeList();
    });
  }

  String getSelectedInfoType() {
    return dropdownValueInfoType.split("#")[0];
  }

  String getSelectedInfoTypeCD() {
    return dropdownValueInfoType.split("#")[1];
  }

  void getInformationTypeList() async {
    var lst = await InformationType.getInfoTypeList();
    if (lst.isNotEmpty) {
      for (int i = 0; i < lst.length; i++) {
        if (i == 0) {
          dropdownValueInfoType =
              "${lst[i].informationType!}#${lst[i].informationCD!}";
        }
        spinnerItemsInfoType
            .add("${lst[i].informationType!}#${lst[i].informationCD!}");
      }
    }
    setState(() {});
  }

  void saveInformation() async {
    var position = await LocationUtils().determinePosition();
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "DISTRICT_CD": userData.districtCD,
      "FILEDETAIL": FILEDETAIL,
      "FILE_NAME": FILE_NAME,
      "FILE_SIZE": FILE_SIZE,
      "FILE_TYPE": FILE_TYPE,
      "INFO_DETAIL": conDetails.text,
      "IS_ALL": isAll ? "Y" : "N",
      "IS_HENIOUS": isHeinous ? 1 : 0,
      "IS_INFO": isInformation ? 1 : 0,
      "PS_CD": userData.psCd,
      "INCIDENT_TYPE_CD": isInformation ? "0" : getSelectedInfoTypeCD(),
      "INFO_TYPE": getSelectedInfoType(),
      "INFO_TYPE_CD": isInformation ? getSelectedInfoTypeCD() : "0",
      "LATITUDE": position.latitude.toString(),
      "LONGITUDE": position.longitude.toString(),
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.END_POINT_SAVE_SHARED_INFO, data, false);
    Navigator.pop(context);

    if (response.statusCode == 200 && response.data == 1) {
      conDetails.text = "";
      FILEDETAIL = "";
      MessageUtility.showToast(context, getTranlateString("success_msg"));
      setState(() {});
    } else {
      MessageUtility.showToast(context, getTranlateString("error_msg"));
    }
  }

  radioOnchangeIsInformation(value) {
    isInformation = value;
    setState(() {});
  }

  radioOnchangeIsHeinous(value) {
    isHeinous = value;
    setState(() {});
  }

  radioOnchangeIsAll(value) {
    isAll = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
              right: 5,
              left: 5,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Checkbox(
                          value: !isInformation,
                          onChanged: (v) => radioOnchangeIsInformation(false),
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
                          value: isInformation,
                          onChanged: (v) => radioOnchangeIsInformation(true),
                          activeColor: Colors.red),
                      Text(getTranlateString("information"))
                    ],
                  ),
                )
              ],
            ),
          ),
          8.height,
          Text(
            getTranlateString("heinous"),
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
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Checkbox(
                          value: isHeinous,
                          onChanged: (v) => radioOnchangeIsHeinous(true),
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
                          value: !isHeinous,
                          onChanged: (v) => radioOnchangeIsHeinous(false),
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
            getTranlateString("share_to_all_beat"),
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
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Checkbox(
                          value: isAll,
                          onChanged: (v) => radioOnchangeIsAll(true),
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
                          value: !isAll,
                          onChanged: (v) => radioOnchangeIsAll(false),
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
            getTranlateString("type_of_information"),
          ),
          5.height,
          InkWell(
            child: Container(
              width: MediaQuery.of(context).size.width * .96,
              padding: const EdgeInsets.only(right: 10, left: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.black, width: 1.0)),
              child: spinnerItemsInfoType.isNotEmpty
                  ? DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValueInfoType,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? data) {
                        setState(() {
                          dropdownValueInfoType = data!;
                        });
                      },
                      items: spinnerItemsInfoType
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.split("#")[0],
                              style: const TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                    )
                  : const SizedBox(),
            ),
          ),
          5.height,
          Text(
            getTranlateString("details"),
          ),
          5.height,
          Form(
            key: formKey,
            child: EditTextBorder(
              controller: conDetails,
              validator: Validations.emptyValidator,
              suffixIcon: const Icon(
                Icons.mic,
                size: 18,
              ),
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
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.black, width: 1.0)),
            child: Row(
              children: [
                InkWell(
                    onTap: () async {
                      File? image =
                          await CameraAndFileProvider().pickImageFromCamera();
                      if (image != null) {
                        FILEDETAIL = Base64Helper.encodeImage(image);
                        FILE_NAME =
                            "${DateTime.now().microsecondsSinceEpoch}BeatPolicing";
                        FILE_TYPE = ".png";
                        final bytes = (await image.readAsBytes()).lengthInBytes;
                        FILE_SIZE = bytes / 1024;
                        setState(() {});
                      }
                    },
                    child: const Icon(Icons.camera_alt)),
                if (FILEDETAIL != "")
                  Row(
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
                              Base64Helper.decodeBase64Image(FILEDETAIL),
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
              ],
            ),
          ),
          12.height,
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
    );
  }
}
