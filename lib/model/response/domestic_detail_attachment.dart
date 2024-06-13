class DomesticDetailAttachment {
  //@SerializedName("FILE_NAME")
  String? fileName;

  //@SerializedName("FILE_DESC")
  String? fileDesc;

  //@SerializedName("UPLOADED_FILE")
  String? uploadedFile;

  //@SerializedName("FILE_UPLOAD_SRNO")
  String? fileUploadSrno;

  DomesticDetailAttachment(
      this.fileName, this.fileDesc, this.uploadedFile, this.fileUploadSrno);

  factory DomesticDetailAttachment.fromJson(json) {
    return DomesticDetailAttachment(json["FILE_NAME"], json["FILE_DESC"],
        json["UPLOADED_FILE"], json["FILE_UPLOAD_SRNO"]);
  }
}
