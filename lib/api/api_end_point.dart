// ignore_for_file: constant_identifier_names

class EndPoints {
  /// Testing Server
  static const String host = "http://164.100.181.132";

  /// Live Server
  // static const String host = "http://45.64.156.147";

  static bool get isLiveApk => host.contains("45.64.156.147");

  static const String BASE_URL = "$host/PrahariAPI/";
  static const String BASE_URLToken = "$host/PrahariToken/";

  static const String END_POINT_GET_VERSION = "Version/GetVersion";

  static const String DASHBOARD_COUNT = "Dashboard/GetAllCountForDashboard";
  static const String GET_CONTACT_BOOK_DETAIL =
      "ContackBook/GetContactBookDetail";

  //User authentication
  static const String END_POINT_LOGIN = "Login";
  static const String END_POINT_VALIDATE_MOBILE = "UserDetails/ValUser";
  static const String END_POINT_LOGOUT = "UserDetails/Logout";
  static const String END_POINT_GET_USER_OFFICE = "UserDetails/GetOffices";

  //Information Sharing
  static const String END_POINT_SAVE_SHARED_INFO = "SharedInfo/SaveSharedInfo";
  static const String END_POINT_GET_SHARED_INFO_LIST_SHO =
      "SharedInfo/GetSharedInfoListBySHO";
  static const String END_POINT_GET_SHARED_INFO_LIST_HC =
      "SharedInfo/GetSharedInfoListByBeatPerson";
//     static final String END_POINT_GET_SHARED_INFO_DETAIL = "SharedInfo/GetSharedInfoDetailByInfoID";
  static const String END_POINT_SHARED_INFO_SAVE_REMARK =
      "SharedInfo/SaveChatRemarks";
  static const String END_POINT_SHARED_INFO_GET_REMARK_HISTORY =
      "SharedInfo/GetChatRemarksHistory";

  static const String END_POINT_SAVE_SOOCHNA = "Soochna/SaveSoochna";
  static const String END_POINT_VIEW_SOOCHNA_LIST_SHO = "Soochna/ViewSoochna";
  static const String END_POINT_VIEW_SOOCHNA_LIST_BEAT =
      "Soochna/ViewSoochnaToBeat";
  static const String END_POINT_SOOCHNA_SAVE_REMARK =
      "Soochna/SaveSoochnaChatRemarks";
  static const String END_POINT_SOOCHNA_GET_REMARK_HISTORY =
      "Soochna/GetSoochnaChatRemarks";

  static const String END_POINT_GET_CITIZENS_MESSAGES = "CS/ShareInfo";
  static const String END_POINT_GET_CITIZEN_MESSAGE_DETAIL = "CS/ShareInfoDtl";
  static const String END_POINT_SAVE_CITIZENS_MESSAGE_REMARK =
      "CS/SaveChatRemarks";
  static const String END_POINT_GET_CITIZEN_MESSAGE_REMARK =
      "CS/GetChatRemarksHistory";

  //Arrest
  static const String END_POINT_GET_PENDING_ARREST_LIST_PS =
      "PendingArrest/GetPendingArrest";
  static const String END_POINT_GET_COMPLETED_ARREST_LIST_SHO =
      "PendingArrest/ArrestCompletedList";
  static const String END_POINT_GET_ASSIGNED_ARREST_LIST_SHO =
      "PendingArrest/ArrestAssignedList";
  static const String END_POINT_GET_ASSIGNED_ARREST_LIST_BEAT =
      "PendingArrest/ArrestAssignedListToBeat";
  static const String END_POINT_GET_COMPLETED_ARREST_LIST_BEAT =
      "PendingArrest/ArrestCompletedListToBeat";
  static const String END_POINT_GET_ACCUSED_DETAIL =
      "PendingArrest/AccusedDetailByID";
  static const String END_POINT_ASSIGN_ARREST_TO_BEAT =
      "PendingArrest/ArrestAssignToBeat";
  static const String END_POINT_SUBMIT_ARREST_DETAIL_BEAT =
      "PendingArrest/SubmitArrestStatus";
  static const String END_POINT_GET_ARREST_HISTORY =
      "PendingArrest/AssignHistory";

