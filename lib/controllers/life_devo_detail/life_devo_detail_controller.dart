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

  Future<LifeDevo?> getLifeDevo(String skCollection) async {
    try {
      Map result = await userContentRepo.getLifeDevo(skCollection);
      gc.consoleLog('Result: ${result.toString()}',
          curFileName: currentFileName);
      if (result['statusCode'] == 200 &&
          result['body'] != null &&
          result['body']['pkCollection'] != null) {
        return LifeDevo.fromJSON(result['body']);
      }
    } catch (e) {
      gc.consoleLog('Error get life devo', curFileName: currentFileName);
    }
  }

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
  }
}
