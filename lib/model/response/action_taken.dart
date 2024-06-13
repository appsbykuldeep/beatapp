class ActionTaken {
  //@SerializedName("SRNO")

  String? srno;

  //@SerializedName("FILE_UPLOAD_SRNO")

  String? fileUploadSrno;

  //@SerializedName("FILE_NAME")

  String? fileName;

  //@SerializedName("FILE_SIZE")

  String? fileSize;

  //@SerializedName("FILE_DESC")

  String? fileDesc;

  //@SerializedName("UPLOADED_FILE")

  String? uploadedFile;

  //@SerializedName("FILE_TYPE")

  String? fileType;

  //@SerializedName("FILE_SUB_TYPE")

  String? fileSubType;

  ActionTaken(this.srno, this.fileUploadSrno, this.fileName, this.fileSize,
      this.fileDesc, this.uploadedFile, this.fileType, this.fileSubType);

  factory ActionTaken.fromJson(Map<String, dynamic> json) {
    return ActionTaken(
        json["SRNO"],
        json["FILE_UPLOAD_SRNO"],
        json["FILE_NAME"],
        json["FILE_SIZE"],
        json["FILE_DESC"],
        json["UPLOADED_FILE"],
        json["FILE_TYPE"],
        json["FILE_SUB_TYPE"]);
  }
}
