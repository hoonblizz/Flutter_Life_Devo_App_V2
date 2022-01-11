import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_model.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_session_model.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';

const currentFileName = "main_controller";

class LifeDevoDetailController extends GetxController {
  final AuthRepository authRepo;
  //final AdminContentsRepository adminContentRepo;
  LifeDevoDetailController({
    required this.authRepo,
    //required this.adminContentRepo,
  }); // : assert(repository != null);

  GlobalController gc = Get.find();

  /******************************************************************
   * Variable collections
  ******************************************************************/
  RxBool isLoading = false.obs;
  Rx<Session> currentLifeDevoSession = Session().obs;
  Rx<LifeDevo> currentLifeDevoAnswer = LifeDevo().obs;

  final TextEditingController controllerAnswer = TextEditingController();
  final TextEditingController controllerAnswer2 = TextEditingController();
  final TextEditingController controllerAnswer3 = TextEditingController();
  final TextEditingController controllerMeditation = TextEditingController();
  /******************************************************************
   * Functions
  ******************************************************************/

  @override
  void onInit() {
    super.onInit();
  }

  resetVariables() {
    currentLifeDevoSession.value = Session();
    currentLifeDevoAnswer.value = LifeDevo();
    controllerAnswer.text = "";
    controllerAnswer2.text = "";
    controllerAnswer3.text = "";
    controllerMeditation.text = "";
  }

  setCurrentLifeDevo(Session lifeDevoSession, LifeDevo? lifeDevoAnswer) {
    currentLifeDevoSession.value = lifeDevoSession;
    if (lifeDevoAnswer != null) currentLifeDevoAnswer.value = lifeDevoAnswer;
  }

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
  }
}
