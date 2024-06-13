import 'domestic_beat_report_table.dart';
import 'domestic_detail_attachment.dart';
import 'domestic_verification_detail.dart';

class DomesticVerificationDetailResponse2 {
  //@SerializedName("Table")
  List<DomesticVerificationDetail>? detailList;

  //@SerializedName("Table1")
  List<DomesticDetailAttachment>? attachmentsList;

  //@SerializedName("Table2")
  List<DomesticBeatReport_Table>? beatReport;

  DomesticVerificationDetailResponse2(
      this.detailList, this.attachmentsList, this.beatReport);

  factory DomesticVerificationDetailResponse2.fromJson(json) {
    return DomesticVerificationDetailResponse2(
        json["Table"], json["Table1"], json["Table2"]);
  }
}
