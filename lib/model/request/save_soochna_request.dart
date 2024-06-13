class SaveSoochnaRequest {
  //@SerializedName("DISTRICT_CD")
  String? districtCD;

  //@SerializedName("PS_CD")
  String? psCD;

  //@SerializedName("IS_INFO")
  String? isInfo;

  //@SerializedName("IS_HENIOUS")
  String? isHenious;

  //@SerializedName("INFO_DETAIL")
  String? infoDetail;

  //@SerializedName("IS_ALL")
  String? isAll;

  //@SerializedName("BEAT_CD")
  String? beatCD;

  //@SerializedName("FILE_SIZE")
  int? fileSize;

  //@SerializedName("FILE_TYPE")
  String? fileType;

  //@SerializedName("FILE_NAME")
  String? fileName;

  //@SerializedName("FILEDETAIL")
  String? fileDetail;

  SaveSoochnaRequest(
      this.districtCD,
      this.psCD,
      this.isInfo,
      this.isHenious,
      this.infoDetail,
      this.isAll,
      this.beatCD,
      this.fileSize,
      this.fileType,
      this.fileName,
      this.fileDetail);

  Map<String, dynamic> toJson() => {
        "DISTRICT_CD": districtCD,
        "PS_CD": psCD,
        "IS_INFO": isInfo,
        "IS_HENIOUS": isHenious,
        "INFO_DETAIL": infoDetail,
        "IS_ALL": isAll,
        "BEAT_CD": beatCD,
        "FILE_SIZE": fileSize,
        "FILE_TYPE": fileType,
        "FILE_NAME": fileName,
        "FILEDETAIL": fileDetail
      };
}