  /*Summon*/
  static const String UNASSIGNED_SUMMON = "Summon/GetPendingSummonListAtPS";
  static const String PENDING_SUMMON = "Summon/GetAssignedSummonListToSHO";
  static const String COMPLETED_SUMMON = "Summon/GetCompletedSummonListToSHO";
  static const String SUMMON_ASSIGN_POLICE_OFFICER =
      "Summon/SummanAssignPoliceOfficer";
  static const String GET_SUMMON_DETAIL_BY_ID = "Summon/GetSummonDetailByID";
  static const String SUMMON_ASSIGN_TO_OFFICER = "Summon/SummonAssignToOfficer";

  /*Summon Beat*/
  static const String PENDING_SUMMON_BEAT =
      "Summon/GetPendingSummonListToBeatPerson";
  static const String COMPLETED_SUMMON_BEAT =
      "Summon/GetCompletedSummonListToBeatPerson";
  static const String SUBMIT_SUMMON_DETAILS = "Summon/SubmitSummonDetails";

  /*BEAT ALLOTMENT 18-02-2020*/
  static const String BEAT_ASSIGNMENT = "Beat/BeatAssignment";
  static const String VIEW_BEAT_ASSIGNMENT_LIST = "Beat/ViewBeatAssignmentList";
  static const String VIEWT_ASSIGNEMENT_TO_BEAT = "Beat/ViewTAssignmentToBeat";
  static const String REMOVE_BEAT_ASSIGNMENT = "Beat/RemoveBeatAssignment";
  static const String CHECK_BEAT_STATUS = "Beat/CheckStatus";
  static const String TYPE = "Self";

  //Master data
  static const String END_POINT_GET_BEAT_MASTER = "Beat/GetBeatMaster";
  static const String END_POINT_GET_WEAPON_TYPE = "ArmsHolder/GetArmsType";
  static const String END_POINT_GET_BEAT_CONSTABLE_LIST =
      "Beat/GetBeatConstableList";
  static const String END_POINT_GET_BEAT_CONSTABLE_BY_BEAT_CD =
      "Beat/GetBeatConsByBeatCD";
  static const String END_POINT_POST_VILLAGE_ADD_DATA =
      "Village/SaveVillageMaster";
  static const String END_POINT_POST_VILLAGE_DELETE =
      "Village/DeleteVillageMaster";

  //Summary
  static const String DASHBOARD_SUMMARY = "Dashboard/Summary";

  //Area
  static const String END_POINT_GET_AREA_MASTER = "Beat/GetAreaMaster";
  static const String END_POINT_ADD_AREA = "Beat/AddArea";
  static const String END_POINT_ADD_BEAT_AREA = "Beat/AddBeatArea";
  static const String END_POINT_DELETE_AREA = "Beat/RemoveAreaMaster";
  static const String END_POINT_GET_BEAT_AREA_LIST = "Beat/GetBeatAreaList";
  static const String END_POINT_REMOVE_BEAT_AREA = "Beat/RemoveBeatArea";

