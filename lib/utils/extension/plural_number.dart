part of 'extensions.dart';

enum PluralNumbType { single, pair, many }

enum PluralTimeType {
  year,
  month,
  week,
  day,
  hour,
  minute,
  second,
  millisecond,
  microsecond,
}

extension NumberPluralExtension on int {
  PluralNumbType get _getPluralRu {
    if (this == 0) return PluralNumbType.many;
    if (this > 10 && this < 20) return PluralNumbType.many;
    var remainder = this % 10;
    if (remainder == 1) return PluralNumbType.single;
    if (1 < remainder && remainder < 5) return PluralNumbType.pair;
    return PluralNumbType.many;
  }

  String? get microsecondPluralRu => getPluralRuVariant(
        singleVariant: "микросекунда",
        pairVariant: "микросекунды",
        manyVariant: "микросекунд",
      );

  String? get millisecondPluralRu => getPluralRuVariant(
        singleVariant: "миллисекунда",
        pairVariant: "миллисекунды",
        manyVariant: "миллисекунд",
      );

  String? get secondPluralRu => getPluralRuVariant(
        singleVariant: "секунда",
        pairVariant: "секунды",
        manyVariant: "секунд",
      );

  String? get minutePluralRu => getPluralRuVariant(
        singleVariant: "минута",
        pairVariant: "минуты",
        manyVariant: "минут",
      );

  String? get hourPluralRu => getPluralRuVariant(
        singleVariant: "час",
        pairVariant: "часа",
        manyVariant: "часов",
      );

  String? get dayPluralRu => getPluralRuVariant(
        singleVariant: "день",
        pairVariant: "дня",
        manyVariant: "дней",
      );

  String? get weekPluralRu => getPluralRuVariant(
        singleVariant: "неделя",
        pairVariant: "недели",
        manyVariant: "недель",
      );

  String? get monthPluralRu => getPluralRuVariant(
        singleVariant: "месяц",
        pairVariant: "месяца",
        manyVariant: "месяцев",
      );

  String? get yearPluralRu => getPluralRuVariant(
        singleVariant: "год",
        pairVariant: "года",
        manyVariant: "лет",
      );

  String? getPluralRuWithTimeType(PluralTimeType type) => switch (type) {
        PluralTimeType.microsecond => microsecondPluralRu,
        PluralTimeType.millisecond => millisecondPluralRu,
        PluralTimeType.second => secondPluralRu,
        PluralTimeType.minute => minutePluralRu,
        PluralTimeType.hour => hourPluralRu,
        PluralTimeType.day => dayPluralRu,
        PluralTimeType.week => weekPluralRu,
        PluralTimeType.month => monthPluralRu,
        PluralTimeType.year => yearPluralRu,
      };

  String? getPluralRuVariant({
    String singleVariant = "минуту назад",
    String pairVariant = "минуты назад",
    String manyVariant = "минут назад",
  }) {
    int val = abs();
    if (val < 1) return null;
    return switch (val._getPluralRu) {
      PluralNumbType.single => "$val $singleVariant",
      PluralNumbType.pair => "$val $pairVariant",
      PluralNumbType.many => "$val $manyVariant",
    };
  }
}

extension IgnoreFilter on String {
  String? filterIgnore(bool? ignore) => (ignore ?? false) ? null : this;
}