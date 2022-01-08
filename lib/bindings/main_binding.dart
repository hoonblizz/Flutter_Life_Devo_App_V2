import 'package:flutter_life_devo_app_v2/controllers/home/home_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/main/main_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    // All necessary repos
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<AdminContentsRepository>(() => AdminContentsRepository());

    // All necessary controllers
    Get.lazyPut<MainController>(
      () => MainController(
          authRepo: Get.find<AuthRepository>(),
          adminContentRepo: Get.find<AdminContentsRepository>()),
    );
    // Get.lazyPut<HomeController>(
    //   () => HomeController(authRepo: Get.find<AuthRepository>()),
    // );
  }
}
