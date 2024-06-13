import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class CsEoFeedbackActivity extends StatefulWidget {
  final data;
  const CsEoFeedbackActivity({Key? key,required this.data}) : super(key: key);

  @override
  State<CsEoFeedbackActivity> createState() => _CsEoFeedbackActivityState(data);
}

class _CsEoFeedbackActivityState extends State<CsEoFeedbackActivity> {

  _CsEoFeedbackActivityState(data);
  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("enquiry_officer_remarks")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Container(
          margin: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranlateString("remark_mandatory"),
              ),
              5.height,
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .90,
                    padding:
                    const EdgeInsets.only(right: 5, top: 8, left: 5, bottom: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: const TextField(
                      style: TextStyle(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 25),
                child: InkWell(
                  onTap: () => {},
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    decoration: BoxDecoration(
                      color: Color(ColorProvider.colorPrimary),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      getTranlateString("submit"),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
