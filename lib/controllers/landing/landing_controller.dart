import 'package:flutter_life_devo_app_v2/models/user_model.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';
import 'package:flutter_life_devo_app_v2/models/user_token_model.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';

const currentFileName = "landing_controller";

class LandingController extends GetxController {
  final AuthRepository authRepo;
  LandingController({required this.authRepo}); // : assert(repository != null);

  // 이미 main 에서 put 해줬으니 찾기만 하면 된다.
  //GlobalController gc = Get.put(GlobalController());
  GlobalController gc = Get.find();

  @override
  void onInit() {
    /*
      어디에서든 Get.find 든 뭐든 이 컨트롤러에 엑세스만 하면 init이 발동. 
      현재는 해당 page (여기서는 landing page) 에서 Get.find 해줄시에 발생한다.
    */
    gc.consoleLog(
      "Init Landing page controller",
      curFileName: currentFileName,
    );
    _checkUserLoggedIn();

    super.onInit();
  }

  _checkUserLoggedIn() async {
    // Get the token
    UserTokenModel userToken = await authRepo.getUserTokenFromLocal();
    // gc.consoleLog(
    //   "Token from local: ${userToken.toJson().toString()}",
    //   curFileName: currentFileName,
    // );

    // Save the token data into global controller
    gc.userToken = userToken;

    // Check the token (is available)
    if (gc.userToken.accessToken.isNotEmpty &&
        gc.userToken.refreshToken.isNotEmpty &&
        gc.userToken.idToken.isNotEmpty) {
      var result = await _checkTokenValid(gc.userToken);
      gc.userLoggedIn.value = result['isValid'] ?? false;
      gc.userSystemId = result['systemId'] ?? "";

      // valid 하면, System id 를 토대로 유저 정보 가져오기
      if (gc.userLoggedIn.value) {
        try {
          Map resultUserData =
              await authRepo.getUserDataBySystemId(gc.userSystemId);
          gc.consoleLog('Result user data: ${resultUserData.toString()}',
              curFileName: currentFileName);

          if (resultUserData['statusCode'] == 200) {
            gc.currentUser = User.fromJSON(resultUserData['body']);
          } else {
            gc.userLoggedIn.value = false;
          }
        } catch (e) {
          gc.consoleLog('Error getting user data by system id: ${e.toString()}',
              curFileName: currentFileName);
          gc.userLoggedIn.value = false;
        }
      }
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
