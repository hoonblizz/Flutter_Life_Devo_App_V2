import 'package:flutter_life_devo_app_v2/controllers/chat/chat_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/chat_detail/chat_detail_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/life_devo/life_devo_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/life_devo_detail/life_devo_detail_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/main/main_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';

class ChatDetailBinding implements Bindings {
  @override
  void dependencies() {
    // All necessary repos
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<UserContentsRepository>(() => UserContentsRepository());

    // All necessary controllers
    Get.lazyPut<ChatDetailController>(
      () => ChatDetailController(
        authRepo: Get.find<AuthRepository>(),
        userContentRepo: Get.find<UserContentsRepository>(),
      ),
    );
  }
}