  //Character Certificate
  static const String END_POINT_GET_PENDING_CHARACTER_LIST_PS =
      "Character/UnassignedCharacterList";
  static const String END_POINT_GET_ASSIGNED_CHARACTER_LIST_PS =
      "Character/AssignedCharacterList";
  static const String END_POINT_GET_COMPLETED_CHARACTER_LIST_PS =
      "Character/CompletedCharacterList";
  static const String END_POINT_GET_ASSIGNED_CHARACTER_LIST_BEAT =
      "Character/AssignedCharacterListToCons";
  static const String END_POINT_GET_COMPLETED_CHARACTER_LIST_BEAT =
      "Character/CompletedCharacterListToCons";
  static const String END_POINT_GET_CHARACTER_VERIFICATION_DETAIL =
      "Character/GetCharacterVerificationDetail";
  static const String END_POINT_ASSIGN_CHARACTER_TO_BEAT =
      "Character/AssignCharacterToBeatConstable";
  static const String END_POINT_SUBMIT_CHARACTER_VERIFICATION =
      "Character/SubmitCharacterVerification";
  static const String END_POINT_CHARACTER_SUBMIT_ACTION =
      "Character/SubmitSHOAction";
  static const String COMPLETED_CHARACTER_LIST_SHO =
      "Character/CompletedCharacterListSHO";
  static const String PENDING_CHARACTER_LIST_DCRB =
      "Character/PendingListOfDCRB";
  static const String PENDING_CHARACTER_LIST_LIU = "Character/PendingListOfLIU";
  static const String SUBMIT_CHARACTER_VERIFICATION_DCRB =
      "Character/DCRBAction";
  static const String SUBMIT_CHARACTER_VERIFICATION_LIU = "Character/LIUAction";
  static const String PENDING_CHARACTER_LIST_EO = "Character/PendingListOfEO";
  static const String COMPLETED_CHARACTER_LIST_EO =
      "Character/CompletedListOfEO";
  static const String PENDING_CHARACTER_LIST_SP = "Character/PendingListOfSP";
  static const String SUBMIT_CHARACTER_VERIFICATION_SP = "Character/SPAction";

  //Tenant Verification
  static const String END_POINT_UNASSIGNED_TENENT_LIST =
      "Tenant/UnassignedTenantList";
  static const String END_POINT_ASSIGNED_TENENT_LIST =
      "Tenant/AssignedTenantList";
  static const String END_POINT_COMPLETED_TENENT_LIST =
      "Tenant/CompletedTenantList";
  static const String ASSIGN_TENANT_TO_BEAT_CONSTABLE =
      "Tenant/AssignTenantToBeatConstable";
  static const String GET_TENANT_VERIFICATION_DETAIL =
      "Tenant/GetTenantVerificationDetail";
  static const String ASSIGNED_TENANT_LIST_TO_CONS =
      "Tenant/AssignedTenantListToCons";
  static const String COMPLETED_TENANT_LIST_TO_CONS =
      "Tenant/CompletedTenantListToCons";
  static const String SUBMIT_TENANT_VERIFICATION =
      "Tenant/SubmitTenantVerification";
  static const String GET_TENANT_ENQUIRY_OFFICER_LIST =
      "Tenant/GetEnquiryOfficerList";
  static const String GET_CHARACTER_VERIFICATION_ENQUIRY_OFFICER_LIST =
      "Tenant/GetEnquiryOfficerList";
  static const String END_POINT_TENANT_SUBMIT_ACTION = "Tenant/SubmitSHOAction";
  static const String COMPLETED_TENANT_LIST_SHO =
      "Tenant/CompletedTenantListSHO";
  static const String PENDING_TENANT_LIST_LIU = "Tenant/PendingListOfLIU";
  static const String PENDING_TENANT_LIST_DCRB = "Tenant/PendingListOfDCRB";
  static const String SUBMIT_TENANT_VERIFICATION_DCRB = "Tenant/DCRBAction";
  static const String SUBMIT_TENANT_VERIFICATION_LIU = "Tenant/LIUAction";
  static const String PENDING_TENANT_LIST_EO = "Tenant/PendingListOfEO";
  static const String COMPLETED_TENANT_LIST_EO = "Tenant/CompletedListOfEO";
  static const String PENDING_TENANT_LIST_SP = "Tenant/PendingListOfSP";
  static const String SUBMIT_TENANT_VERIFICATION_SP = "Tenant/SPAction";

