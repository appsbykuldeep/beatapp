import 'package:beatapp/custom_view/custom_view.dart';
import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/ui/beatbook/beatbook_wip.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BeatBookDashboard extends StatefulWidget {
  const BeatBookDashboard({Key? key}) : super(key: key);

  @override
  State<BeatBookDashboard> createState() => _BeatBookDashboardState();
}

class _BeatBookDashboardState extends State<BeatBookDashboard> {
  /* { Language Selection */
  late var _dashboard = [];

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  void _getUserData() async {
    _dashboard = _get_DashboardMenu();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 2.8;
    // final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: const Text("Beat Book"),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: AlignedGridView.count(
        padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 2.0,
        itemCount: _dashboard.length,
        itemBuilder: (BuildContext context, int index) {
          return selectCard(_dashboard[index]);
        },
      ),
    );
  }

  dynamic selectCard(Choice choice) {
    return InkWell(
      onTap: () {
        openView(choice);
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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Column(children: [
                Container(
                  child: Image.asset(
                    choice.icon,
                    height: 60,
                    width: 60,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 7),
                  child: Text(
                    AppTranslations.of(context)!.text(choice.title),
                    textAlign: TextAlign.center,
                  ),
                ),
              ])),
              Container(
                child: Column(
                  children: [
                    choice.isShowPending
                        ? CustomView.getPendingView(
                            context, choice.pendingCount)
                        : const SizedBox(),
                    choice.isShowCompleted
                        ? CustomView.getCompletedView(
                            context, choice.pendingCount)
                        : const SizedBox(),
                    choice.isShowTotal
                        ? CustomView.getTotalView(context, choice.pendingCount)
                        : const SizedBox()
                  ],
                ),
              )
            ]),
      ),
    );
  }

  void openView(Choice choice) {
    int id = choice.id;
    BeatBookWIP page;
    if (id == 1) {
      page = const BeatBookWIP();
    } else if (id == 2) {
      page = const BeatBookWIP();
    } else if (id == 3) {
      page = const BeatBookWIP();
    } else if (id == 4) {
      page = const BeatBookWIP();
    } else if (id == 5) {
      page = const BeatBookWIP();
    } else if (id == 6) {
      page = const BeatBookWIP();
    } else if (id == 7) {
      page = const BeatBookWIP();
    } else if (id == 8) {
      page = const BeatBookWIP();
    } else if (id == 9) {
      page = const BeatBookWIP();
    } else {
      page = const BeatBookWIP();
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ));
  }
}

class Choice {
  const Choice(
      {required this.id,
      required this.title,
      required this.icon,
      required this.pendingCount,
      required this.completedCount,
      required this.totalCount,
      required this.isShowTotal,
      required this.isShowPending,
      required this.isShowCompleted});

  final String title;
  final String icon;
  final int id;
  final bool isShowPending;
  final int pendingCount;
  final int completedCount;
  final int totalCount;
  final bool isShowCompleted;
  final bool isShowTotal;
}

List<Choice> _get_DashboardMenu() {
  return const <Choice>[
    Choice(
        id: 1,
        title: "Beat Book 1",
        icon: "assets/images/ic_beatbook.png",
        pendingCount: 0,
        completedCount: 0,
        totalCount: 0,
        isShowCompleted: false,
        isShowTotal: false,
        isShowPending: false),
    Choice(
        id: 2,
        title: "Beat Book 2",
        icon: "assets/images/ic_beatbook.png",
        pendingCount: 0,
        completedCount: 0,
        totalCount: 0,
        isShowCompleted: false,
        isShowTotal: false,
        isShowPending: false),
    Choice(
        id: 3,
        title: "Beat Book 3",
        icon: "assets/images/ic_beatbook.png",
        pendingCount: 0,
        completedCount: 0,
        totalCount: 0,
        isShowCompleted: false,
        isShowTotal: false,
        isShowPending: false),
    Choice(
        id: 4,
        title: "Beat Book 4",
        icon: "assets/images/ic_beatbook.png",
        pendingCount: 0,
        completedCount: 0,
        totalCount: 0,
        isShowCompleted: false,
        isShowTotal: false,
        isShowPending: false),
    Choice(
        id: 5,
        title: "Beat Book 5",
        icon: "assets/images/ic_beatbook.png",
        pendingCount: 0,
        completedCount: 0,
        totalCount: 0,
        isShowCompleted: false,
        isShowTotal: false,
        isShowPending: false),
    Choice(
        id: 6,
        title: "Beat Book 6",
        icon: "assets/images/ic_beatbook.png",
        pendingCount: 0,
        completedCount: 0,
        totalCount: 0,
        isShowCompleted: false,
        isShowTotal: false,
        isShowPending: false),
    Choice(
        id: 7,
        title: "Beat Book 7",
        icon: "assets/images/ic_beatbook.png",
        pendingCount: 0,
        completedCount: 0,
        totalCount: 0,
        isShowCompleted: false,
        isShowTotal: false,
        isShowPending: false),
    Choice(
        id: 8,
        title: "Beat Book 8",
        icon: "assets/images/ic_beatbook.png",
        pendingCount: 0,
        completedCount: 0,
        totalCount: 0,
        isShowCompleted: false,
        isShowTotal: false,
        isShowPending: false),
    Choice(
        id: 9,
        title: "Beat Book 9",
        icon: "assets/images/ic_beatbook.png",
        pendingCount: 0,
        completedCount: 0,
        totalCount: 0,
        isShowCompleted: false,
        isShowTotal: false,
        isShowPending: false),
  ];
}
