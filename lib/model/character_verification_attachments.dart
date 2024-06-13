class CharacterVerificationAttachments {
  //@SerializedName("FILE_TYPE")
  String? fileType;

  //@SerializedName("FILE_SUB_TYPE")
  String? fileSubType;

  //@SerializedName("FILE_NAME")
  String? fileName;

  //@SerializedName("FILE_DESC")
  String? fileDesc;

  //@SerializedName("UPLOADED_FILE")
  String? uploadedFile;

  //@SerializedName("FILE_UPLOAD_SRNO")
  String? fileUploadSrno;

  CharacterVerificationAttachments(this.fileType, this.fileSubType,
      this.fileName, this.fileDesc, this.uploadedFile, this.fileUploadSrno);

  factory CharacterVerificationAttachments.fromJson(json) {
    return CharacterVerificationAttachments(
        json["FILE_TYPE"].toString(),
        json["FILE_SUB_TYPE"].toString(),
        json["FILE_NAME"].toString(),
        json["FILE_DESC"].toString(),
        json["UPLOADED_FILE"].toString(),
        json["FILE_UPLOAD_SRNO"].toString());
  }
}
