import 'action_taken.dart';
import 'case_diary_general_information.dart';
import 'evidence.dart';
import 'major_task_performance.dart';

class GetCaseDiaryRecordResponse {
  //@SerializedName("Table") //Sammanya Soochna and ki gayi kaaryawahi
  List<CaseDiaryGeneralInformation>? caseDiaryGeneralInformation;

  //@SerializedName("Table1")   //Evidence
  List<Evidence>? evidences;

  //@SerializedName("Table2")   //Major Task Performance
  List<MajorTaskPerformance>? majorTaskPerformances;

  //@SerializedName("Table3")   //Ki gayi Kaaryawahi
  List<ActionTaken>? actionTaken;

  GetCaseDiaryRecordResponse(this.caseDiaryGeneralInformation, this.evidences,
      this.majorTaskPerformances, this.actionTaken);

  factory GetCaseDiaryRecordResponse.fromJson(json) {
    return GetCaseDiaryRecordResponse(
        json["Table"], json["Table1"], json["Table2"], json["Table3"]);
  }
}
