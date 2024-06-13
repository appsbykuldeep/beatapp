import 'history_sheeter_detail_table.dart';
import 'history_sheeters_beat_report_table.dart';

class HSTDetailResponse {
  //@SerializedName("Table")
  List<HistorySheeterDetail_Table>? hstDetail;

  /* //@SerializedName("Table1")
      List<DomesticDetailAttachment> domesticAttachment = null;*/

  //@SerializedName("Table1")
  List<HistorySheetersBeatReport_Table>? beatReport;

  //@SerializedName("Table2")
  List<HistorySheetersBeatReport_Table>? dateDetails;

  HSTDetailResponse(this.hstDetail, this.beatReport, this.dateDetails);

  factory HSTDetailResponse.fromJson(json) {
    return HSTDetailResponse(json["Table"], json["Table1"], json["Table2"]);
  }
}
