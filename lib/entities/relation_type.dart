import 'package:beatapp/custom_view/custom_dropdown_wid.dart';

class RelationType extends DropDownData {
  RelationType({
    this.RELATION_TYPE_CD = 0,
    this.LANG_CD = 0,
    this.RELATION_TYPE = '',
  }) : super(dropLabel: RELATION_TYPE);

  int RELATION_TYPE_CD;
  int LANG_CD;
  String RELATION_TYPE;

//fetchList
  static List<RelationType> fetchList(dynamic data) {
    if (data is! List) return [];

    try {
      return List<RelationType>.from(
          (data).map((e) => RelationType.fromJson(e)));
    } catch (e) {
      return [];
    }
  }

//fromJson
  factory RelationType.fromJson(Map<String, dynamic> json) {
    return RelationType(
      RELATION_TYPE_CD: json["RELATION_TYPE_CD"] ?? 0,
      LANG_CD: json["LANG_CD"] ?? 0,
      RELATION_TYPE: json["RELATION_TYPE"] ?? "",
    );
  }

  @override
  bool operator ==(covariant RelationType other) {
    if (identical(this, other)) return true;

    return other.RELATION_TYPE_CD == RELATION_TYPE_CD &&
        other.LANG_CD == LANG_CD &&
        other.RELATION_TYPE == RELATION_TYPE;
  }

  @override
  int get hashCode =>
      RELATION_TYPE_CD.hashCode ^ LANG_CD.hashCode ^ RELATION_TYPE.hashCode;
}
