import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/home/home_controller.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';

class HomePage extends StatelessWidget {
  final HomeController _homeController = Get.find<HomeController>();
  final GlobalController _globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Home page'),
      ),
    );
  }
}