  //Employee Verification
  static const String END_POINT_UNASSIGNED_EMPLOYEE_LIST =
      "Employee/UnassignedEmployeeList";
  static const String END_POINT_ASSIGNED_EMPLOYEE_LIST =
      "Employee/AssignedEmployeeList";
  static const String END_POINT_COMPLETED_EMPLOYEE_LIST =
      "Employee/CompletedEmployeeList";
  static const String END_POINT_ASSIGNED_EMPLOYEE_CONS =
      "Employee/AssignedEmployeeListToCons";
  static const String END_POINT_COMPLETED_EMPLOYEE_CONS =
      "Employee/CompletedEmployeeListToCons";
  static const String ASSIGN_EMPLOYEE_TO_BEAT_CONSTABLE =
      "Employee/AssignEmployeeToBeatConstable";
  static const String GET_EMPLOYEE_VERIFICATION_DETAIL =
      "Employee/GetEmployeeVerificationDetail";
  static const String SUBMIT_EMPLOYEE_VERIFICATION =
      "Employee/SubmitEmployeeVerification";
  static const String GET_ENQUIRY_OFFICER_LIST =
      "Employee/GetEnquiryOfficerList";
  static const String END_POINT_EMPLOYEE_SUBMIT_ACTION =
      "Employee/SubmitSHOAction";
  static const String COMPLETED_EMPLOYEE_LIST_SHO =
      "Employee/CompletedEmployeeListSHO";
  static const String PENDING_EMPLOYEE_LIST_LIU = "Employee/PendingListOfLIU";
  static const String PENDING_EMPLOYEE_LIST_DCRB = "Employee/PendingListOfDCRB";
  static const String SUBMIT_EMPLOYEE_VERIFICATION_DCRB = "Employee/DCRBAction";
  static const String SUBMIT_EMPLOYEE_VERIFICATION_LIU = "Employee/LIUAction";
  static const String PENDING_EMPLOYEE_LIST_EO = "Employee/PendingListOfEO";
  static const String COMPLETED_EMPLOYEE_LIST_EO = "Employee/CompletedListOfEO";
  static const String PENDING_EMPLOYEE_LIST_SP = "Employee/PendingListOfSP";
  static const String SUBMIT_EMPLOYEE_VERIFICATION_SP = "Employee/SPAction";

  //Domestic Verification
  static const String END_POINT_UNASSIGNED_DOMESTIC_LIST =
      "Domestic/UnassignedDomesticList";
  static const String END_POINT_ASSIGNED_DOMESTIC_LIST =
      "Domestic/AssignedDomesticList";
  static const String END_POINT_COMPLETED_DOMESTIC_LIST =
      "Domestic/CompletedDomesticList";
  static const String END_POINT_ASSIGNED_DOMESTIC_CONS =
      "Domestic/AssignedDomesticListToCons";
  static const String END_POINT_COMPLETED_DOMESTIC_CONS =
      "Domestic/CompletedDomesticListToCons";
  static const String ASSIGN_DOMESTIC_TO_BEAT_CONSTABLE =
      "Domestic/AssignDomesticToBeatConstable";
  static const String GET_DOMESTIC_VERIFICATION_DETAIL =
      "Domestic/GetDomesticVerificationDetail";
  static const String SUBMIT_DOMESTIC_VERIFICATION =
      "Domestic/SubmitDomesticVerification";
  static const String GET_DOMESTIC_ENQUIRY_OFFICER_LIST =
      "Domestic/GetEnquiryOfficerList";
  static const String END_POINT_DOMESTIC_SUBMIT_ACTION =
      "Domestic/SubmitSHOAction";
  static const String COMPLETED_DOMESTIC_LIST_SHO =
      "Domestic/CompletedDomesticListSHO";
  static const String PENDING_DOMESTIC_LIST_LIU = "Domestic/PendingListOfLIU";
  static const String PENDING_DOMESTIC_LIST_DCRB = "Domestic/PendingListOfDCRB";
  static const String SUBMIT_DOMESTIC_VERIFICATION_DCRB = "Domestic/DCRBAction";
  static const String SUBMIT_DOMESTIC_VERIFICATION_LIU = "Domestic/LIUAction";
  static const String PENDING_DOMESTIC_LIST_EO = "Domestic/PendingListOfEo";
  static const String COMPLETED_DOMESTIC_LIST_EO = "Domestic/CompletedListOfEo";
  static const String PENDING_DOMESTIC_LIST_SP = "Domestic/PendingListOfSP";
  static const String SUBMIT_DOMESTIC_VERIFICATION_SP = "Domestic/SPAction";

