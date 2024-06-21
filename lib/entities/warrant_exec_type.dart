// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:beatapp/custom_view/custom_dropdown_wid.dart';
import 'package:beatapp/utility/extentions/api_reponse_parser.dart';

class WarrantExecType extends DropDownData {
  int execTypeCD;
  int langCD;
  String executionType;
  WarrantExecType({
    this.execTypeCD = 0,
    this.langCD = 0,
    this.executionType = "",
  }) : super(dropLabel: executionType);

  static List<WarrantExecType> fetchList(dynamic data) {
    if (data is! List) return [];
    try {
      return List<WarrantExecType>.from(
          (data).map((e) => WarrantExecType.fromJson(e)));
    } catch (e) {
      return [];
    }
  }

  factory WarrantExecType.fromJson(Map<String, dynamic> json) {
    return WarrantExecType(
      execTypeCD: ['EXEC_TYPE_CD'].fetchint(json),
      langCD: ['LANG_CD'].fetchint(json),
      executionType: ['EXECUTION_TYPE'].fetchString(json),
    );
  }

  @override
  String toString() =>
      'WarrantExecType(execTypeCD: $execTypeCD, langCD: $langCD, executionType: $executionType)';

  @override
  bool operator ==(covariant WarrantExecType other) {
    if (identical(this, other)) return true;

    return other.execTypeCD == execTypeCD &&
        other.langCD == langCD &&
        other.executionType == executionType;
  }

  @override
  int get hashCode =>
      execTypeCD.hashCode ^ langCD.hashCode ^ executionType.hashCode;
}
