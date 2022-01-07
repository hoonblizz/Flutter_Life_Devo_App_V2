/*
  Put all necessary repo and controller
*/
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/landing/landing_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';

class LandingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<LandingController>(
      () => LandingController(authRepo: Get.find<AuthRepository>()),
    );
  }
}
