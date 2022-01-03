import 'package:flutter/material.dart';

// final Color exampleColor = Colors.white;
const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

Color navBG = Colors.white;
Color navSelected = const Color(0xFF525252);
Color navUnselected = const Color(0xFFE6E6E6);

BoxShadow shadow =
    const BoxShadow(color: Colors.black26, spreadRadius: -3, blurRadius: 5);

LinearGradient gradientButton =
    const LinearGradient(colors: [Color(0xFFFFF0E7), Color(0xFFFFC6C4)]);

Color tabBarUnderline = const Color(0xFFFF8C93);

Color activatedColor = const Color(0xFFC2DD53);
Color upcomingColor = const Color(0xFFFFC6C4);
Color completedColor = const Color(0xFF363636);

Color messagePillBG = const Color(0xFF363636);
