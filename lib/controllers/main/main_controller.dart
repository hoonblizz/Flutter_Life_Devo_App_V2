import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_comp_model.dart';
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
  final UserContentsRepository userContentRepo;
  MainController(
      {required this.authRepo,
      required this.adminContentRepo,
      required this.userContentRepo}); // : assert(repository != null);

  // 이미 main 에서 put 해줬으니 찾기만 하면 된다.
  //GlobalController gc = Get.put(GlobalController());
  GlobalController gc = Get.find();
  //final LifeDevoDetailController _lifeDevoDetailController = Get.find();

  // ignore: slash_for_doc_comments
  /******************************************************************
   * Variable collections
  ******************************************************************/
  RxBool isHomeTabLoading = false.obs;
  Rx<LifeDevoCompModel> latestLifeDevoSession = LifeDevoCompModel().obs;

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

  // ignore: slash_for_doc_comments
  /******************************************************************
   * Home Tab (1st)
  ******************************************************************/
  loadHomeTabFeatures() async {
    startHomeTabLoading();

    try {
      // Get latest life devo
      LifeDevoSessionModel _tempSession = LifeDevoSessionModel();
      Map result = await adminContentRepo.getLatestLifeDevoSession();
      gc.consoleLog('Result: ${result.toString()}');
      if (result['statusCode'] == 200) {
        _tempSession = LifeDevoSessionModel.fromJSON(result['body']);
      }

      // Get matching user life devo
      List<LifeDevoModel> myLifeDevoList = [];
      Map resultMyLifeDevo = await userContentRepo
          .getMyLifeDevo(gc.currentUser.userId, [_tempSession.id]);

      if (resultMyLifeDevo['statusCode'] == 200 &&
          resultMyLifeDevo['body'] != null) {
        List<LifeDevoModel> _tempList = [];
        for (int x = 0; x < resultMyLifeDevo['body'].length; x++) {
          _tempList.add(LifeDevoModel.fromJSON(resultMyLifeDevo['body'][x]));
        }
        myLifeDevoList = List<LifeDevoModel>.from(_tempList); // deep copy
        // 라이프 디보가 하나만 나올거라 생각.
        if (myLifeDevoList.isNotEmpty) {
          latestLifeDevoSession.value =
              LifeDevoCompModel.generate(_tempSession, myLifeDevoList[0]);
        } else {
          latestLifeDevoSession.value =
              LifeDevoCompModel.generate(_tempSession, LifeDevoModel());
        }
      } else {
        latestLifeDevoSession.value =
            LifeDevoCompModel.generate(_tempSession, LifeDevoModel());
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

  gotoLifeDevoDetail(LifeDevoCompModel lifeDevo) {
    Get.toNamed(Routes.LIFE_DEVO_DETAIL, arguments: [lifeDevo]);
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

  // ignore: slash_for_doc_comments
  /******************************************************************
   * Profile tab (5th)
  ******************************************************************/

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
  }
}
