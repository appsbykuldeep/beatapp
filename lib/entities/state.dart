//@Entity(tableName = "m_state")
class State {
  //@PrimaryKey
  //@ColumnInfo(name = "STATE_CD")
  int? stateCD;

  //@ColumnInfo(name = "LANG_CD")
  int? langCD;

  //@ColumnInfo(name = "STATE")
  String? state;

  //@ColumnInfo(name = "RECORD_CREATED_ON")
  String? createdDate;

  State(int this.stateCD, String this.state);

  //@NonNull
  //@Override
  @override
  String toString() {
    return state!;
  }
}
