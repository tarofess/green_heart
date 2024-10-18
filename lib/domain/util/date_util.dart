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

    final formatter = DateFormat('yyyy年MM月dd日 HH時mm分');
    return formatter.format(creationTime.toLocal());
  }

  static String convertToJapaneseDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('yyyy年MM月dd日', 'ja');
    return formatter.format(dateTime);
  }
}
