import 'package:flutter_life_devo_app_v2/controllers/chat/chat_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/life_devo/life_devo_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/life_devo_detail/life_devo_detail_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/main/main_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/profile/profile_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/data/repository/messenger_repository.dart';
import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    // 여기서 필요한것들 넣어주고 밑에서 바로 쓴다.
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<AdminContentsRepository>(() => AdminContentsRepository());
    Get.lazyPut<UserContentsRepository>(() => UserContentsRepository());
    Get.lazyPut<MessengerRepository>(() => MessengerRepository());

    // All necessary controllers
    Get.lazyPut<MainController>(
      () => MainController(
        authRepo: Get.find<AuthRepository>(),
        adminContentRepo: Get.find<AdminContentsRepository>(),
        userContentRepo: Get.find<UserContentsRepository>(),
      ),
    );
    Get.lazyPut<LifeDevoDetailController>(
      () => LifeDevoDetailController(
        authRepo: Get.find<AuthRepository>(),
        userContentRepo: Get.find<UserContentsRepository>(),
      ),
    );
    Get.lazyPut<LifeDevoController>(
      () => LifeDevoController(
        adminContentRepo: Get.find<AdminContentsRepository>(),
        userContentRepo: Get.find<UserContentsRepository>(),
      ),
    );
    Get.lazyPut<ChatController>(
      () => ChatController(
          authRepo: Get.find<AuthRepository>(),
          userContentRepo: Get.find<UserContentsRepository>(),
          messengerRepo: Get.find<MessengerRepository>()),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        authRepo: Get.find<AuthRepository>(),
        userContentRepo: Get.find<UserContentsRepository>(),
      ),
    );
  }
}
