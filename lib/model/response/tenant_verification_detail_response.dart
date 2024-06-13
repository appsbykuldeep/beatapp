import 'tenant_beat_report_table.dart';
import 'tenant_details_table.dart';
import 'tenant_verification_attachment.dart';

class TenantVerificationDetailResponse {
  //@SerializedName("Table")
  List<TenantDetails_Table>? tenantDetail;

  //@SerializedName("Table1")
  List<TenantVerificationAttachment>? tenantAttachment;

  //@SerializedName("Table2")
  List<TenantBeatReport_Table>? beatReport;

  TenantVerificationDetailResponse(
      this.tenantDetail, this.tenantAttachment, this.beatReport);

  factory TenantVerificationDetailResponse.fromJson(json) {
    return TenantVerificationDetailResponse(
        json["Table"], json["Table1"], json["Table2"]);
  }
}
