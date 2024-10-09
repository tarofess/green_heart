import 'package:intl/intl.dart';

class DateUtil {
  static String convertToYYYYMMDD(String dateString) {
    final DateFormat inputFormat = DateFormat('yyyy年MM月dd日');
    final DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    final DateTime date = inputFormat.parse(dateString);
    return outputFormat.format(date);
  }
}
