//@Entity(tableName = "M_INCIDENT_TYPE")
class IncidentType {
  //@PrimaryKey
  //@ColumnInfo(name = "INCIDENT_CD")
  int? incidentCD;

  //@ColumnInfo(name = "LANG_CD")
  int? langCD;

  //@ColumnInfo(name = "INCIDENT_TYPE")
  String? incidentType;

  //@ColumnInfo(name = "RECORD_CREATED_ON")
  String? createdDate;

  //@NonNull
  //@Override
  @override
  String toString() {
    return incidentType!;
  }
}
