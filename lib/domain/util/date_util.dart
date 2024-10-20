import 'package:intl/intl.dart';

class DateUtil {
  static String convertToYYYYMMDD(String dateString) {
    final DateFormat inputFormat = DateFormat('yyyy年MM月dd日');
    final DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    final DateTime date = inputFormat.parse(dateString);
    return outputFormat.format(date);
  }

  static String formatCreationTime(DateTime? creationTime) {
    if (creationTime == null) return '日時不明';

    final formatter = DateFormat('yyyy年MM月dd日');
    return formatter.format(creationTime.toLocal());
  }

  static String convertToJapaneseDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('yyyy年MM月dd日', 'ja');
    return formatter.format(dateTime);
  }

  static int calculateAge(DateTime birthDate) {
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
