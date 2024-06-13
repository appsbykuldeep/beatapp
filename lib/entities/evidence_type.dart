//@Entity(tableName = "m_evidence_type")
class EvidenceType {
  //@PrimaryKey
  //@ColumnInfo(name = "ID")
  int? id;

  //@ColumnInfo(name = "LANG_CD")
  int? langCD;

  //@ColumnInfo(name = "EVIDENCE_TYPE_CD")
  int? evidenceTypeCD;

  //@ColumnInfo(name = "EVIDENCE_TYPE")
  String? evidenceType;

  //@ColumnInfo(name = "RECORD_STATUS")
  String? recordStatus;

  //@NonNull
  //@Override
  @override
  String toString() {
    return evidenceType!;
  }
}
