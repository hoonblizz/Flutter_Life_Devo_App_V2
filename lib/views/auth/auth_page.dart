import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/auth/auth_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle submitButtonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Loading
          Obx(() {
            return _authController.isLoading.value
                ? const LoadingWidget()
                : Container();
          }),
          Container(
            alignment: Alignment.center,
            child: const Text(
              "Login Page",
              style: TextStyle(color: Colors.black, fontSize: 32),
            ),
            color: Colors.white24,
          ),
          TextField(
            controller: _authController.inputCtrUsername,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your username',
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextField(
            controller: _authController.inputCtrPassword,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your password',
            ),
          ),
          ElevatedButton(
            style: submitButtonStyle,
            onPressed: _authController.login,
            child: const Text('Login'),
          ),
          const SizedBox(
            height: 50,
          ),
          InkWell(
            child: const Text(
              'Signup',
              style: TextStyle(fontSize: 28),
            ),
            onTap: _authController.gotoSignupPage,
          ),
        ],
      ),
    );
  }
}
