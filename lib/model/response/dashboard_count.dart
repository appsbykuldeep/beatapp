class DashboardCount {
  int PendingCharacterCertificate = 0;
  int CompletedCharacterCertificate = 0;
  int TotalCharacterCertificate = 0;
  int EnquiryCompletedCharacterCertificate = 0;
  int PendingWantedCriminals = 0;
  int CompletedWantedCriminals = 0;
  int PendingSummonList = 0;
  int CompletedSummonList = 0;
  int PendingWarrantList = 0;
  int CompletedWarrantList = 0;
  int PendingTENANT = 0;
  int CompletedTENANT = 0;
  int TotalTenant = 0;
  int PendingEmployeeList = 0;
  int CompletedEmployeeList = 0;
  int PendingDomesticHelp = 0;
  int CompletedDomesticHelp = 0;
  int TotalDomesticHelp = 0;
  int TotalArms_Weapons = 0;
  int PendingArms_Weapons = 0;
  int TotalSharedInfo = 0;
  int TotalHistorySheeter = 0;
  int TotalEnquiryCompletedHistorySheeter = 0;
  int TotalBeatAlocated = 0;
  int EnquiryCompletedArms_Weapons = 0;
  int CompletedHistorySheeter = 0;
  int PendingHistorySheeter = 0;
  int TotalWantedCriminals = 0;
  int TotalPendingWantedCriminals = 0;
  int TotalCompletedWantedCriminals = 0;
  int TotalCitezenMsg = 0;
  int PendingCitezenMsg = 0;
  int EnquiryCompletedCitizenMsg = 0;
  int CompletedCitezenMsg = 0;
  int TotalTENANTList = 0;
  int TotalEnquiryCompletedTENANT = 0;
  int TotalEmployeeList = 0;
  int EnquiryCompletedEmployees = 0;
  int TotalDomesticHelpList = 0;
  int EnquiryCompleteDeomesticList = 0;
  int TotalCharacterCertificateList = 0;


  static DashboardCount fromJson(json) {
    DashboardCount dashboardCount = DashboardCount();
    dashboardCount.EnquiryCompletedCharacterCertificate = json["EnquiryCompletedCharacterCertificate"]??0;
    dashboardCount.TotalEnquiryCompletedHistorySheeter = json["TotalEnquiryCompletedHistorySheeter"]??0;
    dashboardCount.TotalTenant = json["TotalTenant"]??0;
    dashboardCount.TotalDomesticHelp = json["TotalDomesticHelp"]??0;
    dashboardCount.TotalCharacterCertificate = json["TotalCharacterCertificate"]??0;
    dashboardCount.TotalCharacterCertificateList = json["TotalCharacterCertificateList"]??0;
    dashboardCount.TotalDomesticHelpList = json["TotalDomesticHelpList"]??0;
    dashboardCount.EnquiryCompleteDeomesticList = json["EnquiryCompleteDeomesticList"]??0;
    dashboardCount.TotalEmployeeList = json["TotalEmployeeList"]??0;
    dashboardCount.EnquiryCompletedEmployees = json["EnquiryCompletedEmployees"]??0;
    dashboardCount.TotalTENANTList = json["TotalTENANTList"]??0;
    dashboardCount.TotalEnquiryCompletedTENANT = json["TotalEnquiryCompletedTENANT"]??0;
    dashboardCount.TotalCitezenMsg = json["TotalCitezenMsg"]??0;
    dashboardCount.PendingCitezenMsg = json["PendingCitezenMsg"]??0;
    dashboardCount.EnquiryCompletedCitizenMsg = json["EnquiryCompletedCitizenMsg"]??0;
    dashboardCount.CompletedCitezenMsg = json["CompletedCitezenMsg"]??0;
    dashboardCount.TotalWantedCriminals = json["TotalWantedCriminals"]??0;
    dashboardCount.TotalPendingWantedCriminals = json["TotalPendingWantedCriminals"]??0;
    dashboardCount.TotalCompletedWantedCriminals = json["TotalCompletedWantedCriminals"]??0;
    dashboardCount.PendingArms_Weapons = json["PendingArms_Weapons"]??0;
    dashboardCount.CompletedHistorySheeter = json["CompletedHistorySheeter"]??0;
    dashboardCount.PendingHistorySheeter = json["PendingHistorySheeter"]??0;
    dashboardCount.PendingCharacterCertificate = json["PendingCharacterCertificate"]??0;
    dashboardCount.EnquiryCompletedArms_Weapons =
        json["EnquiryCompletedArms_Weapons"]??0;
    dashboardCount.CompletedCharacterCertificate =
        json["CompletedCharacterCertificate"]??0;
    dashboardCount.PendingWantedCriminals =
        json["PendingWantedCriminals"]??0;
    dashboardCount.CompletedWantedCriminals =
        json["CompletedWantedCriminals"]??0;
    dashboardCount.PendingSummonList = json["PendingSummonList"]??0;
    dashboardCount.CompletedSummonList = json["CompletedSummonList"]??0;
    dashboardCount.PendingWarrantList = json["PendingWarrantList"]??0;
    dashboardCount.CompletedWarrantList =
        json["CompletedWarrantList"]??0;
    dashboardCount.PendingTENANT = json["PendingTENANT"]??0;
    dashboardCount.CompletedTENANT = json["CompletedTENANT"]??0;
    dashboardCount.PendingEmployeeList = json["PendingEmployeeList"]??0;
    dashboardCount.CompletedEmployeeList =
        json["CompletedEmployeeList"]??0;
    dashboardCount.PendingDomesticHelp = json["PendingDomesticHelp"]??0;
    dashboardCount.CompletedDomesticHelp =
        json["CompletedDomesticHelp"]??0;
    dashboardCount.TotalArms_Weapons = json["TotalArms_Weapons"]??0;
    dashboardCount.TotalSharedInfo = json["TotalSharedInfo"]??0;
    dashboardCount.TotalHistorySheeter = json["TotalHistorySheeter"]??0;
    dashboardCount.TotalBeatAlocated = json["TotalBeatAlocated"]??0;
    return dashboardCount;
  }

  static DashboardCount emptyData() {
    return DashboardCount();
  }
}
