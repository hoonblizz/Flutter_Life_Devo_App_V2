import 'dart:convert';
import 'package:flutter/material.dart';
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
  GlobalController gc = Get.put(GlobalController());

  TextEditingController inputCtrUsername = TextEditingController(text: "");
  TextEditingController inputCtrPassword = TextEditingController(text: "");

  var isLoading = false.obs;

  login() async {
    if (inputCtrUsername.text.isNotEmpty && inputCtrPassword.text.isNotEmpty) {
      // Start loading
      isLoading.value = true;

      // Request
      var result =
          await authRepo.login(inputCtrUsername.text, inputCtrPassword.text);

      // clear
      inputCtrPassword.clear();

      if (result["statusCode"] == 200) {
        // Access to AuthenticationResult
        var resultBodyString = result["body"].toString();
        var parsedBody = jsonDecode(resultBodyString) as Map<String, dynamic>;
        var parsedAuthenticationResult =
            parsedBody["result"]["AuthenticationResult"];

        gc.consoleLog(
          'Auth data: $parsedAuthenticationResult',
          curFileName: currentFileName,
        );

        // Add username (Not included in AuthenticationResult)
        // Then wrap it as a complete token
        var username = parsedBody['input']['username'] ?? "";
        parsedAuthenticationResult['username'] = username;
        gc.userToken = UserTokenModel.fromJson(parsedAuthenticationResult);
        gc.username = username;

        // Save the token in local
        var saveDone = await authRepo.setUserTokenToLocal(gc.userToken);
        gc.consoleLog(
          'Save data in local done: $saveDone',
          curFileName: currentFileName,
        );

        // Stop loading
        isLoading.value = false;

        // Now time to go home
        // gotoHomePage();
        gotoPetTypePage();
      } else {
        // Stop loading
        isLoading.value = false;

        // TODO: Error handling - User input error (Wrong username or password)
        gc.consoleLog(
          'Maybe wrong username or password',
          curFileName: currentFileName,
        );
      }
    } else {
      gc.consoleLog(
        'Input empty. Must warn',
        curFileName: currentFileName,
      );
    }
  }

  gotoSignupPage() async {
    await canLaunch(urlSignup)
        ? await launch(urlSignup)
        : throw 'Could not launch $urlSignup';
  }

  gotoHomePage() {
    Get.toNamed(Routes.HOME);
  }

  gotoPetTypePage() {
    Get.toNamed(Routes.PETTYPE);
  }
}
