import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/model/choice.dart';
import 'package:beatapp/model/response/dashboard_count.dart';
import 'package:beatapp/state_changer.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

StateChanger stateChanger = StateChanger();
String role = '';
var personName = "".obs;
List<Choice> dashboardMenu = [];
late DashboardCount dashboardCount;
bool shouldRefresh = false;

abstract class BaseFullState<T extends StatefulWidget> extends State<T> {
  Future<void> getDashBoardCount() async {
    print("AppUser.ROLE_CD : ${AppUser.ROLE_CD}");
    if (role.isEmpty) {
      personName.value = AppUser.PERSON_NAME;
      role = AppUser.ROLE_CD;
      dashboardMenu = get_DashboardMenu(role);
    }
    dashboardCount = DashboardCount.fromJson({});
    setDashboardData();
    stateChanger.change(dashboardCount, dashboardMenu);

    /*var params = {
      "ROLE_ID": role
    }; */ /*(role == "16" || role == "17")
        ? {"ROLE_ID": role}
        : {"PS_CD": userData.psCD, "ROLE_ID": role};*/ /*
    var response = await HttpRequst.postRequestWithTokenAndBody(
        context, EndPoints.DASHBOARD_COUNT, params, true);
    if (response.statusCode == 200) {
      try {
        dashboardCount=DashboardCount.fromJson(response.data[0]);
        setDashboardData();
        stateChanger.change(
            dashboardCount,
            dashboardMenu
        );
      } catch (e) {
        print(e);
      }
    }*/
  }

