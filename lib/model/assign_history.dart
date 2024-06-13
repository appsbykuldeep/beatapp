class AssignHistory {
  //@SerializedName("BEAT_NAME")
  String? beatName;

  //@SerializedName("ASSIGNED_TO_NAME")
  String? assignedTo;

  //@SerializedName("ASSIGN_DT")
  String? assignedDate;

  //@SerializedName("TARGET_DT5")
  String? targetDate;

  //@SerializedName("REMARKS")
  String? remark;

  //@SerializedName("IS_RESOLVED")
  String? isResolved;

  //@SerializedName("PHOTO")
  String? photo;

  //@SerializedName("FILL_DT")
  String? fillDt;

  //@SerializedName("LAT")
  String? lat;

  //@SerializedName("LONG")
  String? lng;

  //@SerializedName("EO_NAME")
  String? eoName;

  //@SerializedName("EO_REMARKS")
  String? eoRemarks;

  //@SerializedName("EO_REMARKS_DT")
  String? eoRemarksDt;

  //@SerializedName("SHO_REMARKS")
  String? shoRemarks;

  //@SerializedName("SHO_REMARKS_DT")
  String? shoRemarksDt;

  //@SerializedName("CHARACR_DESCRIPTION")
  String? characterDescription;

  //@SerializedName("IS_CRIMINAL_RECORD")
  String? isCriminalRecord;

  //@SerializedName("IS_ARRESTED")
  String? isArrested;

  AssignHistory(
      this.beatName,
      this.assignedTo,
      this.assignedDate,
      this.targetDate,
      this.remark,
      this.isResolved,
      this.photo,
      this.fillDt,
      this.lat,
      this.lng,
      this.eoName,
      this.eoRemarks,
      this.eoRemarksDt,
      this.shoRemarks,
      this.shoRemarksDt,
      this.characterDescription,
      this.isCriminalRecord,
      this.isArrested);

  factory AssignHistory.fromJson(json) {
    return AssignHistory(
        json["BEAT_NAME"],
        json["ASSIGNED_TO_NAME"],
        json["ASSIGN_DT"],
        json["TARGET_DT5"],
        json["REMARKS"],
        json["IS_RESOLVED"],
        json["PHOTO"],
        json["FILL_DT"],
        json["LAT"].toString(),
        json["LONG"].toString(),
        json["EO_NAME"],
        json["EO_REMARKS"],
        json["EO_REMARKS_DT"],
        json["SHO_REMARKS"],
        json["SHO_REMARKS_DT"],
        json["CHARACR_DESCRIPTION"],
        json["IS_CRIMINAL_RECORD"],
        json["IS_ARRESTED"]);
  }
}
