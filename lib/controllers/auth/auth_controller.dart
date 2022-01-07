// import 'dart:convert';
// import 'package:flutter/material.dart';
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
        authResult['username'] = email;

        gc.userToken = UserTokenModel.fromJson(authResult);
        gc.email = email;

        // Save the token in local
        var saveDone = await authRepo.setUserTokenToLocal(gc.userToken);
        gc.consoleLog(
          'Save data in local done: $saveDone',
          curFileName: currentFileName,
        );

        // Stop loading
        isLoading.value = false;

        // Now time to go home
        gotoMainPage();
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

  gotoSignupPage() async {
    await canLaunch(urlSignup)
        ? await launch(urlSignup)
        : throw 'Could not launch $urlSignup';
  }

  gotoMainPage() {
    Get.toNamed(Routes.MAIN);
  }
}
