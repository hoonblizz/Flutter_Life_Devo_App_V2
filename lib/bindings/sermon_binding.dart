import 'package:flutter_life_devo_app_v2/controllers/sermon/sermon_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:get/get.dart';

class SermonBinding implements Bindings {
  @override
  void dependencies() {
    // All necessary repos
    // Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<AdminContentsRepository>(() => AdminContentsRepository());

    // All necessary controllers
    Get.lazyPut<SermonController>(
      () => SermonController(
        adminContentRepo: Get.find<AdminContentsRepository>(),
      ),
    );
  }
}
