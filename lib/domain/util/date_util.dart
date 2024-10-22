import 'package:intl/intl.dart';

class DateUtil {
  static DateTime? convertToDateTime(String dateString) {
    if (dateString.isEmpty) return null;

    final DateFormat formatter = DateFormat('yyyy年MM月dd日');
    final DateTime date = formatter.parse(dateString);
    return date;
  }

  static String convertToJapaneseDate(DateTime? birthday) {
    if (birthday == null) return '';

    DateFormat formatter = DateFormat('yyyy年MM月dd日', 'ja');
    return formatter.format(birthday);
  }

  static String formatAccountRegistrationTime(DateTime? creationTime) {
    if (creationTime == null) return '日時不明';

    final formatter = DateFormat('yyyy年MM月dd日');
    return formatter.format(creationTime.toLocal());
  }

  static String formatPostTime(DateTime? postTime) {
    if (postTime == null) return '日時不明';

    final formatter = DateFormat('yyyy/MM/dd HH:mm');
    return formatter.format(postTime.toLocal());
  }

  static int getAgeFromBirthday(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
