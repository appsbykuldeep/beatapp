class Choice {
  Choice(
      {required this.id,
        required this.title,
        required this.icon,
        required this.pendingCount,
        required this.completedCount,
        required this.totalCount,
        required this.isShowTotal,
        required this.isShowPending,
        required this.isShowCompleted});

  String title;
  String icon;
  int id;
  bool isShowPending;
  int pendingCount;
  int completedCount;
  int totalCount;
  bool isShowCompleted;
  bool isShowTotal;
}