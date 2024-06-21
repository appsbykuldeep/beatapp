enum AppUserType {
  sho,
  invitigativeOfficer,
  beat,
  eo,
  sp,
  co,
  dcrb,
  liu,
  headConst,
  officer,
  other;

  bool get isSHO => this == sho;
  bool get isBeat => this == beat;
  bool get isOther => this == other;
  bool get isSp => this == sp;
  bool get isHeadConst => this == headConst;
  bool get isCO => this == co;
  bool get isEO => this == eo;
  bool get isDCRB => this == dcrb;
  bool get isLIU => this == liu;
  bool get isOfficer => this == officer;
  bool get isinvitigativeOfficer => this == invitigativeOfficer;
}
