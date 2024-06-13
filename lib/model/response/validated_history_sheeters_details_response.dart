class ValidatedHistorySheetersDetailsResponse {
  //@SerializedName("HST_SR_NUM")
  String? hSTSRNUM;

  //@SerializedName("BEAT_NAME")
  String beatName;

  //@SerializedName("VILL_STREET_NAME")
  String? vILLSTREETNAME;

  //@SerializedName("NAME")
  String? nAME;

  //@SerializedName("IS_ACTIVE")
  String? iSACTIVE;

  //@SerializedName("RECORD_CREATED_ON")
  String? rECORDCREATEDON;

  //@SerializedName("FILL_DT")
  String? fILLDT;

  //@SerializedName("BEAT_CONSTABLE_NAME")
  String? bEATCONSTABLENAME;

  String? BEAT_NAME;

  ValidatedHistorySheetersDetailsResponse(
      this.hSTSRNUM,
      this.beatName,
      this.vILLSTREETNAME,
      this.nAME,
      this.iSACTIVE,
      this.rECORDCREATEDON,
      this.fILLDT,
      this.bEATCONSTABLENAME,
      this.BEAT_NAME
      );

  factory ValidatedHistorySheetersDetailsResponse.fromJson(json) {
    return ValidatedHistorySheetersDetailsResponse(
        json["HST_SR_NUM"].toString(),
        json["BEAT_NAME"]??'',
        json["VILL_STREET_NAME"].toString(),
        json["NAME"].toString(),
        json["IS_ACTIVE"].toString(),
        json["RECORD_CREATED_ON"].toString(),
        json["FILL_DT"].toString(),
        json["BEAT_CONSTABLE_NAME"].toString(),
        json["BEAT_NAME"].toString()
    );
  }

  static List<ValidatedHistorySheetersDetailsResponse> getActiveList(List<ValidatedHistorySheetersDetailsResponse> inputlist) {
    List<ValidatedHistorySheetersDetailsResponse> outputList = inputlist.where((ValidatedHistorySheetersDetailsResponse element) {
      try {
        return element.iSACTIVE == "सक्रिय";
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }

  static List<ValidatedHistorySheetersDetailsResponse> getInActiveList(List<ValidatedHistorySheetersDetailsResponse> inputlist) {
    List<ValidatedHistorySheetersDetailsResponse> outputList = inputlist.where((ValidatedHistorySheetersDetailsResponse element) {
      try {
        return element.iSACTIVE == "निष्क्रिय";
      } catch (e) {
        return false;
      }
    }).toList();
    return outputList;
  }
}
