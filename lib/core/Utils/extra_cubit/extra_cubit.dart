import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'extra_states.dart';

class DateTimeSelectionCubit extends Cubit<DateTimeSelectionState> {
  DateTimeSelectionCubit()
      : super(DateTimeSelectionState(
    startTime: const TimeOfDay(hour: 0, minute: 0),
    endTime: const TimeOfDay(hour: 0, minute: 0),
    startDate: DateTime.now(),
    endDate: DateTime.now(),
  ));




  void updateStartTime(TimeOfDay newStartTime) {
    emit(state.copyWith(startTime: newStartTime));
  }

  void updateEndTime(TimeOfDay newEndTime) {
    emit(state.copyWith(endTime: newEndTime));
  }



  void updateStartDate(DateTime newStartDate) {
    emit(state.copyWith(startDate: newStartDate));

    // تحديث تاريخ النهاية إذا كان قبل تاريخ البداية
    if (state.endDate.isBefore(newStartDate)) {
      emit(state.copyWith(endDate: newStartDate));
    }
  }

  void updateEndDate(DateTime newEndDate) {
    // التحقق من أن تاريخ النهاية لا يأتي قبل تاريخ البداية
    if (!newEndDate.isBefore(state.startDate)) {
      emit(state.copyWith(endDate: newEndDate));
    }
  }
}