import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/views/auth/components/auth_form.dart';
import 'package:flutter_life_devo_app_v2/views/helper/keyboard.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/auth/auth_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
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
                    SizedBox(height: Get.height * 0.08),
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
                    //NoAccountText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
