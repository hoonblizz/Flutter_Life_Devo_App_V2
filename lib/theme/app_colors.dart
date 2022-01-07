import 'package:flutter/material.dart';

// final Color exampleColor = Colors.white;
const kPrimaryColor = Color(0xFF09DEC5);
const kPrimaryLightColor = Color(0xFF3cf7e1);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF09DEC5), Color(0xFF3cf7e1)],
);
const kSecondaryColor = Color(0xFFe7332d);
const kTextColor = Color(0xFF757575);

Color navBG = Colors.white;
Color navSelected = const Color(0xFF09DEC5);
Color navUnselected = const Color(0xFFE6E6E6);

// Main page
Color mainPageContentsDivider = kPrimaryColor.withOpacity(0.4);
