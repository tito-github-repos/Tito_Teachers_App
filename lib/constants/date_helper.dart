import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();

  static String monthYear(
    int month,
    int year,
  ) {
    return DateFormat(
      'MMM yyyy',
    ).format(
      DateTime(year, month),
    );
  }

  static String fullMonthYear(
    int month,
    int year,
  ) {
    return DateFormat(
      'MMMM yyyy',
    ).format(
      DateTime(year, month),
    );
  }

  static String formatDate(
    DateTime date,
  ) {
    return DateFormat(
      'dd MMM yyyy',
    ).format(date);
  }

  static String formatDateTime(
    DateTime date,
  ) {
    return DateFormat(
      'dd MMM yyyy hh:mm a',
    ).format(date);
  }
  static String shortMonth(int month) {
  return DateFormat('MMM').format(
    DateTime(2026, month),
  );
}

}
