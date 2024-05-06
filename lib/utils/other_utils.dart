import 'package:intl/intl.dart';

class OtherUtils{
  static String formatDateTime(DateTime dateTime) {
    // Define the desired format
    final DateFormat formatter = DateFormat('yyyy:MM:dd HH:mm');

    // Return the formatted date-time string
    return formatter.format(dateTime);
  }

  static String getDate(DateTime dateTime){
    // Define a DateFormat to output 'YYYY:MM:DD'
    DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

    // Format the DateTime to get only the date
    String dateOnly = dateFormatter.format(dateTime);
    return dateOnly;
  }
}