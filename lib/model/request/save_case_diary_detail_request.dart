import '../major_task_performance_detail.dart';

class SaveCaseDiaryDetailRequest {
  String? LANG_CD;
  String? FIR_REG_NUM;
  String? PS_CD;
  String? CASE_DIARY_PREP_DT;
  String? INV_START_TIME;
  String? INV_END_TIME;
  String? INV_PLC_VISITED;
  List<MajorTaskPerformanceDetail>? MajorTaskPerformedValue;
  String? ACTION_TAKEN_CD;
  String? OTHER_ACTION_DESC;
  String? ACTION_TAKEN_DESC;

  SaveCaseDiaryDetailRequest(
      this.LANG_CD,
      this.FIR_REG_NUM,
      this.PS_CD,
      this.CASE_DIARY_PREP_DT,
      this.INV_START_TIME,
      this.INV_END_TIME,
      this.INV_PLC_VISITED,
      this.MajorTaskPerformedValue,
      this.ACTION_TAKEN_CD,
      this.OTHER_ACTION_DESC,
      this.ACTION_TAKEN_DESC,
      this.ACTION_TAKEN_DT,
      this.CASEUNIQCODE);

  String? ACTION_TAKEN_DT;
  String? CASEUNIQCODE;

  Map<String, dynamic> toJson() => {
        "LANG_CD": LANG_CD,
        "FIR_REG_NUM": FIR_REG_NUM,
        "PS_CD": PS_CD,
        "CASE_DIARY_PREP_DT": CASE_DIARY_PREP_DT,
        "INV_START_TIME": INV_START_TIME,
        "INV_END_TIME": INV_END_TIME,
        "INV_PLC_VISITED": INV_PLC_VISITED,
        "MajorTaskPerformedValue": MajorTaskPerformedValue,
        "ACTION_TAKEN_CD": ACTION_TAKEN_CD,
        "OTHER_ACTION_DESC": OTHER_ACTION_DESC,
        "ACTION_TAKEN_DESC": ACTION_TAKEN_DESC
      };
}