  showDownloadOption({Function? onPdfClick, Function? onXlsxClick}) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                12.height,
                const Text(
                  "Download options",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                12.height,
                Container(
                  height: 5,
                  width: double.maxFinite,
                  color: ColorProvider.redColor,
                ),
                Container(
                  height: 5,
                  width: double.maxFinite,
                  color: ColorProvider.blueColor,
                ),
                24.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        if (onXlsxClick != null) {
                          onXlsxClick.call();
                        }
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/ic_xls.png",
                            height: 60,
                          ),
                          8.height,
                          const Text("Download")
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        if (onPdfClick != null) {
                          onPdfClick.call();
                        }
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/ic_pdf.png",
                            height: 60,
                          ),
                          8.height,
                          const Text("Download")
                        ],
                      ),
                    ),
                  ],
                ),
                24.height,
              ],
            ),
          );
        });
  }

  List<Choice> get_DashboardMenu(userType) {
    print("userType : $userType");
    if (userType == "2") {
      /*  SHO  */
      return <Choice>[
        Choice(
            id: 1,
            title: "master",
            icon: "assets/images/ic_master_data.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 2,
            title: "beat_area",
            icon: "assets/images/ic_area.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 3,
            title: 'beat_allotment',
            icon: "assets/images/ic_beat_assignment.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 7,
            title: 'warrant',
            icon: "assets/images/ic_summon_colored.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 6,
            title: 'pending_arrest',
            icon: "assets/images/ic_arrest_colored.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 7,
            title: 'summon',
            icon: "assets/images/ic_summon_colored.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 9,
            title: 'character_certificate_verification',
            icon: "assets/images/ic_charater_certificate.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 10,
            title: 'tenant_verification',
            icon: "assets/images/ic_charater_certificate.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 11,
            title: 'employee_verification',
            icon: "assets/images/ic_employee.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 12,
            title: 'domestic_help_verification',
            icon: "assets/images/domestic.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 13,
            title: 'arms_weapon_verification',
            icon: "assets/images/weapon_verification.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 14,
            title: 'History Sheeter Verification',
            icon: "assets/images/list.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 18,
            title: 'Area_Of_Interest',
            icon: "assets/images/area_interest.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 21,
            title: "Beat Book",
            icon: "assets/images/ic_beatbook.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 20,
            title: "Contact Book",
            icon: "assets/images/contact_book.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 15,
            title: 'report',
            icon: "assets/images/ic_report.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 4,
            title: 'important_information',
            icon: "assets/images/ic_imortant_info_colored.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 5,
            title: 'shared_information',
            icon: "assets/images/ic_share_colored.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 8,
            title: 'citizens_messages',
            icon: "assets/images/ic_citizen_messages.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 16,
            title: 'group',
            icon: "assets/images/group.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
      ];
    } else if (userType == "3") {
      /*  Invitigative officer  */
      return <Choice>[];
    } else if (userType == "16" || userType == "17") {
      /*  SP  */
      return <Choice>[
        Choice(
            id: 17,
            title: "summary",
            icon: "assets/images/ic_summary.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 15,
            title: "report",
            icon: "assets/images/ic_report.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 19,
            title: 'pending_hs_approval',
            icon: "assets/images/ic_files.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 11,
            title: 'employee_verification_status',
            icon: "assets/images/ic_employee.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 9,
            title: 'character_certificate',
            icon: "assets/images/ic_charater_certificate.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 12,
            title: 'domestic_help_verification',
            icon: "assets/images/domestic.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 10,
            title: 'tenant_verification_status',
            icon: "assets/images/ic_charater_certificate.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 16,
            title: 'group',
            icon: "assets/images/group.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 20,
            title: "Contact Book",
            icon: "assets/images/contact_book.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 21,
            title: "Beat Book",
            icon: "assets/images/ic_beatbook.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
      ];
    } else if (userType == "23") {
      /*Head able*/
      return <Choice>[
        Choice(
            id: 7,
            title: 'summon',
            icon: "assets/images/ic_summon_colored.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 7,
            title: 'warrant',
            icon: "assets/images/ic_summon_colored.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 6,
            title: 'pending_arrest',
            icon: "assets/images/ic_arrest_colored.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 9,
            title: 'character_certificate_verification',
            icon: "assets/images/ic_charater_certificate.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 10,
            title: 'tenant_verification',
            icon: "assets/images/ic_charater_certificate.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 11,
            title: 'employee_verification',
            icon: "assets/images/ic_employee.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 12,
            title: 'domestic_help_verification',
            icon: "assets/images/domestic.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 13,
            title: 'arms_weapon_verification',
            icon: "assets/images/weapon_verification.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 14,
            title: 'History Sheeter Verification',
            icon: "assets/images/list.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 4,
            title: "important_information",
            icon: "assets/images/notification.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 5,
            title: "share_information",
            icon: "assets/images/ic_share_colored.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 20,
            title: "Contact Book",
            icon: "assets/images/contact_book.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 8,
            title: 'citizens_messages',
            icon: "assets/images/ic_citizen_messages.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 21,
            title: "Beat Book",
            icon: "assets/images/ic_beatbook.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
      ];
    } else if (userType == "18" ||
        userType == "19" ||
        userType == "24" ||
        userType == "25" ||
        userType == "26" ||
        userType == "34" ||
        userType == "37" ||
        userType == "101") {
      /* Officer */
      return <Choice>[
        Choice(
            id: 17,
            title: "summary",
            icon: "assets/images/ic_summary.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 19,
            title: "application_status",
            icon: "assets/images/status.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 15,
            title: 'report',
            icon: "assets/images/ic_report.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 20,
            title: "Contact Book",
            icon: "assets/images/contact_book.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 21,
            title: "Beat Book",
            icon: "assets/images/ic_beatbook.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
      ];
    } else if (userType == "11") {
      /* CO */
      return <Choice>[
        Choice(
            id: 17,
            title: "ic_summary",
            icon: "assets/images/ic_summary.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 2,
            title: "status",
            icon: "assets/images/status.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 15,
            title: 'ic_report',
            icon: "assets/images/ic_report.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 20,
            title: "Contact Book",
            icon: "assets/images/contact_book.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 16,
            title: 'group',
            icon: "assets/images/group.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: true,
            isShowPending: false),
        Choice(
            id: 21,
            title: "Beat Book",
            icon: "assets/images/ic_beatbook.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
      ];
    } else if (userType == "4") {
      /* EO */
      return <Choice>[
        Choice(
            id: 9,
            title: "character_certificate_verification",
            icon: "assets/images/ic_charater_certificate.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 10,
            title: "tenant_verification",
            icon: "assets/images/ic_charater_certificate.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 11,
            title: 'employee_verification',
            icon: "assets/images/ic_employee.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 12,
            title: 'domestic_help_verification',
            icon: "assets/images/domestic.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 13,
            title: 'arms_weapon_verification',
            icon: "assets/images/weapon_verification.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 14,
            title: 'History Sheeter Verification',
            icon: "assets/images/list.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 8,
            title: 'citizens_messages',
            icon: "assets/images/ic_citizen_messages.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 20,
            title: "Contact Book",
            icon: "assets/images/contact_book.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 21,
            title: "Beat Book",
            icon: "assets/images/ic_beatbook.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
      ];
    } else if (userType == "13") {
      /* DCRB */
      return <Choice>[
        Choice(
            id: 11,
            title: "employee_verification",
            icon: "assets/images/ic_employee.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 2,
            title: "character_certificate",
            icon: "assets/images/ic_charater_certificate.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 10,
            title: 'tenant_verification',
            icon: "assets/images/ic_charater_certificate.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 20,
            title: "Contact Book",
            icon: "assets/images/contact_book.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 12,
            title: 'domestic_help_verification',
            icon: "assets/images/domestic.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 21,
            title: "Beat Book",
            icon: "assets/images/ic_beatbook.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
      ];
    } else if (userType == "12") {
      /* LIU */
      return <Choice>[
        Choice(
            id: 11,
            title: "employee_verification",
            icon: "assets/images/ic_employee.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 2,
            title: "character_certificate",
            icon: "assets/images/ic_charater_certificate.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 10,
            title: 'tenant_verification',
            icon: "assets/images/ic_charater_certificate.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 20,
            title: "Contact Book",
            icon: "assets/images/contact_book.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
        Choice(
            id: 12,
            title: 'domestic_help_verification',
            icon: "assets/images/domestic.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: true,
            isShowTotal: false,
            isShowPending: true),
        Choice(
            id: 21,
            title: "Beat Book",
            icon: "assets/images/ic_beatbook.png",
            pendingCount: 0,
            completedCount: 0,
            totalCount: 0,
            isShowCompleted: false,
            isShowTotal: false,
            isShowPending: false),
      ];
    }
    return <Choice>[];
  }

  void setDashboardData() {
    for (Choice c in dashboardMenu) {
      print(c.id);
      switch (c.id) {
        case 9:
          c.pendingCount = dashboardCount.PendingCharacterCertificate;
          c.completedCount = dashboardCount.CompletedCharacterCertificate;
          c.totalCount = dashboardCount.TotalCharacterCertificate;
          break;
        case 6:
          if (role == "2") {
            c.totalCount = dashboardCount.TotalWantedCriminals;
            c.pendingCount = dashboardCount.TotalPendingWantedCriminals;
            c.completedCount = dashboardCount.TotalCompletedWantedCriminals;
          } else {
            c.pendingCount = dashboardCount.PendingWantedCriminals;
            c.completedCount = dashboardCount.CompletedWantedCriminals;
          }

          break;
        case 7:
          if (c.title == "warrant") {
            c.pendingCount = dashboardCount.PendingWarrantList;
            c.completedCount = dashboardCount.CompletedWarrantList;
          } else {
            c.pendingCount = dashboardCount.PendingSummonList;
            c.completedCount = dashboardCount.CompletedSummonList;
          }
          break;
        case 8:
          c.pendingCount = dashboardCount.PendingCitezenMsg;
          c.completedCount = dashboardCount.CompletedCitezenMsg;
          c.totalCount = dashboardCount.TotalCitezenMsg;
          break;
        case 10:
          c.pendingCount = dashboardCount.PendingTENANT;
          c.completedCount = dashboardCount.CompletedTENANT;
          c.totalCount = dashboardCount.TotalTenant;
          break;
        case 11:
          c.pendingCount = dashboardCount.PendingEmployeeList;
          c.completedCount = dashboardCount.CompletedEmployeeList;
          c.totalCount = dashboardCount.TotalEmployeeList;
          break;
        case 12:
          c.pendingCount = dashboardCount.PendingDomesticHelp;
          c.completedCount = dashboardCount.CompletedDomesticHelp;
          c.totalCount = dashboardCount.TotalDomesticHelp;
          break;
        case 13:
          c.totalCount = dashboardCount.TotalArms_Weapons;
          c.pendingCount = dashboardCount.PendingArms_Weapons;
          c.completedCount = dashboardCount.EnquiryCompletedArms_Weapons;
          break;
        case 5:
          c.totalCount = dashboardCount.TotalSharedInfo;
          break;
        case 14:
          c.totalCount = dashboardCount.TotalHistorySheeter;
          c.pendingCount = dashboardCount.PendingHistorySheeter;
          c.completedCount = dashboardCount.CompletedHistorySheeter;
          break;
        case 3:
          c.totalCount = dashboardCount.TotalBeatAlocated;
          break;
        case 19:
          c.totalCount = dashboardCount.TotalHistorySheeter;
          break;
      }
    }
  }
}
