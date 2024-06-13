import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/master/constable/constable_add_view.dart';
import 'package:beatapp/ui/master/constable/constable_view.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';


class ConstableSubMenuSHOActivity extends StatefulWidget {
  const ConstableSubMenuSHOActivity({Key? key}) : super(key: key);

  @override
  State<ConstableSubMenuSHOActivity> createState() => _ConstableSubMenuSHOActivityState();
}

class _ConstableSubMenuSHOActivityState extends State<ConstableSubMenuSHOActivity> {
  final _dashboard = _get_DashboardMenu();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3.3;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(AppTranslations.of(context)!.text("beat_constable")),
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
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (choice.id == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConstableAddActivity(),
                ));
          } else if (choice.id == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConstableViewActivity(),
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

class Choice {
  const Choice({required this.id, required this.title, required this.icon});

  final String title;
  final String icon;
  final int id;
}

List<Choice> _get_DashboardMenu() {
  return const <Choice>[
    Choice(
        id: 1, title: "add", icon: "assets/images/ic_add.png"),
    Choice(id: 2, title: "view_edit_delete", icon: "assets/images/ic_files.png"),
  ];
}
