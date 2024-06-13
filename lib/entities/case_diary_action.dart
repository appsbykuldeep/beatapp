//@Entity(tableName = "m_case_diary_action")
 class CaseDiaryAction {
    CaseDiaryAction({this.caseDiaryActionCD,this.caseDiaryAction});

    //@PrimaryKey
    //@ColumnInfo(name = "ID")
     int? id;
    //@ColumnInfo(name = "LANG_CD")
     int? langCD;
    //@ColumnInfo(name = "CASE_DIARY_ACTION_CD")
     int? caseDiaryActionCD;
    //@ColumnInfo(name = "CASE_DIARY_ACTION")
     String? caseDiaryAction;
    //@ColumnInfo(name = "RECORD_STATUS")
     String? recordStatus;
}
