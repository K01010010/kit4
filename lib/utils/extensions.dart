part of '../kit4.dart';

extension FutureList on List {
  Future<Iterable<T>> transform<T>(Future<T> Function(T e) method) async {
    List<T> result = <T>[];
    for (T value in this) {
      result.add(await method(value));
    }
    return result;
  }
}

enum JustDateType {
  onlyTime,
  onlyDate,
  onlyDateNamed,
  dateTime,
  timeDate,
  dateTimeNamed,
  timeDateNamed,
  timeOrDate,
  timeOrDateNamed,
  relative
}

enum IgnoreTimeType { second, minute, hour }

extension DescribeDuration on Duration {
  String? describe(int precision) {
    if (inSeconds < 0) return null;
    int years = inDays < 365 ? 0 : (inDays / 365).round();
    int days = inDays - years * 365;
    int hours = inHours - inDays * Duration.hoursPerDay;
    int minutes = inMinutes - inHours * Duration.minutesPerHour;
    int seconds = inSeconds - inMinutes * Duration.secondsPerMinute;
    // print("years = $years, days = $days, hours = $hours, minutes = $minutes, seconds = $seconds");
    // print("years = $years, days = $inDays, hours = $inHours, minutes = $inMinutes, seconds = $inSeconds");

    var yearsStr = years > 0 ? "$years лет" : null;
    var daysStr = days > 0 ? "$days дней" : null;
    var hoursStr = hours > 0 ? "$hours часов" : null;
    var minutesStr = minutes > 0 ? "$minutes минут" : null;
    var secondsStr = seconds > 0 ? "$seconds секунд" : null;

    List<String> results = [
      if (yearsStr != null) yearsStr,
      if (daysStr != null) daysStr,
      if (hoursStr != null) hoursStr,
      if (minutesStr != null) minutesStr,
      if (secondsStr != null) secondsStr,
    ];
    if (results.isEmpty) return "Только что";

    String description = "";
    for (var element in results) {
      if (precision > 0) {
        description =
            description.isNotEmpty ? "$description, $element" : element;
        precision--;
      }
    }

    return description;
  }
}

extension DescribeAge on int {
  String get ageDescribe {
    if (this == 999) return '';
    final remainder = this % 10;
    if (remainder > 0 && remainder < 5) return "$this года";
    return "$this лет";
  }
}

extension DescribeDate on DateTime {
  static List<String> monthes = [
    "январь",
    "февраль",
    "март",
    "апрель",
    "май",
    "июнь",
    "июль",
    "август",
    "сентябрь",
    "октябрь",
    "ноябрь",
    "декабрь",
  ];

  String get monthDescribe => monthes[month];

  String get paddedHour => hour.toString().padLeft(2, '0');

  String get paddedMinute => minute.toString().padLeft(2, '0');

  String get paddedDay => day.toString().padLeft(2, '0');

  String get paddedMonth => month.toString().padLeft(2, '0');

  String describe(
          [JustDateType type = JustDateType.relative,
          IgnoreTimeType? ignore]) =>
      toLocal().describeTime(type, ignore);

  String describeTime(
      [JustDateType type = JustDateType.relative, IgnoreTimeType? ignore]) {
    switch (type) {
      case JustDateType.onlyTime:
        return "$paddedHour:$paddedMinute";
      case JustDateType.onlyDate:
        return "$paddedDay.$paddedMonth.${year % 100}";
      case JustDateType.onlyDateNamed:
        return "$day $monthDescribe $year";
      case JustDateType.dateTime:
        return "$paddedDay.$paddedMonth.${year % 100} $paddedHour:$paddedMinute";
      case JustDateType.timeDate:
        return "$paddedHour:$paddedMinute $paddedDay.$paddedMonth.${year % 100}";
      case JustDateType.dateTimeNamed:
        return "$day $monthDescribe $year - $paddedHour:$paddedMinute";
      case JustDateType.timeDateNamed:
        return "$paddedHour:$paddedMinute - $day $monthDescribe $year";
      case JustDateType.timeOrDate:
        return _timeOrDate(false);
      case JustDateType.timeOrDateNamed:
        return _timeOrDate(true);
      case JustDateType.relative:
        return _describe(ignore);
    }
  }

  String _timeOrDate(bool named) {
    var timeDifference = difference(DateTime.now());

    ///Меньше суток
    if (timeDifference.inDays > -1) return "$paddedHour:$paddedMinute";
    if (named) return "$day $monthDescribe $year";
    return "$paddedDay.$paddedMonth.${year % 100}";
  }

  String _describe(IgnoreTimeType? ignore) {
    var timeDifference = difference(DateTime.now());

    String long = "${timeDifference.inDays.abs()} дней назад";
    if (timeDifference.inDays <= -365) {
      long = "${(timeDifference.inDays.abs() / 365).round()} лет назад";
    }

    if (timeDifference.inDays == -1) return "вчера";
    if (timeDifference.inDays < -1) return long;

    if (ignore == IgnoreTimeType.hour) return "Только что";
    if (timeDifference.inHours == -1 || timeDifference.inHours == -21) {
      return timeDifference.inHours == -1 ? "час назад" : "21 час назад";
    }
    if (timeDifference.inHours < -20) {
      return "${timeDifference.inHours.abs()} часа назад";
    }
    if (timeDifference.inHours < -4) {
      return "${timeDifference.inHours.abs()} часов назад";
    }
    if (timeDifference.inHours < -1) {
      return "${timeDifference.inHours.abs()} часа назад";
    }

    if (ignore == IgnoreTimeType.minute) return "Только что";
    var result = _chooseVariant(timeDifference.inMinutes,
        firstVariant: "минуту назад",
        secondVariant: "минут назад",
        thirdVariant: "минуты назад");
    if (ignore == IgnoreTimeType.second) return result ?? "Только что";
    result ??= _chooseVariant(timeDifference.inSeconds,
        firstVariant: "секунду назад",
        secondVariant: "секунд назад",
        thirdVariant: "секунды назад");
    return result ?? "Только что";
  }

