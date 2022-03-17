import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/views/auth/components/auth_form.dart';
import 'package:flutter_life_devo_app_v2/views/auth/components/auth_in_app_browser.dart';
import 'package:flutter_life_devo_app_v2/views/helper/keyboard.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/auth/auth_controller.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';

// ignore: must_be_immutable
class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);
  final AuthInAppBrowser browser = AuthInAppBrowser();
  final AuthController _authController = Get.find<AuthController>();

  // In app browser option
  var options = InAppBrowserClassOptions(
    crossPlatform: InAppBrowserOptions(
        hideUrlBar: true,
        hideToolbarTop: false,
        toolbarTopBackgroundColor: kPrimaryColor),
    android: AndroidInAppBrowserOptions(
        allowGoBackWithBackButton: false, shouldCloseOnBackButtonPressed: true),
    ios: IOSInAppBrowserOptions(hideToolbarBottom: true),
    inAppWebViewGroupOptions: InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => KeyboardUtil.hideKeyboard(context),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: Get.height * 0.05),
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Sign in with your email and password  \nor continue with social media",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: Get.height * 0.08),
                          const AuthForm(),
                          //SizedBox(height: Get.height * 0.08),
                          // Later, if we support other login types, add them
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     SocalCard(
                          //       icon: "assets/icons/google-icon.svg",
                          //       press: () {},
                          //     ),
                          //     SocalCard(
                          //       icon: "assets/icons/facebook-2.svg",
                          //       press: () {},
                          //     ),
                          //     SocalCard(
                          //       icon: "assets/icons/twitter.svg",
                          //       press: () {},
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 20),
                          // No Account ?
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Don\'t have an account? ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: 'Sign up here',
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        browser.openUrlRequest(
                                            urlRequest: URLRequest(
                                                url: Uri.parse(
                                                    "https://login.bclifedevo.com/login?client_id=h2kvrkab13qh27159t7rvs8u8&response_type=code&scope=email+openid+profile&redirect_uri=https://bclifedevo.com")),
                                            options: options);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Loading
              Obx(() {
                return _authController.isLoading.value
                    ? const LoadingWidget()
                    : Container();
              })
            ],
          ),
        ),
      ),
    );
  }
}
