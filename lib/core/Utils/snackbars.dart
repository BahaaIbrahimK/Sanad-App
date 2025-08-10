import 'package:flutter/material.dart';

abstract class Snackbars {
  void success({required BuildContext context, required String message});
  void error({required BuildContext context, required String message});
  void info({required BuildContext context, required String message});
}