  //Citizen Messages
  static const String ASSIGNED_CS_SHARED_INFO_LIST =
      "CS/AssignedCSSharedInfoList";
  static const String COMPLETED_CS_SHARED_INFO_LIST =
      "CS/CompletedCSSharedInfoList";
  static const String ASSIGNED_SHARED_INFO_LIST_TO_CONS =
      "CS/AssignedSharedInfoListToCons";
  static const String COMPLETED_SHARED_INFO_LIST_TO_CONS =
      "CS/CompletedSharedInfoListToCons";
  static const String ASSIGN_CS_TO_BEAT_CONSTABLE =
      "CS/AssignCSToBeatConstable";
  static const String SUBMIT_CS_SHARED_INFO_VERIFICATION =
      "CS/SubmitCSSharedInfoVerification";
  static const String PENDING_SHARED_INFO_LIST_TO_EO =
      "CS/PendingSharedInfoListToEO"; //For EO
  static const String SUBMIT_CS_SHARED_INFO_EO = "CS/SubmitCSSharedInfoEO";
  static const String SUBMIT_CS_SHARED_INFO_SHO = "CS/SubmitCSSharedInfoSHO";
  static const String COMPLETED_CSSHARED_INFO_LIST_SHO =
      "CS/CompletedCSSharedInfoListSHO";

  //Enquiry Officer
  static const String CS_EO_ACTION_LIST = "EO/CSEOActionList";
  static const String SUBMIT_EO_REPORT = "EO/SubmitEOReport";

  //Dashboard
  static const String END_POINT_SEARCH_RECORD = "Dashboard/SearchRecord";
  static const String GET_ROLE_BASED_DISTRICT =
      "Dashboard/GetRoleBasedDistrict";

  //Beat Register - Weapon Verification
  static const String GET_LSCD_WPN_LIST = "Registers/GetLscdWpnList";
  static const String GET_SHO_ARMS_WPN_LIST = "ArmsHolder/GetArmsHolderListPS";
  static const String GET_VERIFIED_LSCD_WPN_LIST =
      "Registers/GetVerifiedLscdWpnList";
  static const String GET_LSCD_WPN_DETAILS = "Registers/GetLscdWpnDetails";
  static const String GET_ARMS_WPN_DETAILS = "ArmsHolder/GetArmHolderDetails";
  static const String SUBMIT_WEAPON_VERIFICATION =
      "Registers/SubmitWeaponVerification";

  //Beat Register - History Sheeters
  static const String GET_HISTORY_SHEETERS_DETAILS =
      "Registers/GetHistorySheeterDetails";
  static const String GET_REPORT_HISTORY_SHEETERS_DETAILS = "Reports/HSTReport";
  static const String GET_REPORT_AREA_DETAILS = "Reports/AreaReport";
  static const String GET_REPORT_BEAT_DETAILS = "Reports/ViewAssignmentReport";
  static const String GET_REPORT_ARMS_WEAPON_DETAILS = "Reports/WeaponReport";
  static const String GET_Village_DETAILS = "Village/GetVillageMaster";
  static const String GET_REPORT_Village_DETAILS = "Reports/VillStreetReport";
  static const String GET_REPORT_HISTORY_SHEETERS_DOWNLOAD =
      "Reports/HSTReportDownload";
  static const String GET_REPORT_AREA_DOWNLOAD = "Reports/AreaReportDownload";
  static const String GET_REPORT_ASSIGNMENT_DOWNLOAD =
      "Reports/ViewAssignmentReportDownload";
  static const String GET_REPORT_ARMS_DOWNLOAD = "Reports/WeaponReportDownload";
  static const String GET_REPORT_VILLAGE_DOWNLOAD =
      "Reports/VillStreetReportDownload";
  static const String GET_REMOVE_BEAT_MASTER = "Beat/RemoveAreaMaster";
  static const String GET_VALIDATED_HISTORY_SHEETERS_DETAILS =
      "Registers/GetValidatedHistorySheeterDetails";
  static const String GET_HST_DETAILS = "Registers/GetHSTDetails";
  static const String SUBMIT_HST_VERIFICATION =
      "HistorySheeter/SubmitHSTVerification"; //"Registers/SubmitHSTVerification";
  static const String SUBMIT_HST_ADD_DATA =
      "HistorySheeter/SubmitHistorySheeterDetails";
  static const String SUBMIT_HST_UPDATE_DATA =
      "HistorySheeter/EditHistorySheeterDetails";
  static const String DELETE_HST_BY_SHO = "HistorySheeter/DeleteHistorySheeter";
  static const String GET_HST_DETAIL = "HistorySheeter/GetHSTDetails";
  static const String GET_HST_LIST_SHO =
      "HistorySheeter/GetHistorySheeterListPS";

