import 'package:intl/intl.dart';

class DateTimeUtils {
  static final dateFormat =
      DateFormat.yMMMEd(); //my choice DateFormat.yMMMEd();

  static String getFormatedDateFromMili(int miliSeconds) {
    var date = DateTime.fromMillisecondsSinceEpoch(miliSeconds);
    // var formattedDate = dateFormat.format(date);
    // return formattedDate;

    return getFormatedDateFromDateTime(date);
  }

  static String getFormatedDateFromDateTime(DateTime dateTime) {
    var formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }
}
