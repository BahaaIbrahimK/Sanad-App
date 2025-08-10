import 'package:flutter/material.dart';

class DateTimeSelectionState {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final DateTime startDate;
  final DateTime endDate;

  DateTimeSelectionState({
    required this.startTime,
    required this.endTime,
    required this.startDate,
    required this.endDate,
  });

  DateTimeSelectionState copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return DateTimeSelectionState(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}