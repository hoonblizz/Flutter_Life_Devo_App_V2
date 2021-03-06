import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ThemeData lightTheme = ThemeData(
  fontFamily: 'Muli', // Archivo
  textTheme: TextTheme(
    bodyText1: TextStyle(
        color: const Color(0xFF404040),
        fontSize: Get.height * 0.019,
        fontFamily: 'Questrial'),
    bodyText2: TextStyle(
      color: const Color(0xFF404040),
      fontSize: Get.height * 0.020,
    ),
  ),
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
      iconTheme: (const IconThemeData(
        color: Color(0xFF3D3F43),
      )),
      backgroundColor: const Color(0xFFF9F9F9),
      toolbarTextStyle: TextTheme(
        headline6: TextStyle(
            color: const Color(0xFF3D3F43),
            fontSize: Get.height * 0.020,
            fontWeight: FontWeight.w500),
      ).bodyText2,
      titleTextStyle: TextTheme(
        headline6: TextStyle(
            color: const Color(0xFF3D3F43),
            fontSize: Get.height * 0.020,
            fontWeight: FontWeight.w500),
      ).headline6),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final ThemeData darkTheme = ThemeData(
  fontFamily: 'Muli', // Archivo
  textTheme: TextTheme(
    bodyText1: TextStyle(
        color: const Color(0xFFE0E0E0),
        fontSize: Get.height * 0.018,
        fontFamily: 'Questrial'),
    bodyText2: TextStyle(
      color: Colors.white,
      fontSize: Get.height * 0.020,
    ),
  ),
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
      iconTheme: (const IconThemeData(
        color: Colors.white,
      )),
      backgroundColor: const Color(0xFF1F2022),
      toolbarTextStyle: TextTheme(
        headline6: TextStyle(
            color: Colors.white,
            fontSize: Get.height * 0.020,
            fontWeight: FontWeight.w500),
      ).bodyText2,
      titleTextStyle: TextTheme(
        headline6: TextStyle(
            color: Colors.white,
            fontSize: Get.height * 0.020,
            fontWeight: FontWeight.w500),
      ).headline6),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
