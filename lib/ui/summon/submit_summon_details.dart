import 'dart:convert';
import 'dart:io';

import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/custom_dropdown_wid.dart';
import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/database/asset_db_helper.dart';
import 'package:beatapp/entities/relation_type.dart';
import 'package:beatapp/entities/warrant_exec_type.dart';
import 'package:beatapp/utility/api_call_func.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/camera_and_file_provider.dart';
import 'package:beatapp/utility/extentions/context_ext.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/extentions/string_ext.dart';
import 'package:beatapp/utility/extentions/textediting_ctrl_ext.dart';
import 'package:beatapp/utility/get_lang_code.dart';
import 'package:beatapp/utility/loaction_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class SubmitSummonDetails extends StatefulWidget {
  final String SUMM_WARR_NUM;

  /// 1 for summon 2 for Warrant
  final int SUMM_WARR_NATURE;
  const SubmitSummonDetails({
    super.key,
    required this.SUMM_WARR_NUM,
    required this.SUMM_WARR_NATURE,
  });

  @override
  State<SubmitSummonDetails> createState() => _SubmitSummonDetailsState();
}

class _SubmitSummonDetailsState extends State<SubmitSummonDetails> {
  TextEditingController personNameCtrl = TextEditingController();
  TextEditingController remarkCtrl = TextEditingController();
  int LANG_CD = 0;

  LocationUtils locationUtil = LocationUtils();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<RelationType> allRelationTypesList = [];
  List<WarrantExecType> warrantExecTypeList = [];

  RelationType? selectedRelationType;
  WarrantExecType? selectedwarrantExecType;
  Position? position;
  final isCompleted = false.obs;
  final PHOTO = "".obs;

  late final bool isWarrant = widget.SUMM_WARR_NATURE == 2;

