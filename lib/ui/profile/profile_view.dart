import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/model/response/login_response.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _name = "", _rank = "", _officeType = "", _officeName = "";

  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  void initState() {
    bindProfileData();
    super.initState();
  }

  void bindProfileData() async {
    LoginResponseModel response = await LoginResponseModel.fromPreference();

    _name = response.personName.toString();
    _rank = response.officerRank!;
    _officeName = AppUser.OFFICE_Name;
    _officeType = AppUser.OFFICE_TYPE;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("profile")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Container(
          margin:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  getTranlateString("name"),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width * .90,
                  padding: const EdgeInsets.only(
                      right: 5, top: 8, left: 5, bottom: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: Text(_name,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black54)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Text(
                  getTranlateString("rank"),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .90,
                    padding: const EdgeInsets.only(
                        right: 5, top: 8, left: 5, bottom: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Text(_rank,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black54)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Text(
                  getTranlateString("office_type"),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .90,
                    padding: const EdgeInsets.only(
                        right: 5, top: 8, left: 5, bottom: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Text(
                      _officeType,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Text(
                  getTranlateString("office_name"),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .90,
                    padding: const EdgeInsets.only(
                        right: 5, top: 8, left: 5, bottom: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Text(_officeName,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black54)),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
