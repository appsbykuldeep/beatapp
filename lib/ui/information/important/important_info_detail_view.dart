import 'package:beatapp/custom_view/image_viewer.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/important_information.dart';
import 'package:beatapp/ui/information/important/comment_list_view.dart';
import 'package:beatapp/utility/base64_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';


class ImportantInfoDetailActivity extends StatefulWidget {
  final ImportantInformation info;

  const ImportantInfoDetailActivity({Key? key, required this.info})
      : super(key: key);

  @override
  State<ImportantInfoDetailActivity> createState() =>
      _ImportantInfoDetailActivityState(info);
}

class _ImportantInfoDetailActivityState
    extends State<ImportantInfoDetailActivity> {
  var con_Details = TextEditingController();

  final ImportantInformation _info;

  _ImportantInfoDetailActivityState(this._info);

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
                                  value: _info.isInfo == "Y" ? false : true,
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
                                  value: _info.isInfo == "Y" ? true : false,
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
                                  value: _info.isHenious == "Y" ? true : false,
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
                                  value: _info.isHenious == "Y" ? false : true,
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
                        Expanded(child: Text(_info.infoDetail ?? "")),
                        InkWell(
                            onTap: () {}, child: const Icon(Icons.record_voice_over))
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
                            child: _info.fileDetail != null
                                ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ImageViewer(
                                            data: {"image": _info.fileDetail},
                                          ),
                                    ));
                              },
                              child:Image.memory(
                                    Base64Helper.decodeBase64Image(
                                        _info.fileDetail ?? ""),
                                    height: 80,
                                    width: 80,
                                  ))
                                : Image.asset(
                                    "assets/images/ic_image_placeholder.png",
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
                      getTranlateString("beat_name"),
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
                          child: Text(_info.beatName ?? ""),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentListInfoActivity(
                                data: {"SR_NUM": _info.soochnaSrNum}),
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
