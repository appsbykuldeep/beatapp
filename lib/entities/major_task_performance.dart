//@Entity(tableName = "m_major_task_performance")
class MajorTaskPerformance {
  //@PrimaryKey
  //@ColumnInfo(name = "ID")
  int? id;

  //@ColumnInfo(name = "LANG_CD")
  int? langCD;

  //@ColumnInfo(name = "MAJOR_TASK_CD")
  int? majorTaskCD;

  //@ColumnInfo(name = "MAJOR_TASK_PERF")
  String? majorTask;

  //@ColumnInfo(name = "RECORD_STATUS")
  String? recordStatus;

  MajorTaskPerformance(int this.majorTaskCD, String this.majorTask);

  //@NonNull
  //@Override
  @override
  String toString() {
    return majorTask!;
  }
}
