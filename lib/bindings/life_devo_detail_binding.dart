import 'package:flutter_life_devo_app_v2/controllers/home/home_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/life_devo_detail/life_devo_detail_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/main/main_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';

class LifeDevoDetailBinding implements Bindings {
  @override
  void dependencies() {
    // All necessary repos
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<AdminContentsRepository>(() => AdminContentsRepository());

    // All necessary controllers
    Get.lazyPut<LifeDevoDetailController>(
      () => LifeDevoDetailController(authRepo: Get.find<AuthRepository>()),
    );
  }
}
