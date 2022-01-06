import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/home/home_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(authRepo: Get.find<AuthRepository>()),
    );
    Get.lazyPut<AuthRepository>(() => AuthRepository());
  }
}
