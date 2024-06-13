class MajorTaskPerformance {
  //@SerializedName("MAJOR_TASK_PERF")
  String? majorTaskPerf;

  //@SerializedName("INV_MAJOR_TASK_DESC")
  String? invMajorTaskDesc;

  //@SerializedName("INV_MAJOR_TASK_SRNO")
  String? invMajorTaskSrno;

  //@SerializedName("INV_MAJOR_TASK_OTHERS")
  String? invMajorTaskOthers;

  //@SerializedName("CASE_DIARY_SRNO")
  String? caseDiarySrno;

  //@SerializedName("INV_MAJOR_TASK_TYPE_CD")
  String? invMajorTaskTypeCd;

  //@SerializedName("FIR_REG_NUM")
  String? firRegNum;

  //@SerializedName("WITNESS_NAME")
  String? witnessName;

  //@SerializedName("RELATIVE_NAME")
  String? relativeName;

  //@SerializedName("AGE")
  String? age;

  //@SerializedName("WITNESS_ADDRESS")
  String? witnessAddress;

  //@SerializedName("CASTE")
  String? caste;

  //@SerializedName("FILE_NAME")
  String? fileName;

  //@SerializedName("CD_FILE_SRNO")
  String? cdFileSrno;

  //@SerializedName("UPLOADED_FILE")
  String? uploadedFile;

  MajorTaskPerformance(
      this.majorTaskPerf,
      this.invMajorTaskDesc,
      this.invMajorTaskSrno,
      this.invMajorTaskOthers,
      this.caseDiarySrno,
      this.invMajorTaskTypeCd,
      this.firRegNum,
      this.witnessName,
      this.relativeName,
      this.age,
      this.witnessAddress,
      this.caste,
      this.fileName,
      this.cdFileSrno,
      this.uploadedFile);

  factory MajorTaskPerformance.fromJson(json) {
    return MajorTaskPerformance(
        json["MAJOR_TASK_PERF"],
        json["INV_MAJOR_TASK_DESC"],
        json["INV_MAJOR_TASK_SRNO"],
        json["INV_MAJOR_TASK_OTHERS"],
        json["CASE_DIARY_SRNO"],
        json["INV_MAJOR_TASK_TYPE_CD"],
        json["FIR_REG_NUM"],
        json["WITNESS_NAME"],
        json["RELATIVE_NAME"],
        json["AGE"],
        json["WITNESS_ADDRESS"],
        json["CASTE"],
        json["FILE_NAME"],
        json["CD_FILE_SRNO"],
        json["UPLOADED_FILE"]);
  }
}
