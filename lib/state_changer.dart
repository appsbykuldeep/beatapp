import 'package:beatapp/model/choice.dart';
import 'package:beatapp/model/response/dashboard_count.dart';
import 'package:flutter/foundation.dart';

class StateChanger extends ChangeNotifier{
   DashboardCount dashCounts = DashboardCount.emptyData();
   List<Choice> dashboardMenu=[];
  void change(DashboardCount dashCounts, List<Choice> dashboardMenu){
    this.dashboardMenu=dashboardMenu;
    this.dashCounts=dashCounts;
    notifyListeners();
  }

}