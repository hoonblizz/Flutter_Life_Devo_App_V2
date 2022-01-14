// import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/models/user_model.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';
import 'package:flutter_life_devo_app_v2/models/user_token_model.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';

import 'package:url_launcher/url_launcher.dart';

const currentFileName = "auth_controller";
const urlSignup = "https://login.petobe.ca/signup";

class AuthController extends GetxController {
  final AuthRepository authRepo;
  AuthController({required this.authRepo}); // : assert(repository != null);

  //GlobalController gc = Get.put(GlobalController());
  GlobalController gc = Get.find();

  var isLoading = false.obs;

  login(email, password) async {
    // Start loading
    isLoading.value = true;

    // Request
    try {
      var result = await authRepo.login(email, password);

      if (result["statusCode"] == 200) {
        gc.consoleLog(
            'Access Token: ${result["body"]["AuthenticationResult"]}');

        // Add username and create model
        Map<String, dynamic> authResult =
            result["body"]["AuthenticationResult"];

        gc.userToken = UserTokenModel.fromJson(authResult);

        // Save the token in local
        var saveDone = await authRepo.setUserTokenToLocal(gc.userToken);
        gc.consoleLog(
          'Save data in local done: $saveDone',
          curFileName: currentFileName,
        );

        // 토큰을 token validation 에 넣어서 systemId 를 얻은 다음, 그걸로 user 정보 불러오기
        // -> Landing controller 에도 같은 로직이 쓰인다.
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
              }
            } catch (e) {
              gc.consoleLog(
                  'Error getting user data by system id: ${e.toString()}',
                  curFileName: currentFileName);
              gc.userLoggedIn.value = false;
            }
          }
        } else {
          gc.userLoggedIn.value = false;
        }

        // Stop loading
        isLoading.value = false;

        // Now time to go home
        if (gc.userLoggedIn.value) {
          gotoMainPage();
        } else {
          gc.consoleLog('Failed to get user auth or data',
              curFileName: currentFileName);
        }
      } else {
        // Stop loading
        isLoading.value = false;

        // TODO: Error handling - User input error (Wrong username or password)
        gc.consoleLog(
          'Maybe wrong username or password',
          curFileName: currentFileName,
        );
      }
    } catch (e) {
      isLoading.value = false;
      gc.consoleLog(
        e.toString(),
        curFileName: currentFileName,
      );
    }
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

  gotoSignupPage() async {
    await canLaunch(urlSignup)
        ? await launch(urlSignup)
        : throw 'Could not launch $urlSignup';
  }

  gotoMainPage() {
    Get.toNamed(Routes.MAIN);
  }
}
