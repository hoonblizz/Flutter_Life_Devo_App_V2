import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/landing/landing_controller.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);
  // 여기서 find 해주면 onInit 이 발생. 쓸데는 없을지라도 일단 두자.
  final LandingController _landingController = Get.find<LandingController>();
  final GlobalController _globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: const [
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
