import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_session_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class LifeDevoDetailPage extends StatelessWidget {
  LifeDevoDetailPage({Key? key}) : super(key: key);
  final Session _lifeDevoSession = Get.arguments[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navBG,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(bottom: 4), // 오묘하게 센터가 안맞아서 그냥 넣어줌
          child: const Text(
            'Life Devo Detail',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        color: navBG,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenPaddingHorizontal,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: screenPaddingVertical,
                  ),
                  Text('Life devo: ${_lifeDevoSession.title}')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customAppBar() {
    return Container(
      child: Text('Life devo detail'),
    );
  }
}
