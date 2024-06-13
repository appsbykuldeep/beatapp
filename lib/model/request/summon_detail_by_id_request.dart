class SummonDetailByIDRequest {
  String? SUMM_WARR_NUM;
  String? TYPE;

  SummonDetailByIDRequest(this.SUMM_WARR_NUM, this.TYPE);

  Map<String, dynamic> toJson() =>
      {"SUMM_WARR_NUM": SUMM_WARR_NUM, "TYPE": TYPE};
}
