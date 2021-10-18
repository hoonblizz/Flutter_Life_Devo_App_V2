import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/auth/auth_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(authRepo: Get.find<AuthRepository>()),
    );
    Get.lazyPut<AuthRepository>(() => AuthRepository());
  }
}
