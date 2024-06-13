class TenantVerificationAttachment {
  //@SerializedName("TENANT_SR_NUM")
  String? tenantSrNum;

  //@SerializedName("FILE_NAME")
  String? fileName;

  //@SerializedName("FILE_DESC")
  String? fileDesc;

  //@SerializedName("UPLOADED_FILE")
  String? uploadedFile;

  //@SerializedName("FILE_TYPE")
  String? fileType;

  //@SerializedName("FILE_UPLOAD_SRNO")
  String? fileUploadSrno;

  TenantVerificationAttachment(this.tenantSrNum, this.fileName, this.fileDesc,
      this.uploadedFile, this.fileType, this.fileUploadSrno);

/* //@SerializedName("FILE_SUB_TYPE")
     String? fileSubType;*/

  factory TenantVerificationAttachment.fromJson(json) {
    return TenantVerificationAttachment(
        json["TENANT_SR_NUM"].toString(),
        json["FILE_NAME"],
        json["FILE_DESC"],
        json["UPLOADED_FILE"],
        json["FILE_TYPE"],
        json["FILE_UPLOAD_SRNO"]);
  }
}
