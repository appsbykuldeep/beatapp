import 'citizen_message_beat_report.dart';
import 'information_detail_table.dart';

class CitizenMessagesDetailResponse {
  //@SerializedName("Table")
  List<InformationDetail_Table>? informationDetail;

  //@SerializedName("Table1")
  List<CitizenMessageBeatReport>? citizenMessageBeatReport;

  CitizenMessagesDetailResponse(
      this.informationDetail, this.citizenMessageBeatReport);

  factory CitizenMessagesDetailResponse.fromJson(Map<String, dynamic> json) {
    return CitizenMessagesDetailResponse(json["Table"], json["Table1"]);
  }
}