  /*Notices / Alerts*/
  static const String GET_REMINDER = "Alerts/Reminder";
  static const String SEND_RESPONSE = "Alerts/Response";

  //Download documents
  static const String DOWNLOAD_SHO_UPLOADED_DOCS = "Common/GetSHOUploadedDoc";

  static const String SUBMIT_ARMS_WEAPON_ADD =
      "ArmsHolder/SubmitArmsHolderDetails";
  static const String SUBMIT_ARMS_WEAPON_UPDATE =
      "ArmsHolder/EditArmsHolderDetails";
  static const String DELETE_ARMS_WEAPON_BY_SHO = "ArmsHolder/DeleteArmsHolder";

  static const String GET_HST_SP_LIST = "HistorySheeter/PendingApprovalSP";
  static const String GET_HST_SP_DETAIL = "HistorySheeter/GetHSTDetailsSP";
  static const String SUBMIT_HST_SP_DATA = "HistorySheeter/SubmitSPApproval";

  static const String GET_RANK_MASTER = "CMaster/GetRankMaster";
  static const String POST_CONSTABLE_DATA = "CMaster/SaveConstable";
  static const String VALIDATE_CONSTABLE_PNO = "CMaster/ValidateMobilePNO";
  static const String VALIDATE_CONSTABLE_MOBILE = "CMaster/ValidateMobile";
  static const String GET_CONSTABLE_LIST = "CMaster/GetConstableList";
  static const String POST_CONSTABLE_DATA_DELETE = "CMaster/EditBeatCons";
  static const String CONSTABLE_DATA_DELETE = "CMaster/DeleteBeatCons";
  static const String BEAT_DATA_SUBMIT = "Beat/SaveBeat";
  static const String BEAT_DELETE = "Beat/DeleteBeat";
  static const String BEAT_VIEW_LIST = "Beat/ViewBeatList";

  /*Feedback*/
  static const String ADD_FEEDBACK = "Feedback/AddFeedback";

  /*Reports*/
  /*Citizen Service Status*/
  static const String CITIZEN_SERVICE_STATUS = "Reports/CitizenServicesStatus";
  static const String CITIZEN_SERVICE_STATUS_DOWNLOAD =
      "Reports/CitizenServicesStatusDownload";

  /*Transfer Cases*/
  static const String TRANSFER_CASES = "Assign/TransCases";

  /*Group*/
  static const String CREATE_GROUP = "Group/CreateGroup";
  static const String GET_GROUP_LIST = "Group/GetGroupList";
  static const String GET_GROUP_DETAILS = "Group/GetGroupDetail";
  static const String GET_USER_LIST = "Group/GetUserList";
  static const String EDIT_GROUP = "Group/EditGroup";
  static const String DELETE_GROUP = "Group/DeleteGroup";
  static const String SEND_NOTIFICATION = "Group/SendNotification";
  static const String GET_NOTIFICATION = "Group/GetNotification";

  /*Case Diary*/
  static const String GET_FIR_DETAIL = "CaseDiary/GetFirDetail";
  static const String SAVE_CASE_DIARY_DETAIL = "CaseDiary/SaveCaseDiaryDetail";
  static const String VIEW_CASE_DIARY_LIST = "CaseDiary/ViewCaseDiaryList";
  static const String GET_CASE_DIARY_RECORD = "CaseDiary/GetCaseDiaryRecord";
  static const String PRINT_CASE_DIARY_RECORD =
      "CaseDiary/PrintCaseDiaryRecord";

  static const String mapVillageMasterToBeat = "Village/MapVillageMasterToBeat";
}
