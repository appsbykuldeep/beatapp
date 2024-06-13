class ArrestStatusUpdateRequest {
  //@SerializedName("ACCUSED_SRNO")
  String? accusedSrNo;

  //@SerializedName("FIR_REG_NUM")
  String? firRegNum;

  //@SerializedName("IS_ARRESTED")
  String? isArrested;

  //@SerializedName("IS_RESOLVED")
  String? isResolved;

  //@SerializedName("REMARKS")
  String? remark;

  //@SerializedName("LAT")
  String? lat;

  //@SerializedName("LONG")
  String? lng;

  //@SerializedName("PHOTO")
  String? photo;

  ArrestStatusUpdateRequest(this.accusedSrNo, this.firRegNum, this.isArrested,
      this.isResolved, this.remark, this.lat, this.lng, this.photo);

  Map<String, dynamic> toJson() => {
        "ACCUSED_SRNO": accusedSrNo,
        "FIR_REG_NUM": firRegNum,
        "IS_ARRESTED": isArrested,
        "IS_RESOLVED": isResolved,
        "REMARKS": remark,
        "LAT": lat,
        "LONG": lng,
        "PHOTO": photo
      };
}
