import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/views/home/components/latest_life_devo.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/home/home_controller.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatelessWidget {
  //final HomeController _homeController = Get.find<HomeController>();
  final GlobalController _globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: screenPaddingVertical,
        ),
        // Life devo title
        SizedBox(
          width: double.infinity,
          child: Text(
            'Today\'s Life Devo',
            style: TextStyle(
              fontSize: mainPageContentsTitle,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(.8),
            ),
          ),
        ),
        SizedBox(
          height: mainPageContentsSpace,
        ),

        // Life devo content
        LatestLifeDevo(),
      ],
    ));
  }
}
