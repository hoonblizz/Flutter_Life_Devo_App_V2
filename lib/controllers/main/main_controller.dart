import 'package:flutter_life_devo_app_v2/controllers/life_devo_detail/life_devo_detail_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_model.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_session_model.dart';
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
  final LifeDevoDetailController _lifeDevoDetailController = Get.find();

  // ignore: slash_for_doc_comments
  /******************************************************************
   * Variable collections
  ******************************************************************/
  RxBool isHomeTabLoading = false.obs;
  Rx<Session> latestLifeDevoSession = Session().obs;

  // ignore: slash_for_doc_comments
  /******************************************************************
   * Functions
  ******************************************************************/

  @override
  void onInit() {
    gc.consoleLog('Init Main page controller', curFileName: currentFileName);
    loadHomeTabFeatures();

    super.onInit();
  }

  startHomeTabLoading() {
    isHomeTabLoading.value = true;
  }

  stopHomeTabLoading() {
    isHomeTabLoading.value = false;
  }

  /******************************************************************
   * Home Tab (1st)
  ******************************************************************/
  loadHomeTabFeatures() async {
    startHomeTabLoading();

    try {
      // Get latest life devo
      Map result = await adminContentRepo.getLatestLifeDevoSession();
      gc.consoleLog('Result: ${result.toString()}');
      if (result['statusCode'] == 200) {
        latestLifeDevoSession.value = Session.fromJSON(result['body']);
      }

      // Get latest sermon

      // Get latest Spiritual discipline

      // Get latest live life devo
    } catch (e) {
      gc.consoleLog('Error falls here: ${e.toString()}');
      // TODO: Do something about errors
    }

    stopHomeTabLoading();
  }

  gotoLifeDevoDetail(Session lifeDevoSession) {
    _lifeDevoDetailController.resetVariables();
    _lifeDevoDetailController.setCurrentLifeDevo(lifeDevoSession, LifeDevo());
    // Get.toNamed(Routes.LIFE_DEVO_DETAIL, arguments: [lifeDevoSession]);
    Get.toNamed(Routes.LIFE_DEVO_DETAIL);
  }

  /******************************************************************
   * Contents Tab (2nd)
  ******************************************************************/

  /******************************************************************
   * Life devo Tab (3rd)
  ******************************************************************/

  /******************************************************************
   * People tab (4th)
  ******************************************************************/

  /******************************************************************
   * Profile tab (5th)
  ******************************************************************/

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
  }
}