  void onPageInit() {
    LANG_CD = getLangCode();

    allRelationTypesList = AssetDbHelper.allRelationTypesList
        .where((e) => e.LANG_CD == LANG_CD)
        .toList();
    warrantExecTypeList = AssetDbHelper.warrantExecTypeList;

    allRelationTypesList.insert(
      0,
      RelationType(
        RELATION_TYPE: "select_relation_type".translation,
      ),
    );
    warrantExecTypeList.insert(
      0,
      WarrantExecType(
        executionType: "select_type_of_execution".translation,
      ),
    );

    selectedRelationType = allRelationTypesList.firstOrNull;
    selectedwarrantExecType = warrantExecTypeList.firstOrNull;

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      position = await locationUtil.determinePosition();
      setState(() {});
    });
  }

  Future<void> submitSummonDetails() async {
    if (!formKey.currentState!.validate()) return;

    Map<String, dynamic> body = {
      "SUMM_WARR_NUM": widget.SUMM_WARR_NUM,
      "TYPE": EndPoints.TYPE,
      "EXECTYPECD": selectedwarrantExecType?.execTypeCD,
      "EXECREMARKS": remarkCtrl.trimText,
      "LAT": position!.latitude.toString(),
      "LONG": position!.longitude.toString(),
      "RELATION_CD": selectedRelationType?.RELATION_TYPE_CD,
      "DELEIVERED_TO_NAME": personNameCtrl.trimText,
      "IS_DELIVERED": isCompleted.value ? "Y" : "N",
      "SUMM_WARR_NATURE": widget.SUMM_WARR_NATURE.toString(),
      "PHOTO": base64Decode(PHOTO.value),
    };

    final resp = await dioApiCall(
      endPoint: EndPoints.SUBMIT_SUMMON_DETAILS,
      apibody: body,
    );

    if (resp.resultStatus && resp.resultData.toString() == "1") {
      Get.back(result: true);
      "Details submited successfully !".showTost();
    } else {
      "Failed to submit details !".showTost();
    }
  }

  @override
  void initState() {
    onPageInit();
    super.initState();
  }

  @override
  void dispose() {
    personNameCtrl.dispose();
    remarkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isWarrant ? "Submit Warrant Details" : "Submit Summon Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("completed".translation),
                  Expanded(
                    child: Obx(
                      () => RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                          children: [
                            WidgetSpan(
                              child: Radio(
                                groupValue: isCompleted.value,
                                value: true,
                                onChanged: (value) {
                                  isCompleted.value = value ?? false;
                                },
                              ),
                              alignment: PlaceholderAlignment.middle,
                            ),
                            const TextSpan(
                              text: "Yes\t",
                            ),
                            WidgetSpan(
                              child: Radio(
                                groupValue: isCompleted.value,
                                value: false,
                                onChanged: (value) {
                                  isCompleted.value = value ?? false;
                                },
                              ),
                              alignment: PlaceholderAlignment.middle,
                            ),
                            const TextSpan(
                              text: "No",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              16.height,
              Text(
                "type_of_execution".translation,
              ),
              DropdownWid(
                itemslist: warrantExecTypeList,
                selectedvalue: selectedwarrantExecType,
                validator: (p0) {
                  if (p0?.execTypeCD == 0) {
                    return "select_type_of_execution".translation;
                  }
                  return null;
                },
                onchange: (val) {
                  selectedwarrantExecType = val;
                },
              ),
              16.height,
              Text(
                isWarrant
                    ? "Name of the person who receive warrant"
                    : "Name of the person who receive summon",
              ),
              TextFormField(
                maxLines: 1,
                minLines: 1,
                maxLength: 100,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                controller: personNameCtrl,
                validator: (value) {
                  if ((value ?? "").trim().isEmpty) {
                    return "Fill person name";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                ),
              ),
              16.height,
              const Text(
                "Remark",
              ),
              TextFormField(
                minLines: 3,
                maxLines: 5,
                maxLength: 1000,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.multiline,
                controller: remarkCtrl,
                validator: (value) {
                  if ((value ?? "").trim().isEmpty) {
                    return "Fill remark";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                ),
              ),
              16.height,
              Text(
                "relation_type".translation,
              ),
              DropdownWid(
                itemslist: allRelationTypesList,
                selectedvalue: selectedRelationType,
                validator: (p0) {
                  if (p0?.RELATION_TYPE_CD == 0) {
                    return "select_type_of_execution".translation;
                  }
                  return null;
                },
                onchange: (val) {
                  selectedRelationType = val;
                },
              ),
              16.height,
              Text(
                "upload_photo".translation,
              ),
              5.height,
              Obx(
                () => InkWell(
                  onTap: () async {
                    File? image =
                        await CameraAndFileProvider().pickImageFromCamera();
                    if (image != null) {
                      PHOTO.value = Base64Helper.encodeImage(image);
                    }
                  },
                  child: Container(
                    height: 100,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.camera_alt,
                          size: 40,
                        ),
                        if (PHOTO.value.isNotEmpty)
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 26),
                                  child: InkWell(
                                      onTap: () {
                                        context.push(ImageViewer(
                                          data: {"image": PHOTO.value},
                                        ));
                                      },
                                      child: Image.memory(
                                        Base64Helper.decodeBase64Image(
                                            PHOTO.value),
                                        height: 80,
                                        width: 80,
                                      )),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 26),
                                  child: InkWell(
                                    onTap: () {
                                      PHOTO.value = "";
                                    },
                                    child: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              16.height,
              RichText(
                text: TextSpan(
                  style: context.textTheme.labelMedium,
                  text: "location".translation,
                  children: const [
                    TextSpan(text: "\t"),
                    WidgetSpan(
                      child: Icon(
                        Icons.location_on,
                        size: 18,
                      ),
                      alignment: PlaceholderAlignment.bottom,
                    ),
                  ],
                ),
              ),
              5.height,
              position == null
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Latitude : ${position!.latitude.toStringAsFixed(6)}"),
                        Text(
                            "Longitude : ${position!.longitude.toStringAsFixed(6)}"),
                      ],
                    ),
              if (position != null)
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 50),
                  child: Center(
                    child: FilledButton(
                      onPressed: submitSummonDetails,
                      child: Text(
                        "submit".translation,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
