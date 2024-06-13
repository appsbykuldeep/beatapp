import '../assign_history.dart';
import '../character_verification_attachments.dart';
import '../character_verification_detail.dart';

class CharacterVerificationDetailResponse {
  //@SerializedName("Table")
  List<CharacterVerificationDetail>? detailList;

  //@SerializedName("Table1")
  List<CharacterVerificationAttachments>? attachmentsList;

  //@SerializedName("Table2")
  List<AssignHistory>? assignHistoryList;

  //@SerializedName("Table3")
  List<AssignHistory>? completedHistoryList;

  CharacterVerificationDetailResponse(this.detailList, this.attachmentsList,
      this.assignHistoryList, this.completedHistoryList);

  factory CharacterVerificationDetailResponse.fromJson(
      Map<String, dynamic> json) {
    return CharacterVerificationDetailResponse(
        json["Table"], json["Table1"], json["Table2"], json["Table3"]);
  }
}
