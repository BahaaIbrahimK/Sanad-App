import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  String formattedTime(BuildContext context) {
    return DateFormat.jm(context.locale.languageCode).format(this);
  }

  String formattedDate(BuildContext context) {
    if (dateEquals(DateTime.now())) return 'اليوم';

    if (dateEquals(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'الامس';
    }

    return DateFormat.yMMMMd(context.locale.languageCode).format(this);
  }

  DateTime get dateOnly => DateTime(year, month, day);

  bool dateEquals(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
