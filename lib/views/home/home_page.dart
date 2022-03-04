import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/main/main_controller.dart';
import 'package:flutter_life_devo_app_v2/views/home/components/latest_discipline.dart';
import 'package:flutter_life_devo_app_v2/views/home/components/latest_life_devo.dart';
import 'package:flutter_life_devo_app_v2/views/home/components/latest_live_life_devo.dart';
import 'package:flutter_life_devo_app_v2/views/home/components/latest_sermon.dart';
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
                }),

                SizedBox(
                  height: mainPageContentsSpace * 4,
                ),

                // Sermon title
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Latest Sermon',
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
                // Live Life devo content
                Obx(() {
                  if (_mainController
                      .latestSermon.value.pkCollection.isNotEmpty) {
                    return LatestSermon(_mainController.latestSermon.value);
                  }
                  return Container();
                }),

                SizedBox(
                  height: mainPageContentsSpace * 4,
                ),

                // Live Life devo title
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Latest Live Life Devo',
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
                // Live Life devo content
                Obx(() {
                  if (_mainController
                      .latestLiveLifeDevo.value.pkCollection.isNotEmpty) {
                    return LatestLiveLifeDevo(
                        _mainController.latestLiveLifeDevo.value);
                  }
                  return Container();
                }),

                SizedBox(
                  height: mainPageContentsSpace * 4,
                ),

                // Live Life devo title
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Latest Discipline',
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
                // Live Life devo content
                Obx(() {
                  if (_mainController
                      .latestDiscipline.value.pkCollection.isNotEmpty) {
                    return LatestDiscipline(
                        _mainController.latestDiscipline.value);
                  }
                  return Container();
                }),

                SizedBox(
                  height: mainPageContentsSpace * 4,
                ),
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
