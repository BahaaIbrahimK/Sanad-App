import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/App Colors.dart';
import '../Utils/App Textstyle.dart';
ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: AppColorsData.white,
  platform: TargetPlatform.iOS,
  fontFamily: "Urbanist",
  primaryColor: AppColorsData.primarySwatch,
  canvasColor: Colors.transparent,
  iconTheme: const IconThemeData(color: AppColorsData.primaryColor, size: 25),
  primarySwatch: Colors.orange,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColorsData.white,
    toolbarHeight: 50,
    elevation: 0,
    surfaceTintColor: AppColorsData.white,
    centerTitle: true,
    iconTheme: const IconThemeData(color: AppColorsData.black),
    titleTextStyle: AppTextStyles.bold.copyWith(
      color: AppColorsData.black,
      fontFamily: "Urbanist",
    ),
  ),
);
