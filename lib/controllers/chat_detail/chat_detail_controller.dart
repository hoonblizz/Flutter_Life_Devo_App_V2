import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';

const String currentFileName = "Chat_Detail_Controller";

class ChatDetailController extends GetxController {
  final AuthRepository authRepo;
  final UserContentsRepository userContentRepo;
  ChatDetailController({required this.authRepo, required this.userContentRepo});

  // 이미 main 에서 put 해줬으니 찾기만 하면 된다.
  //GlobalController gc = Get.put(GlobalController());
  GlobalController gc = Get.find();

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
  }

  // @override
  // void onInit() {
  //   gc.consoleLog(
  //     "Init Chat page controller",
  //     curFileName: currentFileName,
  //   );
  //   super.onInit();
  // }
}
