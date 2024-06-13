class ShoActionSaveRequest {
  //@SerializedName("CHARACTER_SR_NUM")
  String? characterSrNum;

  //@SerializedName("DOMESTIC_SR_NUM")
  String? domesticSrNum;

  //@SerializedName("EMPLOYEE_SR_NUM")
  String? employeeSrNum;

  //@SerializedName("TENANT_SR_NUM")
  String? tenantSrNum;

  //@SerializedName("PERSONID")
  String? personId;

  //@SerializedName("IS_ACCEPTED")
  String? isAccepted;

  //@SerializedName("PHOTO")
  String? photo;

  //@SerializedName("DESCRIPTION")
  String? description;

  //@SerializedName("PS_CD")
  String? psCD;

  //@SerializedName("IS_CRIMINAL_RECORD")
  String? isCriminalRecord;

  //@SerializedName("FILE_NAME")
  String? fileName;

  ShoActionSaveRequest(
      this.characterSrNum,
      this.domesticSrNum,
      this.employeeSrNum,
      this.tenantSrNum,
      this.personId,
      this.isAccepted,
      this.photo,
      this.description,
      this.psCD,
      this.isCriminalRecord,
      this.fileName);

  Map<String, dynamic> toJson() => {
        "CHARACTER_SR_NUM": characterSrNum,
        "DOMESTIC_SR_NUM": domesticSrNum,
        "EMPLOYEE_SR_NUM": employeeSrNum,
        "TENANT_SR_NUM": tenantSrNum,
        "PERSONID": personId,
        "IS_ACCEPTED": isAccepted,
        "PHOTO": photo,
        "DESCRIPTION": description,
        "PS_CD": psCD,
        "IS_CRIMINAL_RECORD": isCriminalRecord,
        "FILE_NAME": fileName
      };
}
