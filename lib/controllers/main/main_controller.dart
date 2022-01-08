import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';

const currentFileName = "main_controller";

class MainController extends GetxController {
  final AuthRepository authRepo;
  final AdminContentsRepository adminContentRepo;
  MainController({
    required this.authRepo,
    required this.adminContentRepo,
  }); // : assert(repository != null);

  // 이미 main 에서 put 해줬으니 찾기만 하면 된다.
  //GlobalController gc = Get.put(GlobalController());
  GlobalController gc = Get.find();

  @override
  void onInit() {
    gc.consoleLog('Init Main page controller', curFileName: currentFileName);
    getLatestFeatures();

    super.onInit();
  }

  // TODO: Call latest contents (life devo, sermon, spiritual discipline, live life devo, etc...)
  // Then store into global controller
  getLatestFeatures() async {
    // Get latest life devo

    // Get latest sermon

    // Get latest Spiritual discipline

    // Get latest live life devo
  }

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
  }
}
