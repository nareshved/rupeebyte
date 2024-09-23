import 'package:intl/intl.dart';

class DateTimeUtils {
  static final dateFormat = DateFormat
      .yMMMEd(); //my choice DateFormat.yMMMEd(); // for date with like Sunday

  static final monthFormat =
      DateFormat.yM(); //my choice DateFormat.M(); // for month

  static final yearFormat =
      DateFormat.y(); //my choice DateFormat.y(); // for year

  static final monthDateFormate = DateFormat.LLLL();
  // static final YearFormate = DateFormat.y();

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

  // format Months

  static String getFormatedMonthFromMili(int miliSeconds) {
    var month = DateTime.fromMillisecondsSinceEpoch(miliSeconds);
    // var formattedDate = dateFormat.format(date);
    // return formattedDate;

    return getFormatedMonthFromDateTime(month);
  }

  static String getFormatedMonthFromDateTime(DateTime dateTime) {
    var formattedMonth = monthFormat.format(dateTime);
    return formattedMonth;
  }


}
