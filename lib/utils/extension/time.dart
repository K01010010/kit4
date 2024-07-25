part of 'extensions.dart';

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

// enum IgnoreTimeType { second, minute, hour, day, week, month, }

extension DescribeDuration on Duration {
  String? describe(int precision,
      {Map<PluralTimeType, bool> ignore = const {}}) {
    if (inSeconds < 0) return null;
    int years = (ignore[PluralTimeType.year] ?? false)
        ? 0
        : (inDays < 365 ? 0 : (inDays / 365).ceil());
    int months = (ignore[PluralTimeType.month] ?? false)
        ? 0
        : ((inDays - years * 365) / 30).ceil();
    int weeks = (ignore[PluralTimeType.week] ?? false)
        ? 0
        : ((inDays - years * 365 - months * 30) / 7).ceil();
    int days = (ignore[PluralTimeType.day] ?? false)
        ? 0
        : inDays - years * 365 - months * 30 - weeks * 7;
    int hours = (ignore[PluralTimeType.hour] ?? false)
        ? 0
        : inHours - inDays * Duration.hoursPerDay;
    int minutes = (ignore[PluralTimeType.minute] ?? false)
        ? 0
        : inMinutes - inHours * Duration.minutesPerHour;
    int seconds = (ignore[PluralTimeType.second] ?? false)
        ? 0
        : inSeconds - inMinutes * Duration.secondsPerMinute;
    int milliseconds = (ignore[PluralTimeType.millisecond] ?? true)
        ? 0
        : inMilliseconds - inSeconds * Duration.millisecondsPerSecond;
    int microseconds = (ignore[PluralTimeType.microsecond] ?? true)
        ? 0
        : inMicroseconds - inMilliseconds * Duration.microsecondsPerMillisecond;

    var yearsStr = years.yearPluralRu;
    var monthStr = months.monthPluralRu;
    var weekStr = weeks.weekPluralRu;
    var daysStr = days.dayPluralRu;
    var hoursStr = hours.hourPluralRu;
    var minutesStr = minutes.minutePluralRu;
    var secondsStr = seconds.secondPluralRu;
    var millisecondsStr = seconds.secondPluralRu;
    var microsecondsStr = seconds.secondPluralRu;

    List<String> results = [
      if (yearsStr != null) yearsStr,
      if (monthStr != null) monthStr,
      if (weekStr != null) weekStr,
      if (daysStr != null) daysStr,
      if (hoursStr != null) hoursStr,
      if (minutesStr != null) minutesStr,
      if (secondsStr != null) secondsStr,
      if (millisecondsStr != null) millisecondsStr,
      if (microsecondsStr != null) microsecondsStr,
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

extension DescribeDate on DateTime {
  static List<String> monthesRu = [
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

  String get monthDescribe => monthesRu[month];

  String get paddedHour => hour.toString().padLeft(2, '0');

  String get paddedMinute => minute.toString().padLeft(2, '0');

  String get paddedDay => day.toString().padLeft(2, '0');

  String get paddedMonth => month.toString().padLeft(2, '0');

  String describe(
          [JustDateType type = JustDateType.relative,
          PluralTimeType? ignore]) =>
      toLocal().describeTime(type, ignore);

  String describeTime(
      [JustDateType type = JustDateType.relative, PluralTimeType? ignore]) {
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

  String _describe(PluralTimeType? showUntil,
      {Map<PluralTimeType, bool> ignore = const {}}) {
    var timeDifference = difference(DateTime.now());

    if (timeDifference.inDays <= -365 &&
        !(ignore[PluralTimeType.year] ?? false)) {
      var str = ((timeDifference.inDays.abs() / 365).ceil()).getPluralRuVariant(
        singleVariant: "года",
        pairVariant: "лет",
        manyVariant: "лет",
      );
      return "Более $str";
      // return "${((timeDifference.inDays.abs() / 365).round()).yearPluralRu}";
    }
    if (showUntil == PluralTimeType.year) return "Только что";

    var result = (timeDifference.inDays.abs() / 30)
        .ceil()
        .monthPluralRu
        ?.filterIgnore(ignore[PluralTimeType.month]);
    if (showUntil == PluralTimeType.month) return "Только что";

    result ??= (timeDifference.inDays.abs() / 7)
        .ceil()
        .weekPluralRu
        ?.filterIgnore(ignore[PluralTimeType.week]);
    if (showUntil == PluralTimeType.week) return result ?? "Только что";

    if (timeDifference.inDays == -1) return "вчера";
    result ??= timeDifference.inDays
        .abs()
        .dayPluralRu
        ?.filterIgnore(ignore[PluralTimeType.day]);
    if (showUntil == PluralTimeType.day) return result ?? "Только что";

    result ??= timeDifference.inHours.hourPluralRu
        ?.filterIgnore(ignore[PluralTimeType.hour]);
    if (showUntil == PluralTimeType.hour) return result ?? "Только что";

    result ??= timeDifference.inMinutes.minutePluralRu
        ?.filterIgnore(ignore[PluralTimeType.minute]);
    if (showUntil == PluralTimeType.minute) return result ?? "Только что";

    result ??= timeDifference.inSeconds.secondPluralRu
        ?.filterIgnore(ignore[PluralTimeType.second]);
    if (showUntil == PluralTimeType.second) return result ?? "Только что";

    return result ?? "Только что";
  }
}