import 'package:flutter_life_devo_app_v2/controllers/live_life_devo/live_life_devo_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:get/get.dart';

class LiveLifeDevoBinding implements Bindings {
  @override
  void dependencies() {
    // All necessary repos
    // Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<AdminContentsRepository>(() => AdminContentsRepository());

    // All necessary controllers
    Get.lazyPut<LiveLifeDevoController>(
      () => LiveLifeDevoController(
        adminContentRepo: Get.find<AdminContentsRepository>(),
      ),
    );
  }
}
