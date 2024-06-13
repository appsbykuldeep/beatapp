import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/shared_information.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/navigator_utils.dart';
import 'package:beatapp/utility/picker_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

import 'comment_list_view.dart';

class SharedInformationDetailActivity extends StatefulWidget {
  final SharedInformation info;

  const SharedInformationDetailActivity({Key? key, required this.info})
      : super(key: key);

  @override
  State<SharedInformationDetailActivity> createState() =>
      _SharedInformationDetailActivityState(info);
}

class _SharedInformationDetailActivityState
    extends State<SharedInformationDetailActivity> {
  var con_Details = TextEditingController();
  SharedInformation info;

  _SharedInformationDetailActivityState(this.info);

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  radioOnchange(value) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("information_detail")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
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
                                  value: info.isInfo == "Y" ? false : true,
                                  onChanged: radioOnchange,
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
                                  value: info.isInfo == "Y" ? true : false,
                                  onChanged: radioOnchange,
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
                                  value: info.isHenous == "Y" ? true : false,
                                  onChanged: radioOnchange,
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
                                  value: info.isHenous == "Y" ? false : true,
                                  onChanged: radioOnchange,
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
                      getTranlateString("share_to_all_beat"),
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
                                  value: info.isAll == "N" ? true : false,
                                  onChanged: radioOnchange,
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
                                  value: info.isAll == "Y" ? true : false,
                                  onChanged: radioOnchange,
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
                      getTranlateString("type_of_information"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 35,
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
                        Expanded(child: Text(info.infoIncidentType ?? "")),
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
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 35,
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
                          child: Text(info.infoDetails ?? ""),
                        ),
                        InkWell(
                            onTap: () {
                              PickerUtils.speak(info.infoDetails ?? "");
                            },
                            child: const Icon(Icons.record_voice_over))
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
                      getTranlateString("photo"),
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
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: info.fileDetail != null
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImageViewer(
                                              data: {"image": info.fileDetail},
                                            ),
                                          ));
                                    },
                                    child: Image.memory(
                                      Base64Helper.decodeBase64Image(
                                          info.fileDetail!),
                                      height: 80,
                                      width: 80,
                                    ))
                                : Image.asset(
                                    'assets/images/ic_image_placeholder.png',
                                    height: 80,
                                    width: 80,
                                  ),
                          ),
                        ),
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
                      getTranlateString("location"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .96,
                    height: 50,
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
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                NavigatorUtils.launchMapsUrlFromLatLong(
                                    double.parse(info.latitude ?? "0"),
                                    double.parse(info.latitude ?? "0"));
                              },
                              child: const Icon(Icons.location_on),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentListActivity(
                                data: {"INFO_SR_NUM": info.infoSrNum}),
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
                        AppTranslations.of(context)!.text("progress_status"),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
