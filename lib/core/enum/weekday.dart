// ignore_for_file: constant_identifier_names

enum WeekDay {
  /// 월요일
  MONDAY(label: "월"),

  /// 화요일
  TUESDAY(label: "화"),

  /// 수요일
  WEDNESDAY(label: "수"),

  /// 목요일
  THURSDAY(label: "목"),

  /// 금요일
  FRIDAY(label: "금"),

  /// 토요일
  SATURDAY(label: "토"),

  /// 일요일
  SUNDAY(label: "일");

  final String label;

  const WeekDay({required this.label});

  factory WeekDay.fromJson(String json) {
    switch (json) {
      case "MONDAY":
        return WeekDay.MONDAY;
      case "TUESDAY":
        return WeekDay.TUESDAY;
      case "WEDNESDAY":
        return WeekDay.WEDNESDAY;
      case "THURSDAY":
        return WeekDay.THURSDAY;
      case "FRIDAY":
        return WeekDay.FRIDAY;
      case "SATURDAY":
        return WeekDay.SATURDAY;
      case "SUNDAY":
        return WeekDay.SUNDAY;
      default:
        throw Exception("Unsupported WeekDay");
    }
  }

  static WeekDay getTodayWeekDay() {
    final DateTime now = DateTime.now();
    switch (now.weekday) {
      case 1:
        return WeekDay.MONDAY;
      case 2:
        return WeekDay.TUESDAY;
      case 3:
        return WeekDay.WEDNESDAY;
      case 4:
        return WeekDay.THURSDAY;
      case 5:
        return WeekDay.FRIDAY;
      case 6:
        return WeekDay.SATURDAY;
      case 7:
        return WeekDay.SUNDAY;
      default:
        throw Exception("Unsupported WeekDay");
    }
  }
}
