import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_model.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_session_model.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';

const currentFileName = "life_devo_detail_controller";

class LifeDevoDetailController extends GetxController {
  final AuthRepository authRepo;
  //final AdminContentsRepository adminContentRepo;
  final UserContentsRepository userContentRepo;
  LifeDevoDetailController(
      {required this.authRepo,
      //required this.adminContentRepo,
      required this.userContentRepo}); // : assert(repository != null);

  GlobalController gc = Get.find();

  /******************************************************************
   * Variable collections
  ******************************************************************/
  RxBool isLifeDevoLoading = false.obs;
  RxBool isCommentsLoading = false.obs;

  /******************************************************************
   * Functions
  ******************************************************************/

  @override
  void onInit() {
    super.onInit();
  }

  _startLifeDevoLoading() {
    isLifeDevoLoading.value = true;
  }

  _stopLifeDevoLoading() {
    isLifeDevoLoading.value = false;
  }

  Future<LifeDevo?> onTapSaveLifeDevo(LifeDevo _lifeDevo) async {
    _startLifeDevoLoading();

    if (_lifeDevo.skCollection.isNotEmpty) {
      await updateLifeDevo(_lifeDevo);
    } else {
      LifeDevo? createdLifeDevo = await createLifeDevo(_lifeDevo);
      if (createdLifeDevo != null) {
        // 저장이 잘 안되면 null 이 리턴된다. 그럴땐 기존의 텍스트를 없애지 않도록...
        _lifeDevo = createdLifeDevo;
      }
    }

    // 끝나면 그냥 한번 더 불러주자.
    LifeDevo? returnedLifeDevo = await getUserLifeDevo(
        userId: _lifeDevo.createdBy, lifeDevoSessionId: _lifeDevo.sessionId);

    _stopLifeDevoLoading();

    return returnedLifeDevo;
  }

  Future<LifeDevo?> getUserLifeDevo(
      {required String userId, required String lifeDevoSessionId}) async {
    String _skCollection = userId + '#' + lifeDevoSessionId;
    gc.consoleLog('skCollection for getting User life devo: ${_skCollection}',
        curFileName: currentFileName);
    try {
      Map result = await userContentRepo.getLifeDevo(_skCollection);
      gc.consoleLog('Result getting User life devo: ${result.toString()}',
          curFileName: currentFileName);
      if (result['statusCode'] == 200 &&
          result['body'] != null &&
          result['body']['pkCollection'] != null) {
        return LifeDevo.fromJSON(result['body']);
      }
    } catch (e) {
      gc.consoleLog('Error get life devo: ${e.toString()}',
          curFileName: currentFileName);
    }
  }

  Future<LifeDevo?> createLifeDevo(LifeDevo _lifeDevo) async {
    try {
      Map result = await userContentRepo.createLifeDevo(_lifeDevo);
      gc.consoleLog('Result: ${result.toString()}',
          curFileName: currentFileName);
      if (result['statusCode'] == 200 && result['body'] != null) {
        return LifeDevo.fromJSON(result['body']);
      }
    } catch (e) {
      gc.consoleLog('Error creating life devo', curFileName: currentFileName);
    }
  }

  Future updateLifeDevo(LifeDevo _lifeDevo) async {
    try {
      Map result = await userContentRepo.updateLifeDevo(_lifeDevo);
      gc.consoleLog('Result: ${result.toString()}',
          curFileName: currentFileName);
    } catch (e) {
      gc.consoleLog('Error updating life devo', curFileName: currentFileName);
    }
  }

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
  }
}
