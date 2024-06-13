import 'dart:async';

import 'package:beatapp/api/api_connection.dart' as HttpRequst;
import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/custom_view/button.dart';
import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/entities/district.dart';
import 'package:beatapp/entities/police_station.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/contact_book.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/message_utility.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactBookActivity extends StatefulWidget {
  const ContactBookActivity({Key? key}) : super(key: key);

  @override
  State<ContactBookActivity> createState() => _ContactBookActivityState();
}

class _ContactBookActivityState extends State<ContactBookActivity> {
  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  List<ContactBook> lstContact = [];
  String dropdownValueDistrict = "Select";
  List<String> spinnerItemsDistrict = ["Select"];
  String dropdownValuePS = "Select";
  List<String> spinnerItemsPS = ["Select"];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      getDistrictList();
    });
  }

  String getSelectedDistrictId() {
    return dropdownValueDistrict.split("#")[1].toString();
  }

  String getSelectedPSId() {
    return dropdownValuePS.split("#")[1].toString();
  }

  void getPSList() async {
    var lst = await PoliceStation.searchPS(getSelectedDistrictId());
    for (int i = 0; i < lst.length; i++) {
      spinnerItemsPS.add("${lst[i].ps!}#${lst[i].psCD!}");
    }
    setState(() {});
  }

  void getDistrictList() async {
    var lst = await District.getAllDistrict();
    for (int i = 0; i < lst.length; i++) {
      spinnerItemsDistrict.add("${lst[i].district!}#${lst[i].districtCD!}");
    }
    setState(() {});
  }

  void _getContactList() async {
    String? role = AppUser.ROLE_CD;
    var data = {
      "ROLE_ID": role,
      "DISTRICT_CD": getSelectedDistrictId(),
      "PS_CD": getSelectedPSId()
    };
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.GET_CONTACT_BOOK_DETAIL, data, true);
    if (response.statusCode == 200) {
      lstContact = [];
      try {
        for (Map<String, dynamic> i in response.data) {
          lstContact.add(ContactBook.fromJson(i));
        }
      } catch (e) {
        e.toString();
      }
    } else {
      MessageUtility.showToast(context, response.data!.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          title: Text(getTranlateString("Contact Book")),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranlateString("district"),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 45,
                child: InkWell(
                  child: Container(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: spinnerItemsDistrict.isNotEmpty
                        ? DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValueDistrict,
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
                              dropdownValueDistrict = data!;
                              getPSList();
                              setState(() {});
                            },
                            items: spinnerItemsDistrict
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.split("#")[0],
                                    style:
                                        const TextStyle(color: Colors.black)),
                              );
                            }).toList(),
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Text(
                  getTranlateString("police_station"),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 45,
                child: InkWell(
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: spinnerItemsPS.isNotEmpty
                        ? DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValuePS,
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
                                dropdownValuePS = data!;
                              });
                            },
                            items: spinnerItemsPS
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.split("#")[0],
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
              12.height,
              Align(
                alignment: Alignment.topRight,
                child: Button(
                  title: "search",
                  onPressed:
                      (dropdownValueDistrict == getTranlateString("select") ||
                              dropdownValuePS == getTranlateString("select"))
                          ? null
                          : () {
                              _getContactList();
                            },
                ),
              ),
              lstContact.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const RangeMaintainingScrollPhysics(),
                      itemCount: lstContact.length,
                      itemBuilder: (BuildContext context, int index) {
                        return get_Row_Constact_Book(index);
                      })
                  : Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      child: CustomView.getNoRecordViewWrap(context)),
            ],
          ),
        ));
  }

  Widget get_Row_Constact_Book(int index) {
    var data = lstContact[index];
    return InkWell(
      onTap: () async {
        Uri phoneno = Uri.parse('tel:${data.MOBILE_NUMBER}');
        if (await launchUrl(phoneno)) {
          //dialer opened
        } else {
          //dailer is not opened
        }
      },
      child: Container(
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
                    child: Text(
                        AppTranslations.of(context)!.text("name_of_person"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.PERSON_NAME ?? ""),
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
                      AppTranslations.of(context)!.text("role"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.DESIGNATION_NAME ?? ""),
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
                        AppTranslations.of(context)!.text("village_street"),
                        style: getHeaderStyle()),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.VILLAGENAME ?? ""),
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
                      AppTranslations.of(context)!.text("mobile_number"),
                      style: getHeaderStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(data.MOBILE_NUMBER ?? ""),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle getHeaderStyle() {
  return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
}
