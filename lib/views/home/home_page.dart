import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/main/main_controller.dart';
import 'package:flutter_life_devo_app_v2/views/home/components/latest_life_devo.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';
import 'package:get/get.dart';

import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatelessWidget {
  //final HomeController _homeController = Get.find<HomeController>();
  //final GlobalController _globalController = Get.find<GlobalController>();
  final MainController _mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenPaddingHorizontal,
          ),
          child: SingleChildScrollView(
            //physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Obx(() {
                  if (_mainController.latestLifeDevoSession.value
                      .pkCollectionSession.isNotEmpty) {
                    return LatestLifeDevo(
                      _mainController.latestLifeDevoSession.value,
                    );
                  }
                  return Container();
                })
              ],
            ),
          ),
        ),
        Obx(() {
          return _mainController.isHomeTabLoading.value
              ? const LoadingWidget()
              : Container();
        })
      ],
    );
  }
}
