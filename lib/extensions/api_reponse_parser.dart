// Extenstion for List<String>

extension GTFetchjsondata on List<String> {
  String fetchString(dynamic json, [String placeHolder = ""]) {
    return (_getString(
              otherkeys: this,
              jsondata: json,
            ) ??
            placeHolder)
        .trim();
  }

  double fetchdouble(dynamic json, [double placeHolder = 0]) {
    return _getDouble(
          otherkeys: this,
          jsondata: json,
        ) ??
        placeHolder;
  }

  int fetchint(dynamic json, [int placeHolder = 0]) {
    return _getInt(
          otherkeys: this,
          jsondata: json,
        ) ??
        placeHolder;
  }

  num fetchnum(dynamic json, [num placeHolder = 0]) {
    return _getNum(
          otherkeys: this,
          jsondata: json,
        ) ??
        placeHolder;
  }

  bool fetchbool(dynamic json, [bool placeHolder = false]) {
    return _getBool(
          otherkeys: this,
          jsondata: json,
        ) ??
        placeHolder;
  }

  DateTime fetchDateTime(dynamic json, [DateTime? placeHolder]) {
    return _getDateTime(
          otherkeys: this,
          jsondata: json,
          placeHolder: placeHolder,
        ) ??
        placeHolder ??
        DateTime(1990);
  }

  DateTime? fetchDateTimeOrNull(dynamic json, [DateTime? placeHolder]) {
    return _getDateTime(
          otherkeys: this,
          jsondata: json,
          placeHolder: placeHolder,
        ) ??
        placeHolder;
  }

  dynamic fetchdynamic(dynamic json, [dynamic placeHolder]) {
    return _getdynamic(
      otherkeys: this,
      jsondata: json,
      placeHolder: placeHolder,
    );
  }
}

// Extenstion for String

extension GTFetchjsondataFromString on String {
  String fetchString(dynamic json, [String placeHolder = ""]) {
    return (_getString(
              otherkeys: [this],
              jsondata: json,
            ) ??
            placeHolder)
        .trim();
  }

  double fetchdouble(dynamic json, [double placeHolder = 0]) {
    return _getDouble(
          otherkeys: [this],
          jsondata: json,
        ) ??
        placeHolder;
  }

  int fetchint(dynamic json, [int placeHolder = 0]) {
    return _getInt(
          otherkeys: [this],
          jsondata: json,
        ) ??
        placeHolder;
  }

  num fetchnum(dynamic json, [num placeHolder = 0]) {
    return _getNum(
          otherkeys: [this],
          jsondata: json,
        ) ??
        placeHolder;
  }

  bool fetchbool(dynamic json, [bool placeHolder = false]) {
    return _getBool(
          otherkeys: [this],
          jsondata: json,
        ) ??
        placeHolder;
  }

  DateTime fetchDateTime(dynamic json, [DateTime? placeHolder]) {
    return _getDateTime(
          otherkeys: [this],
          jsondata: json,
          placeHolder: placeHolder,
        ) ??
        placeHolder ??
        DateTime(1990);
  }

  DateTime? fetchDateTimeOrNull(dynamic json, [DateTime? placeHolder]) {
    return _getDateTime(
          otherkeys: [this],
          jsondata: json,
          placeHolder: placeHolder,
        ) ??
        placeHolder;
  }

  dynamic fetchdynamic(dynamic json, [dynamic placeHolder]) {
    return _getdynamic(
      otherkeys: [this],
      jsondata: json,
      placeHolder: placeHolder,
    );
  }
}

// Extenstion for Map<String,dynamic>

extension GTFetchjsondataFromMapStringDynamic on Map {
  String fetchString(String key, [String placeHolder = ""]) {
    return (_getString(
              otherkeys: [key],
              jsondata: this,
            ) ??
            placeHolder)
        .trim();
  }

  double fetchdouble(String key, [double placeHolder = 0]) {
    return _getDouble(
          otherkeys: [key],
          jsondata: this,
        ) ??
        placeHolder;
  }

  int fetchint(String key, [int placeHolder = 0]) {
    return _getInt(
          otherkeys: [key],
          jsondata: this,
        ) ??
        placeHolder;
  }

  bool fetchbool(String key, [bool placeHolder = false]) {
    return _getBool(
          otherkeys: [key],
          jsondata: this,
        ) ??
        placeHolder;
  }

  DateTime fetchDateTime(String key, [DateTime? placeHolder]) {
    return _getDateTime(
          otherkeys: [key],
          jsondata: this,
          placeHolder: placeHolder,
        ) ??
        placeHolder ??
        DateTime(1990);
  }

  DateTime? fetchDateTimeOrNull(String key, [DateTime? placeHolder]) {
    return _getDateTime(
          otherkeys: [key],
          jsondata: this,
          placeHolder: placeHolder,
        ) ??
        placeHolder;
  }

  dynamic fetchdynamic(String key, [dynamic placeHolder]) {
    return _getdynamic(
      otherkeys: [key],
      jsondata: this,
      placeHolder: placeHolder,
    );
  }
}

// Basic Fetch Function

String? _getString({
  required List<String> otherkeys,
  required dynamic jsondata,
}) {
  final data = _valueFetcher(json: jsondata, otherkeys: otherkeys);
  if (data == null) return null;
  if (data is String) return data.trim();
  return data.toString().trim();
}

bool? _getBool({
  required List<String> otherkeys,
  required dynamic jsondata,
}) {
  final data = _valueFetcher(json: jsondata, otherkeys: otherkeys);
  if (data == null) return null;
  if (data is bool) return data;
  if (data is num) return data == 1;
  // if (data is String) bool.tryParse(data);
  return null;
}

DateTime? _getDateTime({
  required List<String> otherkeys,
  required dynamic jsondata,
  DateTime? placeHolder,
}) {
  final data = _valueFetcher(json: jsondata, otherkeys: otherkeys);
  if (data == null) return placeHolder;
  if (data is String) DateTime.tryParse(data) ?? placeHolder;
  return placeHolder;
}

dynamic _getdynamic({
  required List<String> otherkeys,
  required dynamic jsondata,
  required dynamic placeHolder,
}) {
  return _valueFetcher(json: jsondata, otherkeys: otherkeys) ?? placeHolder;
}

double? _getDouble({
  required List<String> otherkeys,
  required dynamic jsondata,
}) {
  final result = _getNum(jsondata: jsondata, otherkeys: otherkeys);

  if (result == null) return null;
  return result.toDouble();
}

int? _getInt({
  required List<String> otherkeys,
  required dynamic jsondata,
}) {
  final result = _getNum(jsondata: jsondata, otherkeys: otherkeys);
  if (result == null) return null;
  return result.toInt();
}

num? _getNum({
  required List<String> otherkeys,
  required dynamic jsondata,
}) {
  final data = _valueFetcher(json: jsondata, otherkeys: otherkeys);
  if (data == null) return null;
  if (data is num) {
    return data;
  }

  if (data is String) {
    return num.tryParse(data);
  }

  return null;
}

dynamic _valueFetcher({
  required dynamic json,
  required List<String> otherkeys,
}) {
  try {
    otherkeys = otherkeys.map((e) => e.toLowerCase().trim()).toList();
    return (json as Map<String, dynamic>)
        .entries
        .firstWhere(
          (e) => otherkeys.contains(e.key.toLowerCase().trim()),
          orElse: () => const MapEntry("__NO__", null),
        )
        .value;
  } catch (e) {
    return null;
  }
}
