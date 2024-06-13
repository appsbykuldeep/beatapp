import '../employee_verification_detail.dart';
import 'employee_beat_report_table.dart';
import 'employee_detail_attachment.dart';

class EmployeeVerificationDetailResponse2 {
  //@SerializedName("Table")
  List<EmployeeVerificationDetail>? detailList;

  //@SerializedName("Table1")
  List<EmployeeDetailAttachment>? attachmentsList;

  //@SerializedName("Table2")
  List<EmployeeBeatReport_Table>? beatReport;

  EmployeeVerificationDetailResponse2(
      this.detailList, this.attachmentsList, this.beatReport);

  factory EmployeeVerificationDetailResponse2.fromJson(json) {
    return EmployeeVerificationDetailResponse2(
        json["Table"], json["Table1"], json["Table2"]);
  }
}
