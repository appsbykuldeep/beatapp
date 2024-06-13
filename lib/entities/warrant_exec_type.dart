//@Entity(tableName = "m_warrant_exec_type")
class WarrantExecType {
  //@PrimaryKey
  //@ColumnInfo(name = "EXEC_TYPE_CD")
  int? execTypeCD;

  //@ColumnInfo(name = "LANG_CD")
  int? langCD;

  //@ColumnInfo(name = "EXECUTION_TYPE")
  String? executionType;

  //@ColumnInfo(name = "RECORD_CREATED_ON")
  String? createdDate;
}
