import 'package:intl/intl.dart';

class DateFormators {
  // formators using intl package
  static String formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat("dd MMMM yyyy").format(dateTime);
  }
}
