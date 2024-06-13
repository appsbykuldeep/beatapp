import 'tenant_beat_report_table.dart';
import 'tenant_verification_attachment.dart';
import 'tenant_verification_detail.dart';

class TenantVerificationDetailResponse2 {
  //@SerializedName("Table")
  List<TenantVerificationDetail>? detailList;

  //@SerializedName("Table1")
  List<TenantVerificationAttachment>? attachmentList;

  //@SerializedName("Table2")
  List<TenantBeatReport_Table>? beatReport;

  TenantVerificationDetailResponse2(
      this.detailList, this.attachmentList, this.beatReport);

  factory TenantVerificationDetailResponse2.fromJson(json) {
    return TenantVerificationDetailResponse2(
        json["Table"], json["Table1"], json["Table2"]);
  }
}
