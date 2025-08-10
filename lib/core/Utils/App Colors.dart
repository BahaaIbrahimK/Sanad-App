import 'dart:math';

import 'package:flutter/material.dart';

class AppColorsData {
  AppColorsData._();

  // App Colors
  static const _primaryColorValue = 0xFF6179fa;
  Color getRandomColor() {
    Random random = Random();

    // Generate random values for red, green, and blue components
    int red = random.nextInt(256); // 0-255
    int green = random.nextInt(256); // 0-255
    int blue = random.nextInt(256); // 0-255

    // Create a Color object with the random components
    Color randomColor = Color.fromRGBO(red, green, blue, 1.0);

    return randomColor;
  }
  static const primarySwatch = MaterialColor(
    _primaryColorValue,
    {
      50: Color(0xFFD7F1EB),
      100: Color(0xFFAFE3D6),
      200: Color(0xFF86D5C2),
      300: Color(0xFF5EC7AD),
      400: Color(0xFF4DBBA0),
      500: Color(_primaryColorValue),
      600: Color(0xFFF7FFA4),
      700: Color(0xFFD4D834),
      800: Color(0xFFCFD32C),
      900: Color(0xFFC7CB1E),
    },
  );
  static const primaryColor = Color(0xFFDD7649);
  static const primaryColorYellow = Color(0xff2f3042);
  // Brand Colors
  static const greenYellow = Color(_primaryColorValue);
  static const orange = Color(0xFFF9A44F);

  static const blue = Color(0xFF2AA3D1);
  static const pink = Color(0xFFF45C77);
  static const babyBlue = Color(0xFFBFE6EF);

  // Basic Colors
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF0D0D0D);
  static const red = Color(0xFFE31F2F);
  static const lightRed = Color(0xFFE94E5B);
  static const green = Color(0xFF008243);
  static const lightGreen = Color(0xFF00B35C);
  static const veryLightGreen = Color(0xFFE5FFF3);
  static const brightOrange = Color(0xFFF78008);
  static const lightOrange = Color(0xFFFCD9B5);
  static const brightBlue = Color(0xFF14D3FF);
  static const darkBlue = Color(0xFF1A637F);
  static const brightPink = Color(0xFFFFDEE3);
  static const darkPink = Color(0xFFBB1129);
  static const lightPink = Color(0xFFFDE8EB);
  static const brightGreenYellow = Color(0xFFD7DB24);
  static const deepOrange = Color(0xFFEC533C);

  // Grey
  static const lightGrey = Color(0xFFFFFCE5);
  static const grey = Color(0xFFF2F2F2);
  static const mediumGrey = Color(0xFFF1F3F9);
  static const darkGrey = Color(0xFF808080);
}