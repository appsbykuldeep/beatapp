class SaveSharedInfoRequest {
  //@SerializedName("DISTRICT_CD")
  String? districtCD;

  //@SerializedName("PS_CD")
  String? psCD;

  //@SerializedName("IS_INFO")
  int? isInfo;

  //@SerializedName("IS_HENIOUS")
  int? isHenious;

  //@SerializedName("LATITUDE")
  double? latitude;

  //@SerializedName("LONGITUDE")
  double? longitude;

  //@SerializedName("INFO_TYPE_CD")
  String? infoTypeCD;

  //@SerializedName("INFO_TYPE")
  String? infoType;

  //@SerializedName("INFO_DETAIL")
  String? infoDetail;

  //@SerializedName("INCIDENT_TYPE_CD")
  String? incidentTypeCD;

  //@SerializedName("FILE_SIZE")
  int? fileSize;

  //@SerializedName("FILE_TYPE")
  String? fileType;

  //@SerializedName("FILE_Name")
  String? fileName;

  //@SerializedName("FILEDETAIL")
  String? fileDetails;

  //@SerializedName("IS_ALL")
  String? isAll;

  SaveSharedInfoRequest(
      this.districtCD,
      this.psCD,
      this.isInfo,
      this.isHenious,
      this.latitude,
      this.longitude,
      this.infoTypeCD,
      this.infoType,
      this.infoDetail,
      this.incidentTypeCD,
      this.fileSize,
      this.fileType,
      this.fileName,
      this.fileDetails,
      this.isAll);

  Map<String, dynamic> toJson() => {
        "DISTRICT_CD": districtCD,
        "PS_CD": psCD,
        "IS_INFO": isInfo,
        "IS_HENIOUS": isHenious,
        "LATITUDE": latitude,
        "LONGITUDE": longitude,
        "INFO_TYPE_CD": infoTypeCD,
        "INFO_TYPE": infoType,
        "INFO_DETAIL": infoDetail,
        "INCIDENT_TYPE_CD": incidentTypeCD,
        "FILE_SIZE": fileSize,
        "FILE_TYPE": fileType,
        "FILE_Name": fileName,
        "FILEDETAIL": fileDetails,
        "IS_ALL": isAll
      };
}
