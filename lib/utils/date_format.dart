import 'package:intl/intl.dart';

String formatDate(DateTime datetime) {
  return DateFormat('dd MMM, yyyy').format(datetime);
}
