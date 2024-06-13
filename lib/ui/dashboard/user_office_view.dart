import 'package:beatapp/api/api_end_point.dart';
import 'package:beatapp/api/call_api.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/model/offices_response.dart';
import 'package:beatapp/ui/dashboard/dashboard.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/extentions/string_ext.dart';
import 'package:beatapp/utility/extentions/widget_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class UserOfficeView extends StatefulWidget {
  const UserOfficeView({Key? key}) : super(key: key);

  @override
  State<UserOfficeView> createState() => _UserOfficeViewState();
}

class _UserOfficeViewState extends State<UserOfficeView> {
  List<OfficesResponse> offices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _getUserOffice();
    });
  }

  void _getUserOffice() async {
    var role = AppUser.ROLE_CD;
    final res = await callApi(
        endPoint: EndPoints.END_POINT_GET_USER_OFFICE,
        request: {'USER_TYPE': AppUser.USER_TYPE});
    if (res.statusCode == 200) {
      offices = officesResponseFromJson(res.body);
      for (var v in offices) {
        if (v.rolecd.toString() == role) {
          v.isSelected = true;
        } else {
          v.isSelected = false;
        }
      }
      if (offices.length == 1) {
        setPreferenceData(offices[0]);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text("User Office"),
          backgroundColor: Color(ColorProvider.colorPrimary),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: offices.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: offices[index].isSelected ? 10 : null,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            setPreferenceData(offices[index]);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  "Office Type"
                                      .text(fontWeight: FontWeight.bold)
                                      .expand(),
                                  offices[index]
                                      .officetype
                                      .text()
                                      .expand(flex: 2)
                                ],
                              ),
                              8.height,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "Office Name"
                                      .text(fontWeight: FontWeight.bold)
                                      .expand(),
                                  offices[index]
                                      .officename
                                      .text()
                                      .expand(flex: 2)
                                ],
                              ),
                              8.height,
                              Row(
                                children: [
                                  "Role"
                                      .text(fontWeight: FontWeight.bold)
                                      .expand(),
                                  offices[index].role.text().expand(flex: 2)
                                ],
                              )
                            ],
                          )),
                    ),
                  );
                }));
  }

  void setPreferenceData(OfficesResponse response) {
    AppUser.updateByOfficeDetails(response);
    // PreferenceHelper p = PreferenceHelper();
    // p.saveString(Constraints.ROLE_CD, response.rolecd.toString());
    // p.saveString(Constraints.OFFICE_TYPE, response.officetype);
    // p.saveString(Constraints.OFFICE_Name, response.officename);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ),
      (route) => false,
    );
  }
}
