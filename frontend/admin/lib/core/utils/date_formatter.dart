import 'package:intl/intl.dart';

String formatDateTime(DateTime date) {
  final local = date.toLocal();
  return DateFormat('dd MMM yyyy • HH:mm').format(local);
}
