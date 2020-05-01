import 'package:intl/intl.dart';

String getTimeDifference(DateTime date) {
  if (date == null)
    return "error";
  DateTime now = DateTime.now();

  var difference = now.difference(date);

  if (difference.inDays >= 365) {
    // return time.strftime("%d %B %Y");
    return new DateFormat('d B Y').format(date).toString();
  } else if (difference.inDays >= 7) {
    // return time.strftime("%d %B");
    return new DateFormat('d B').format(date).toString();
  } else if (difference.inDays > 1) {
    return difference.inDays.toString() + " days ago";
  } else if (difference.inDays == 1) {
    return difference.inDays.toString() + " day ago";
  } else if (difference.inHours > 1) {
    return difference.inHours.toString() + " hours ago";
  } else if (difference.inHours == 1) {
    return difference.inHours.toString() + " hour ago";
  } else if (difference.inMinutes > 1) {
    return difference.inMinutes.toString() + " minutes ago";
  } else if (difference.inMinutes == 1) {
    return difference.inMinutes.toString() + " minute ago";
  } else{
    return difference.inSeconds.toString() + " seconds ago";
  }
}
