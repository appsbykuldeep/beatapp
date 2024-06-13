class EmployeeDetailAttachment {
  //@SerializedName("FILE_NAME")
  String? fileName;

  //@SerializedName("FILE_DESC")
  String? fileDesc;

  //@SerializedName("UPLOADED_FILE")
  String? uploadedFile;

  //@SerializedName("FILE_UPLOAD_SRNO")
  String? fileUploadSrno;

  EmployeeDetailAttachment(
      this.fileName, this.fileDesc, this.uploadedFile, this.fileUploadSrno);

  factory EmployeeDetailAttachment.fromJson(json) {
    return EmployeeDetailAttachment(json["FILE_NAME"], json["FILE_DESC"],
        json["UPLOADED_FILE"], json["FILE_UPLOAD_SRNO"]);
  }
}
