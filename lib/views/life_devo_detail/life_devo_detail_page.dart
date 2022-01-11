import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/life_devo_detail/life_devo_detail_controller.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_session_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:flutter_life_devo_app_v2/views/helper/keyboard.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LifeDevoDetailPage extends StatelessWidget {
  LifeDevoDetailPage({Key? key}) : super(key: key);
  // 이제 parameter 로 가져오지 말고, 해당 컨트롤러에서 찾자.
  //final Session _lifeDevoSession = Get.arguments[0];
  final LifeDevoDetailController _lifeDevoDetailController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navBG,
      appBar: _customAppBar(),
      body: Container(
        color: navBG,
        child: SafeArea(
          child: Stack(
            children: [
              if (_lifeDevoDetailController
                  .currentLifeDevoSession.value.skCollection.isEmpty)
                const Center(
                  child: Text('Session data not found.'),
                ),
              if (_lifeDevoDetailController
                  .currentLifeDevoSession.value.skCollection.isNotEmpty)
                GestureDetector(
                  onTap: () => KeyboardUtil.hideKeyboard(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenPaddingHorizontal,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenPaddingVertical,
                          ),
                          // Date Time
                          Text(
                            DateFormat.yMMMMEEEEd().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    _lifeDevoDetailController
                                        .currentLifeDevoSession
                                        .value
                                        .startDateEpoch)),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: adminContentDetailDesc),
                          ),

                          // Title
                          Text(
                            _lifeDevoDetailController
                                .currentLifeDevoSession.value.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: adminContentDetailTitle),
                          ),

                          // 타이틀 다음이라 조금 더 공간을 둔다
                          SizedBox(
                            height: adminContentDetailSpace * 2,
                          ),

                          // Contents
                          Text(
                            _lifeDevoDetailController
                                .currentLifeDevoSession.value.scripture,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: adminContentDetailDesc),
                          ),

                          const Divider(
                            color: Colors.black,
                          ),

                          SizedBox(
                            height: adminContentDetailSpace,
                          ),

                          // Question title
                          Text(
                            'Meditate',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: adminContentDetailDesc,
                            ),
                          ),

                          SizedBox(
                            height: adminContentDetailSpace,
                          ),

                          // Questions & answers
                          if (_lifeDevoDetailController
                              .currentLifeDevoSession.value.question.isNotEmpty)
                            _questionComponent(
                                _lifeDevoDetailController
                                    .currentLifeDevoSession.value.question,
                                _lifeDevoDetailController.controllerAnswer),

                          if (_lifeDevoDetailController.currentLifeDevoSession
                              .value.question2.isNotEmpty)
                            _questionComponent(
                                _lifeDevoDetailController
                                    .currentLifeDevoSession.value.question2,
                                _lifeDevoDetailController.controllerAnswer2),

                          if (_lifeDevoDetailController.currentLifeDevoSession
                              .value.question2.isNotEmpty)
                            _questionComponent(
                                _lifeDevoDetailController
                                    .currentLifeDevoSession.value.question3,
                                _lifeDevoDetailController.controllerAnswer3),

                          // Meditate (only textfield): 유저 메모 같은거

                          // 코멘트
                          const Divider(
                            color: Colors.black,
                          ),

                          SizedBox(
                            height: adminContentDetailSpace,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _customAppBar() {
    return AppBar(
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
    );
  }

  _questionComponent(String question, TextEditingController controllerInput) {
    return Column(
      children: [
        Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: adminContentDetailDesc,
          ),
        ),
        SizedBox(
          height: adminContentDetailSpace,
        ),
        TextFormField(
          controller: controllerInput,
          minLines: 5,
          maxLines: 5,
          expands: false,
          keyboardType: TextInputType.multiline,
          autofocus: false,
          decoration: InputDecoration(
              //labelText: 'Type something...',
              //labelStyle: ,
              hintText: 'Type something...',
              filled: true,
              fillColor: textFieldBackground,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              // focusedBorder: const OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white),
              //   //borderRadius: BorderRadius.circular(25.7),
              // ),
              // enabledBorder: const UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white),
              //   //borderRadius: BorderRadius.circular(25.7),
              // ),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none),

          //onSaved: (value) => _searchText = value.trim(),
        ),
        SizedBox(
          height: adminContentDetailSpace,
        ),
      ],
    );
  }
}
