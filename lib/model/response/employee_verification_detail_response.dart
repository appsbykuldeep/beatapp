import 'employee_beat_report_table.dart';
import 'employee_detail_attachment.dart';
import 'employee_detail_table.dart';

class EmployeeVerificationDetailResponse {
  //@SerializedName("Table")
  List<EmployeeDetail_Table>? employeeDetail;

  //@SerializedName("Table1")
  List<EmployeeDetailAttachment>? employeeAttachment;

  //@SerializedName("Table2")
  List<EmployeeBeatReport_Table>? beatReport;

  EmployeeVerificationDetailResponse(this.employeeDetail,
      this.employeeAttachment, this.beatReport);

  factory EmployeeVerificationDetailResponse.fromJson(json){
    return EmployeeVerificationDetailResponse(
        json["Table"], json["Table1"], json["Table2"]);
  }
}
