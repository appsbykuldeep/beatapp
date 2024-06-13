import "dart:ffi";

class SubmitSummonDetailsRequest {
  //@SerializedName("SUMM_WARR_NUM")
  String? summWarrNUM;

  //@SerializedName("EXECTYPECD")
  int? execTypeCD;

  //@SerializedName("EXECREMARKS")
  String? execREMARKS;

  //@SerializedName("TYPE")
  String? type;

  //@SerializedName("LAT")
  String? lat;

  //@SerializedName("LONG")
  String? longitude;

  //@SerializedName("DELEIVERED_TO_NAME")
  String? deleiveredToNAME;

  //@SerializedName("RELATION_CD")
  String? relationCD;

  //@SerializedName("PHOTO")
  String? photo;

  //@SerializedName("IS_DELIVERED")
  Char? isDelivered;

  SubmitSummonDetailsRequest(
      this.summWarrNUM,
      this.execTypeCD,
      this.execREMARKS,
      this.type,
      this.lat,
      this.longitude,
      this.deleiveredToNAME,
      this.relationCD,
      this.photo,
      this.isDelivered);

  Map<String, dynamic> toJson() => {
        "SUMM_WARR_NUM": summWarrNUM,
        "EXECTYPECD": execTypeCD,
        "EXECREMARKS": execREMARKS,
        "TYPE": type,
        "LAT": lat,
        "LONG": longitude,
        "DELEIVERED_TO_NAME": deleiveredToNAME,
        "RELATION_CD": relationCD,
        "PHOTO": photo,
        "IS_DELIVERED": isDelivered
      };
}
