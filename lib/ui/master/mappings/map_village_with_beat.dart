import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/model/response/village_beat_details_response.dart';
import 'package:beatapp/ui/dialog/dialog_helper.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:beatapp/api/api_connection.dart' as HttpRequst;

class MapVillageWithBeat extends StatefulWidget {
  const MapVillageWithBeat({super.key});

  @override
  State<MapVillageWithBeat> createState() => _MapVillageWithBeatState();
}

class _MapVillageWithBeatState extends State<MapVillageWithBeat> {
  List<VillageBeatDetailsResponse> villageStreet_list = [];
  List<VillageBeatDetailsResponse> beat_list = [];
  List<String> villageList = ["Select"];
  List<String> beatNameList = ["Select"];
  String villageName = "Select";
  String beatName = "Select";
  bool isLoading = true;

  void _getVillageList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"DISTRICT_CD": userData.districtCD, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_Village_DETAILS, data, true);
    print("code ${response.statusCode}");
    if (response.statusCode == 200) {
      print(response.data);
      try {
        for (Map<String, dynamic> i in response.data) {
          var office = VillageBeatDetailsResponse.fromJson(i);
          villageStreet_list.add(office);
        }
        villageList.addAll(
            villageStreet_list.map((e) => e.ENGLISH_NAME ?? "Select").toList());
      } catch (e) {
        e.toString();
      }
      _getBeatList();
    } else {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text(response.statusMessage!));
    }
  }

  void _getBeatList() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {"DISTRICT_CD": userData.districtCD, "PS_CD": userData.psCd};
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.BEAT_VIEW_LIST, data, false);
    if (response.statusCode == 200) {
      try {
        for (Map<String, dynamic> i in response.data) {
          var data = VillageBeatDetailsResponse.fromJson(i);
          beat_list.add(data);
        }
        beatNameList.addAll(
            beat_list.map((e) => e.BEAT_NAME_ENGLISH ?? 'Select').toList());
      } catch (e) {
        e.toString();
      }
    }
    isLoading = false;
    setState(() {});
  }

  String BEAT_CD = "";
  String VILL_STR_ST_NUM = "";
  String REGIONAL_NAME = "";

  void _mapVillageBeat() async {
    var userData = await LoginResponseModel.fromPreference();
    var data = {
      "DISTRICT_CD": userData.districtCD,
      "PS_CD": userData.psCd,
      "BEAT_CD": BEAT_CD,
      "VILL_STR_ST_NUM": VILL_STR_ST_NUM,
      "REGIONAL_NAME": REGIONAL_NAME,
      "ENGLISH_NAME": villageName,
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.mapVillageMasterToBeat, data, false);
    Navigator.pop(context);
    print("Codess ${response.statusCode}");

    if (response.statusCode == 200) {
    } else if (response.statusCode == 404) {
      MessageUtility.showToast(
          context, AppTranslations.of(context)!.text("Url not found!"));
    }
  }

  @override
  void initState() {
    _getVillageList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorProvider.blueColor,
        title: const Text("Village and Beats Mapping"),
      ),
      body: isLoading
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Beats"),
                  4.height,
                  Container(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey)),
                    child: DropdownButton<String>(
                      value: beatName,
                      isExpanded: true,
                      underline: const SizedBox(
                        width: 0,
                      ),
                      elevation: 16,
                      onChanged: (String? value) {
                        beatName = value!;
                        if (value != "Select") {
                          BEAT_CD = beat_list
                              .firstWhere((element) =>
                                  element.BEAT_NAME_ENGLISH == value)
                              .BEAT_CD!;
                        }
                        setState(() {});
                      },
                      items: beatNameList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text("Villages"),
                  4.height,
                  Container(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey)),
                    child: DropdownButton<String>(
                      value: villageName,
                      isExpanded: true,
                      underline: const SizedBox(
                        width: 0,
                      ),
                      elevation: 16,
                      onChanged: (String? value) {
                        villageName = value!;
                        if (value != "Select") {
                          final village = villageStreet_list.firstWhere(
                              (element) => element.ENGLISH_NAME == value);
                          VILL_STR_ST_NUM = village.VILL_STR_SR_NUM!;
                          REGIONAL_NAME = village.REGIONAL_NAME!;
                        }
                        setState(() {});
                      },
                      items: villageList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Button(
                    width: double.maxFinite,
                    title: "Save",
                    onPressed: (beatName == "Select" || villageName == "Select")
                        ? null
                        : () {
                            DialogHelper.showLoaderDialog(context);
                            _mapVillageBeat();
                          },
                  )
                ],
              ),
            ),
    );
  }
}
