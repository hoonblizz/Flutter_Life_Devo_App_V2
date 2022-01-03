import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/landing/landing_controller.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);
  final LandingController _homeController = Get.find<LandingController>();
  final GlobalController _globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Landing Page', style: TextStyle(fontSize: 40)),
            SizedBox(
              height: 30,
            ),
            LoadingWidget(),
            // Obx(() {
            //   print(
            //       '[Landing Page] User logged in?: ${_globalController.userLoggedIn.value}');
            //   return _globalController.userLoggedIn.value
            //       ? const Center(
            //           child: Text(
            //             "Moving on to the next Page",
            //             style: TextStyle(color: Colors.black, fontSize: 26),
            //           ),
            //         )
            //       : const LoadingWidget();
            // }),
          ],
        ),
        color: Colors.white,
      ),
    );
  }
}