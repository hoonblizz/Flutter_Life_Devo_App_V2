import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/theme/app_texts.dart';

Padding statusPill(text, Color color) {
  return Padding(
    padding: const EdgeInsets.all(13),
    child: Container(
      height: Get.height * 0.04,
      width: Get.width * 0.22,
      decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(35)),
      child: Center(
        child: Text(
          text,
          style: statusPillFont,
        ),
      ),
    ),
  );
}
