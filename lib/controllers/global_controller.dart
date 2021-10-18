/*
  This controller may include data that must be shared globally.
  Also UI controllers may include this controller
*/
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/models/user_token_model.dart';

class GlobalController extends GetxController {
  // final _sampleList = <SampleModel>[].obs;
  // get sampleList => _sampleList;
  // set sampleList(value) => _sampleList.value = value;

  /// ========================================================
  ///     Util
  /// ========================================================
  consoleLog(message, {String curFileName = "UNDEFINED"}) {
    // ignore: avoid_print
    print("[$curFileName] $message");
  }

  /// ========================================================
  ///     Auth
  /// ========================================================
  ///
  String username = "";
  var userLoggedIn = false.obs;
  UserTokenModel userToken = UserTokenModel(); // Empty model

  /// ========================================================
  ///     User
  /// ========================================================

  @override
  void onInit() {
    super.onInit();
  }
}
