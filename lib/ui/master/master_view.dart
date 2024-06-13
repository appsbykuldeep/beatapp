import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/master/beat/beat_sub_menu_sho_view.dart';
import 'package:beatapp/ui/master/constable/constable_sub_menu_sho_view.dart';
import 'package:beatapp/ui/master/mappings/map_village_with_beat.dart';
import 'package:beatapp/ui/master/village/village_sub_menu_sho_view.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class MasterActivity extends StatefulWidget {
  final data;
  const MasterActivity({Key? key, this.data}) : super(key: key);

  @override
  State<MasterActivity> createState() => _MasterActivityState();
}

class _MasterActivityState extends State<MasterActivity> {
  final _dashboard = _get_DashboardMenu();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3.5;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(AppTranslations.of(context)!.text("master")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 2.0,
          childAspectRatio: (itemWidth / itemHeight),
          children: List.generate(_dashboard.length, (index) {
            return Center(
              child: SelectCard(choice: _dashboard[index]),
            );
          })),
    );
  }
}

class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.choice}) : super(key: key);
  final ChoiceMas choice;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Widget? page;
          if (choice.id == 1) {
            page = const ConstableSubMenuSHOActivity();
          } else if (choice.id == 2) {
            page = const VillageSubMenuSHOActivity();
          } else if (choice.id == 3) {
            page = const BeatSubMenuSHOActivity();
          } else if (choice.id == 4) {
            page = const MapVillageWithBeat();
          }
          if (page == null) return;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => page!,
              ));
        },
        child: Container(
            margin: const EdgeInsets.only(top: 3),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
//BoxShadow
                ]),
            child: Center(
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          choice.icon,
                          height: 60,
                          width: 60,
                        ),
                      ),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.only(top: 7),
                        child: Text(
                          AppTranslations.of(context)!.text(choice.title),
                          textAlign: TextAlign.center,
                        ),
                      )),
                    ]),
              ),
            )));
  }
}

class ChoiceMas {
  const ChoiceMas({required this.id, required this.title, required this.icon});

  final String title;
  final String icon;
  final int id;
}

List<ChoiceMas> _get_DashboardMenu() {
  return const <ChoiceMas>[
    ChoiceMas(
        id: 1,
        title: "beat_constable",
        icon: "assets/images/ic_constable_man.png"),
    ChoiceMas(
        id: 2, title: "village_street", icon: "assets/images/ic_location.png"),
    ChoiceMas(id: 3, title: 'beat', icon: "assets/images/ic_route.png"),
    ChoiceMas(id: 4, title: 'Mapping', icon: "assets/images/ic_route.png"),
  ];
}
