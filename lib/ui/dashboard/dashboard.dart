import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/localization/application.dart';
import 'package:beatapp/model/choice.dart';
import 'package:beatapp/preferences/preference_util.dart';
import 'package:beatapp/ui/arrest/arrest_list_view.dart';
import 'package:beatapp/ui/beat_allotment/beat_distribution_main_view.dart';
import 'package:beatapp/ui/beat_area/beat_area_view.dart';
import 'package:beatapp/ui/beatbook/beat_book_webview.dart';
import 'package:beatapp/ui/character_certificate/constable/character_verification_cons_view.dart';
import 'package:beatapp/ui/character_certificate/eo/character_verification_eo_view.dart';
import 'package:beatapp/ui/character_certificate/sho/character_certificate_list_view.dart';
import 'package:beatapp/ui/character_certificate/sp/subview/pending_view_character_sp.dart';
import 'package:beatapp/ui/citizen_messages/constable/cons_citizen_messages_view.dart';
import 'package:beatapp/ui/citizen_messages/eo/citizen_messages_eo_view.dart';
import 'package:beatapp/ui/citizen_messages/sho/citizen_messages_sho_view.dart';
import 'package:beatapp/ui/contact_book/contact_book_view.dart';
import 'package:beatapp/ui/dashboard/user_office_view.dart';
import 'package:beatapp/ui/delete_account/delete_account.dart';
import 'package:beatapp/ui/domestic_verification/constable/cons_domestic_view.dart';
import 'package:beatapp/ui/domestic_verification/eo/domestic_verification_eo_view.dart';
import 'package:beatapp/ui/domestic_verification/sho/domestic_verification_sho_view.dart';
import 'package:beatapp/ui/domestic_verification/sp/subview/pending_view_domestic_sp.dart';
import 'package:beatapp/ui/employee_verification/constable/cons_employee_view.dart';
import 'package:beatapp/ui/employee_verification/eo/employee_verification_eo_view.dart';
import 'package:beatapp/ui/employee_verification/sho/employee_verification_sho_view.dart';
import 'package:beatapp/ui/employee_verification/sp/subview/pending_view_employee_sp.dart';
import 'package:beatapp/ui/feedback/feedback_view.dart';
import 'package:beatapp/ui/group/group_view.dart';
import 'package:beatapp/ui/history_sheeters/constable/history_sheeters_view_constable.dart';
import 'package:beatapp/ui/history_sheeters/eo/history_sheeters_view_eo_main.dart';
import 'package:beatapp/ui/history_sheeters/sho/hs_sub_menu_sho_view.dart';
import 'package:beatapp/ui/history_sheeters/sp/hs_pending_sp_approval_view.dart';
import 'package:beatapp/ui/information/important_information_view.dart';
import 'package:beatapp/ui/information/share_information_main_view.dart';
import 'package:beatapp/ui/login/login_view.dart';
import 'package:beatapp/ui/main/test_file.dart';
import 'package:beatapp/ui/master/master_view.dart';
import 'package:beatapp/ui/notice/notice_view.dart';
import 'package:beatapp/ui/profile/profile_view.dart';
import 'package:beatapp/ui/report/report_view.dart';
import 'package:beatapp/ui/summary/summury_view.dart';
import 'package:beatapp/ui/summon/constable/cons_summon_view.dart';
import 'package:beatapp/ui/summon/sho/summon_view.dart';
import 'package:beatapp/ui/tenant/constable/cons_tenant_view.dart';
import 'package:beatapp/ui/tenant/eo/tenant_verification_eo_view.dart';
import 'package:beatapp/ui/tenant/sho/tenant_verification_sho_view.dart';
import 'package:beatapp/ui/tenant/sp/subview/pending_view_tenant_sp.dart';
import 'package:beatapp/ui/weapon_verification/constable/weapon_verification_view_constable.dart';
import 'package:beatapp/ui/weapon_verification/eo/weapon_verification_view_eo_main.dart';
import 'package:beatapp/ui/weapon_verification/sho/subMenu/weapon_sub_menu_sho_view.dart';
import 'package:beatapp/utility/extentions/context_ext.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends BaseFullState<Dashboard> {
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  void onLocaleChange(Locale locale) async {
    AppTranslations.load(locale);
    setState(() {});
  }

  String label = languagesList[0];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await getDashBoardCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(ColorProvider.color_window_bg),
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Row(
            children: [
              Image.asset(
                "assets/ic_user.png",
                height: 50,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hello",
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                    2.height,
                    Obx(
                      () => Text(
                        personName.value,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis, fontSize: 14),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          backgroundColor: Color(ColorProvider.colorPrimary),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileView(),
                    ));
              },
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                child: const Icon(
                  Icons.account_box_rounded,
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  showLogoutDialog(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: const Icon(Icons.logout),
                )),
            PopupMenuButton<String>(onSelected: (value) {
              if (value == "select_language") {
                showLanguageDialog(context);
              } else if (value == "feedback") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedbackView(),
                    ));
              } else if (value == "user_office") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserOfficeView(),
                    ));
              } else if (value == "delete") {
                Get.to(() => const DeleteAccount());
              }
            }, itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "select_language",
                  child: Text(
                      AppTranslations.of(context)!.text("select_language")),
                ),
                PopupMenuItem<String>(
                  value: "user_office",
                  child: Text(AppTranslations.of(context)!.text("user_office")),
                ),
                PopupMenuItem<String>(
                  value: "feedback",
                  child: Text(AppTranslations.of(context)!.text("feedback")),
                ),
                const PopupMenuItem<String>(
                  value: "delete",
                  child: Text("Delete Account"),
                )
              ];
            }),
          ],
        ),
        body: ListenableBuilder(
          listenable: stateChanger,
          builder: (context, child) => AlignedGridView.count(
            padding: const EdgeInsets.all(3),
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 2.0,
            itemCount: stateChanger.dashboardMenu.length,
            itemBuilder: (BuildContext context, int index) {
              return selectCard(stateChanger.dashboardMenu[index], index);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          backgroundColor: Color(ColorProvider.colorPrimary),
          onPressed: () {},
          // isExtended: true,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NoticeActivity(),
                  ));
            },
            child: const Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget selectCard(Choice choice, int index) {
    return InkWell(
      onTap: () {
        openView(choice);
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade50,
                blurRadius: 2.0,
                spreadRadius: 2.0,
              ),
            ]),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              12.height,
              Image.asset(
                choice.icon,
                height: 45,
                width: 45,
              ),
              12.height,

              Text(
                AppTranslations.of(context)!.text(choice.title),
                textAlign: TextAlign.center,
              ),
              // ignore: avoid_unnecessary_containers
              12.height,
              Container(
                height: 45,
                padding: const EdgeInsets.only(left: 4, right: 4),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    color: index < 3
                        ? Colors.deepOrangeAccent.shade200
                        : index > 2 && index < 6
                            ? Colors.redAccent
                            : index > 11 && index < 15
                                ? Colors.deepOrange
                                : Colors.orange),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        choice.isShowPending
                            ? Row(
                                children: [
                                  const Text(
                                    "Pending : ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    choice.pendingCount.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        choice.isShowCompleted
                            ? Row(
                                children: [
                                  const Text(
                                    "Completed : ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    choice.completedCount.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        choice.isShowTotal
                            ? Row(
                                children: [
                                  const Text(
                                    "Total : ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    choice.totalCount.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              )
                            : const SizedBox()
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }

  void openView(Choice choice) async {
    int id = choice.id;
    print("id $id");
    print("role $role");
    Widget? page;
    if (id == 1) {
      page = MasterActivity(data: {"role": role});
    } else if (id == 2) {
      page = BeatAreaActivity(data: {"role": role});
    } else if (id == 3) {
      page = BeatDistributionMainActivity(data: {"role": role});
    } else if (id == 4) {
      page = ImportantInformationActivity(data: {"role": role});
    } else if (id == 5) {
      page = ShareInformationActivity(data: {"role": role});
    } else if (id == 6) {
      page = ArrestListActivity(data: {"role": role});
    } else if (id == 7) {
      if (role == "23") {
        page = ConsSummonActivity(data: {
          "role": role,
          "title": choice.title,
        });
      } else {
        page = SummonActivity(data: {"role": role, "title": choice.title});
      }
    } else if (id == 8) {
      if (role == "23") {
        page = ConsCitizenMessagesActivity(data: {"role": role});
      } else if (role == "4") {
        page = const CitizenMessagesActivityEO();
      } else {
        page = CitizenMessagesSHOActivity(data: {"role": role});
      }
    } else if (id == 9) {
      if (role == "23") {
        page = CharacterVerificationConsActivity(data: {"role": role});
      } else if (role == "4") {
        page = CharacterVerificationEoActivity(data: {"role": role});
      } else if (role == "16" || role == "17") {
        page = const PendingFragmentCharacterSp();
      } else {
        page = CharacterCertificateListActivity(data: {"role": role});
      }
    } else if (id == 10) {
      if (role == "23") {
        page = ConsTenantActivity(
          data: {"role": role},
        );
      } else if (role == "4") {
        page = TenantVerificationEoActivity(
          data: {"role": role},
        );
      } else if (role == "16" || role == "17") {
        page = const PendingFragmentTenantSp();
      } else {
        page = TenantVerificationSHOActivity(data: {"role": role});
      }
    } else if (id == 11) {
      if (role == "23") {
        page = ConsEmployeeActivity(data: {"role": role});
      } else if (role == "4") {
        page = const EmployeeVerificationEoActivity();
      } else if (role == "16" || role == "17") {
        page = const PendingFragmentEmployeeSp();
      } else {
        page = EmployeeVerificationSHOActivity(data: {"role": role});
      }
    } else if (id == 12) {
      if (role == "23") {
        page = ConsDomesticActivity(
          data: {"role": role},
        );
      } else if (role == "4") {
        page = const DomesticVerificationEoActivity();
      } else if (role == "16" || role == "17") {
        page = const PendingFragmentDomesticSp();
      } else {
        page = DomesticVerificationSHOActivity(data: {"role": role});
      }
    } else if (id == 13) {
      if (role == "23") {
        page = WeaponVerificationActivityConstable(data: {"role": role});
      } else if (role == "4") {
        page = const WeaponVerificationActivityEOMain();
      } else {
        page = WeaponSubMenuSHOActivity(data: {"role": role});
      }
    } else if (id == 14) {
      if (role == "23") {
        page = const HistorySheetersActivityConstable();
      } else if (role == "4") {
        page = const HistorySheetersActivityEOMain();
      } else {
        page = HSSubMenuSHOActivity(data: {"role": role});
      }
    } else if (id == 15) {
      page = ReportActivity(data: {"role": role});
    } else if (id == 16) {
      page = GroupActivity(data: {"role": role});
    } else if (id == 17) {
      page = const SummaryView();
    } else if (id == 18) {
      page = const Test();
    } else if (id == 19) {
      page = const HSPendingSPApprovalActivity();
    } else if (id == 20) {
      page = const ContactBookActivity();
    } else if (id == 21) {
      page = const BeatBookWebActivtiy();
    }

    if (page == null) return;

    context.push(page);
  }

  void showLanguageDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Select Language",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, __, ___) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * .90,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x60000000),
                      offset: Offset(
                        3.0,
                        3.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    //BoxShadow
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      AppTranslations.of(context)!.text(
                        "select_language",
                      ),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(ColorProvider.grey_60),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onLocaleChange(Locale(languagesMap["English"]));
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        AppTranslations.of(context)!.text(
                          "english",
                        ),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(ColorProvider.grey_60),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onLocaleChange(Locale(languagesMap["Hindi"]));
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        AppTranslations.of(context)!.text(
                          "hindi",
                        ),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(ColorProvider.grey_60),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }

  showLogoutDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(AppTranslations.of(context)!.text("cancel")),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(AppTranslations.of(context)!.text("yes")),
      onPressed: () {
        role = "";
        dashboardMenu.clear();
        AppUser.logoutUser();
        PreferenceHelper().clearAll();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
            (route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(AppTranslations.of(context)!.text("logout")),
      content: Text(AppTranslations.of(context)!.text("logout_confirmation")),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
