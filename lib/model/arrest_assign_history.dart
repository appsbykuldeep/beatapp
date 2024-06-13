import 'assign_history.dart';

class ArrestAssignHistory extends AssignHistory {
  //@SerializedName("IS_ARRESTED")
  @override
  String? isArrested;

  ArrestAssignHistory(this.isArrested)
      : super('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
            '', '');

  factory ArrestAssignHistory.fromJson(json) {
    return ArrestAssignHistory(json["IS_ARRESTED"]);
  }
}
