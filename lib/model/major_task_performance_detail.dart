class MajorTaskPerformanceDetail {
  //@SerializedName("InvMajorTaskSrno")
  String? invMajorTaskSrno;

  //@SerializedName("InvMajorTaskTypeCd")
  String? invMajorTaskTypeCd;

  //@SerializedName("InvMajorTaskType")
  String? invMajorTaskType;

  //@SerializedName("InvMajorTaskOthers")
  String? invMajorTaskOthers;

  //@SerializedName("InvMajorTaskDesc")
  String? invMajorTaskDesc;

  //@SerializedName("WitnessName")
  String? witnessName;

  //@SerializedName("Dob")
  String? dob;

  //@SerializedName("WitnessVillage")
  String? witnessVillage;

  //@SerializedName("WitnessCountryCD")
  String? witnessCountryCD;

  //@SerializedName("WitnessStateCD")
  String? witnessStateCD;

  //@SerializedName("WitnessDistrictCD")
  String? witnessDistrictCD;

  //@SerializedName("WitnessPSCD")
  String? witnessPSCD;

  MajorTaskPerformanceDetail(
      this.invMajorTaskSrno,
      this.invMajorTaskTypeCd,
      this.invMajorTaskType,
      this.invMajorTaskOthers,
      this.invMajorTaskDesc,
      this.witnessName,
      this.dob,
      this.witnessVillage,
      this.witnessCountryCD,
      this.witnessStateCD,
      this.witnessDistrictCD,
      this.witnessPSCD);

  factory MajorTaskPerformanceDetail.fromJson(json) {
    return MajorTaskPerformanceDetail(
        json["InvMajorTaskSrno"],
        json["InvMajorTaskTypeCd"],
        json["InvMajorTaskType"],
        json["InvMajorTaskOthers"],
        json["InvMajorTaskDesc"],
        json["WitnessName"],
        json["Dob"],
        json["WitnessVillage"],
        json["WitnessCountryCD"],
        json["WitnessStateCD"],
        json["WitnessDistrictCD"],
        json["WitnessPSCD"]);
  }

/*     String? InvMajorTaskSrno;
     String? InvMajorTaskTypeCd;
     String? InvMajorTaskOthers;
     String? InvMajorTaskDesc;
     String? WitnessName;
     String? Dob;
     String? WitnessVillage;
     String? WitnessCountryCD;
     String? WitnessStateCD;
     String? WitnessDistrictCD;
     String? WitnessPSCD;*/
}
