import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';
import 'package:flutter_life_devo_app_v2/models/user_token_model.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';

const currentFileName = "landing_controller";

class LandingController extends GetxController {
  final AuthRepository authRepo;
  LandingController({required this.authRepo}); // : assert(repository != null);
  GlobalController gc = Get.put(GlobalController());

  @override
  void onInit() {
    _checkUserLoggedIn();

    super.onInit();
  }

  _checkUserLoggedIn() async {
    // Get the token
    UserTokenModel userToken = await authRepo.getUserTokenFromLocal();
    gc.consoleLog(
      "Token from local: ${userToken.toJson().toString()}",
      curFileName: currentFileName,
    );

    // Save the token data into global controller
    gc.userToken = userToken;

    // Check the token (is available)
    if (gc.userToken.accessToken.isNotEmpty &&
        gc.userToken.refreshToken.isNotEmpty &&
        gc.userToken.idToken.isNotEmpty) {
      var result = await _checkTokenValid(gc.userToken);
      gc.userLoggedIn.value = result['isValid'] ?? false;
      gc.email = result['email'] ?? "";
    } else {
      gc.userLoggedIn.value = false;
    }

    if (gc.userLoggedIn.value) {
      gotoMainPage();
    } else {
      gotoAuthPage();
    }
  }

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
  }

  gotoMainPage() {
    Get.toNamed(Routes.MAIN);
  }

  _checkTokenValid(UserTokenModel userToken) async {
    if (gc.userToken.accessToken.isEmpty) return {"isValid": false};

    try {
      var result = await authRepo.checkUserTokenIsValid(userToken);
      gc.consoleLog(
        "Result from Token valid check: ${result.toString()}",
        curFileName: currentFileName,
      );

      //return result['isValid'] ?? false;
      return result['body'];
    } catch (e) {
      gc.consoleLog(
        "Error checking the token: ${e.toString()}",
        curFileName: currentFileName,
      );
    }
  }
}
