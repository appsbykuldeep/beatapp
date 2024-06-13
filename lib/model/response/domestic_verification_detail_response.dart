import 'domestic_beat_report_table.dart';
import 'domestic_detail_attachment.dart';
import 'domestic_detail_table.dart';

class DomesticVerificationDetailResponse {
  //@SerializedName("Table")
  List<DomesticDetail_Table>? domesticDetail;

  //@SerializedName("Table1")
  List<DomesticDetailAttachment>? domesticAttachment;

  //@SerializedName("Table2")
  List<DomesticBeatReport_Table>? beatReport;

  DomesticVerificationDetailResponse(
      this.domesticDetail, this.domesticAttachment, this.beatReport);

  factory DomesticVerificationDetailResponse.fromJson(json) {
    return DomesticVerificationDetailResponse(
        json["Table"], json["Table1"], json["Table2"]);
  }
}
