class DateTimeHelper {
  /*var now = new DateTime.now();
  var now_1w = now.subtract(Duration(days: 7));
  var now_1m = new DateTime(now.year, now.month-1, now.day);
  var now_1y = new DateTime(now.year-1, now.month, now.day);
  return now_1w;*/

  static DateTime getBefor1Week() {
    var now = DateTime.now();
    var now_1w = now.subtract(const Duration(days: 7));
    return now_1w;
  }

  static DateTime get15days() {
    var now = DateTime.now();
    var now_15d = now.subtract(const Duration(days: 15));
    return now_15d;
  }

  static DateTime getBefore30day() {
    var now = DateTime.now();
    var now_30d = now.subtract(const Duration(days: 30));
    return now_30d;
  }
}

/*print(DateTime.parse('2020-01-02')); // 2020-01-02 00:00:00.000
print(DateTime.parse('20200102')); // 2020-01-02 00:00:00.000
print(DateTime.parse('-12345-03-04')); // -12345-03-04 00:00:00.000
print(DateTime.parse('2020-01-02 07')); // 2020-01-02 07:00:00.000
print(DateTime.parse('2020-01-02T07')); // 2020-01-02 07:00:00.000
print(DateTime.parse('2020-01-02T07:12')); // 2020-01-02 07:12:00.000
print(DateTime.parse('2020-01-02T07:12:50')); // 2020-01-02 07:12:50.000
print(DateTime.parse('2020-01-02T07:12:50Z')); // 2020-01-02 07:12:50.000Z
print(DateTime.parse('2020-01-02T07:12:50+07')); // 2020-01-02 00:12:50.000Z
print(DateTime.parse('2020-01-02T07:12:50+0700')); // 2020-01-02 00:12:50.00
print(DateTime.parse('2020-01-02T07:12:50+07:00')); // 2020-01-02 00:12:50.00*/

/*print(new DateFormat('yyyy/MM/dd').parse('x'));
print(new DateFormat('yyyy/MM/dd').parse(null));*/