  String? _chooseVariant(int negativeVal,
      {String firstVariant = "минуту назад",
      String secondVariant = "минут назад",
      String thirdVariant = "минуты назад"}) {
    ///[10,20,30,40,50] минут назад"
    if (negativeVal % 10 == 0 && negativeVal != 0) {
      return "${negativeVal.abs()} $secondVariant";
    }

    ///[1] минуту назад [21,31,41,51] минуту назад
    if (negativeVal % 10 == -1) {
      return negativeVal == -1
          ? firstVariant
          : "${negativeVal.abs()} $firstVariant";
    }

    ///[5,6,7,8,9,11,12,13,14,15,16,17,18,19] минут назад
    if (negativeVal < -4 && negativeVal > -20) {
      return "${negativeVal.abs()} $secondVariant";
    }

    ///[25,26,27,28,29] минут [35,36,37,38,39] минут [45,46,47,48,49] минут [55,56,57,58,59] минут
    if (negativeVal % 10 < -4) {
      return "${negativeVal.abs()} $secondVariant";
    }

    ///[2,3,4] минуты [22,23,24] минуты [32,33,34] минуты [42,43,44] минуты [52,53,54] минуты
    if (negativeVal <= -1) {
      return "${negativeVal.abs()} $thirdVariant";
    }
    return null;
  }
}

extension PrintString on String {
  //Was 1023 before adding \n in printing
  void printFull({String debugTag = "DEBUG_TAG", int maxSymbols = 1020}) {
    var str = "######$debugTag######\n$this\n######$debugTag######\n";
    if (kDebugMode) {
      while (str.length > maxSymbols) {
        String segment = str.substring(0, maxSymbols);
        print("\n$segment");
        str = str.substring(maxSymbols);
      }

      if (str.isNotEmpty) {
        print("\n$str");
      }
    } else {
      BaseLoggerService.log("$str\n$this\n$str");
    }
  }

  Map<String, dynamic> get decode => jsonDecode(this);

  void log([String? debugTag]) =>
      // ignore: avoid_print
      kDebugMode
          ? printFull(debugTag: debugTag ?? "DEBUG_TAG")
          : BaseLoggerService.log(this, debugTag);

  // ignore: avoid_print
  void logConsole() => print(this);

  //String tag = "DEBUG_TAG"
  void recordError([dynamic err, StackTrace? st]) {
    if (kDebugMode) {
      if (err is DioException && err.message != null) {
        err = err.message;
      }
      "$err\n\nSTACKTRACE: $st".printFull(debugTag: this);
    } else {
      BaseLoggerService.recordError(
          "######$this######\n$err\n######$this######", st);
    }
  }
}

extension MapExtension on Map {
  String get encode => jsonEncode(this);
}

extension ColorToStringExtension on Color {
  String get hashString => "0x${value.toRadixString(16).padLeft(8, '0')}";
}

extension StringToColorExtension on String {
  Color get hexToColor => Color(int.parse(this));
}

extension FilterExtension on Color {
  ColorFilter get filter => ColorFilter.mode(this, BlendMode.srcIn);
}

extension ExtendingDio on Dio {
  static String? _dioToken;

  String? get dioToken => _dioToken;

  set dioToken(String? val) => _dioToken = val;

  void setToken(String? token, {String prefix = "Bearer "}) {
    dioToken = token;
    if (token == null) {
      options.headers.remove('Authorization');
    } else {
      options.headers['Authorization'] = '$prefix$token';
    }
  }
}

extension ResponseExtension on Response {
  String get describe => "\n"
      "  REQUEST was on ${requestOptions.path}\n"
      "  REQUEST TYPE ${requestOptions.method}\n"
      "  DATA of Response : ${jsonEncode(data ?? "")}\n";
}

extension RequestOptionsExtension on RequestOptions {
  String get describeOnError => "\n"
      "  REQUEST was on $path\n"
      "  REQUEST TYPE $method\n"
      "  DATA of Request : ${jsonEncode(data ?? "")}\n";
}

extension DioExceptionExtension on DioException {
  String get describe => "\n"
      "  REQUEST was on ${requestOptions.path}\n"
      "  REQUEST TYPE ${requestOptions.method}\n"
      "  DATA of Error : ${jsonEncode(requestOptions.data ?? "")}\n"
      "  ERROR of Error : $errorMessage\n"
      "  TYPE of Error  : $type\n"
      "  RESPONSE of Error : $response\n";

  String? get errorMessage {
    try {
      return response?.data["msg"];
    } catch (e) {
      return null;
    }
  }
}
