import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'extra_cubit/extra_cubit.dart';
import 'extra_cubit/extra_states.dart';


navigateTo( context,screen) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

navigateAndReplace( context,screen) =>
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => screen));

navigateAndFinished( context,screen) =>
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => screen),(route) => false);


String getTimeWithAMPM(TimeOfDay time) {
  final now = DateTime.now();
  final DateTime dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  final format = DateFormat.jm();
  return format.format(dateTime);
}


String formatDate(DateTime date) {
  return '${date.year}-${date.month}-${date.day}';
}

void selectTime(
    BuildContext context, bool isStartTime, TimeOfDay initialTime) async {
  final TimeOfDay? newTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
  );

  if (newTime != null) {
    if (isStartTime) {
      context.read<DateTimeSelectionCubit>().updateStartTime(newTime);
    } else {
      context.read<DateTimeSelectionCubit>().updateEndTime(newTime);
    }
  }
}

void selectDate(BuildContext context, bool isStartDate, DateTime initialDate,
    DateTimeSelectionState state) async {
  final DateTime? newDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: isStartDate ? DateTime.now() : state.startDate,
    lastDate: DateTime(DateTime.now().year + 1),
  );

  if (newDate != null) {
    if (isStartDate) {
      context.read<DateTimeSelectionCubit>().updateStartDate(newDate);
    } else {
      if (newDate.isAfter(state.startDate) ||
          newDate.isAtSameMomentAs(state.startDate)) {
        context.read<DateTimeSelectionCubit>().updateEndDate(newDate);
      } else {
      }
    }
  }
}