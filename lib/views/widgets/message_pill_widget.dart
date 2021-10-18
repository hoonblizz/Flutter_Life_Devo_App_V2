import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_texts.dart';

Padding messagePill() {
  return Padding(
    padding: const EdgeInsets.all(13),
    child: Container(
      height: Get.height * 0.04,
      width: Get.width * 0.23,
      decoration: BoxDecoration(
          color: messagePillBG.withOpacity(0.8),
          borderRadius: BorderRadius.circular(35)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Message', style: messagePillFont),
              Icon(
                Icons.send,
                color: Colors.white,
                size: Get.height * 0.015,
              )
            ],
          ),
        ),
      ),
    ),
  );
}
