import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/history_sheeters/sho/main/history_sheeter_add_view.dart';
import 'package:beatapp/ui/history_sheeters/sho/main/history_sheeters_view.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class HSSubMenuSHOActivity extends StatefulWidget {
  final data;

  const HSSubMenuSHOActivity({Key? key, this.data}) : super(key: key);

  @override
  State<HSSubMenuSHOActivity> createState() => _HSSubMenuSHOActivityState();
}

class _HSSubMenuSHOActivityState extends State<HSSubMenuSHOActivity> {
  final _dashboard = _get_DashboardMenu();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.8;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(AppTranslations.of(context)!.text("history_sheeters")),
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
  final Choicehs choice;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (choice.id == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistorySheeterAddActivity(),
                ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistorySheetersViewActivity(),
                ));
          }
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

class Choicehs {
  const Choicehs({required this.id, required this.title, required this.icon});

  final String title;
  final String icon;
  final int id;
}

List<Choicehs> _get_DashboardMenu() {
  return const <Choicehs>[
    Choicehs(
        id: 1, title: "add", icon: "assets/images/ic_add.png"),
    Choicehs(id: 2, title: "view_edit_delete", icon: "assets/images/ic_files.png"),
  ];
}
