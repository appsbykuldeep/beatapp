import '../beat_person_detail.dart';

class BeatAssignmentRequest {
  String? SHO_CUG;
  String? ASSIGNMENT_DT;
  String? PS_CD;
  String? BEAT_CD;
  List<BeatPersonDetail>? BEAT_PERSON_DETAIL;

  BeatAssignmentRequest(this.SHO_CUG, this.ASSIGNMENT_DT, this.PS_CD,
      this.BEAT_CD, this.BEAT_PERSON_DETAIL);

  Map<String, dynamic> toJson() =>
      {
        "SHO_CUG": SHO_CUG,
        "ASSIGNMENT_DT": ASSIGNMENT_DT,
        "PS_CD": PS_CD,
        "BEAT_CD": BEAT_CD,
        "BEAT_PERSON_DETAIL": BEAT_PERSON_DETAIL
      };
}

