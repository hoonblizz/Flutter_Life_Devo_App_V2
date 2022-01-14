import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/life_devo_detail/life_devo_detail_controller.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_model.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_session_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:flutter_life_devo_app_v2/views/auth/components/default_button.dart';
import 'package:flutter_life_devo_app_v2/views/helper/keyboard.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/custom_app_bar.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LifeDevoDetailPage extends StatefulWidget {
  const LifeDevoDetailPage({Key? key}) : super(key: key);

  @override
  State<LifeDevoDetailPage> createState() => _LifeDevoDetailPageState();
}

class _LifeDevoDetailPageState extends State<LifeDevoDetailPage> {
  final LifeDevoDetailController _lifeDevoDetailController = Get.find();
  final GlobalController _globalController = Get.find();
  final Session _curLifeDevoSession = Get.arguments[0];
  LifeDevo _curLifeDevo = LifeDevo();

  final TextEditingController _controllerAnswer = TextEditingController();
  final TextEditingController _controllerAnswer2 = TextEditingController();
  final TextEditingController _controllerAnswer3 = TextEditingController();
  final TextEditingController _controllerMeditation = TextEditingController();

  @override
  void initState() {
    // 유저 answer 가 있는지, 있으면 가져오기
    getUserLifeDevo(
        userId: _globalController.currentUser.userId,
        lifeDevoSessionId: _curLifeDevoSession.id);

    // 해당 life devo 의 코멘트 가져오기

    super.initState();
  }

  mergeData() {
    // Life devo 의 id 넣기
    _curLifeDevo.sessionId = _curLifeDevoSession.id;

    // Life devo 에 현재 유저 정보 넣기
    _curLifeDevo.createdBy = _globalController.currentUser.userId;
  }

  getUserLifeDevo(
      {required String userId, required String lifeDevoSessionId}) async {
    LifeDevo? _lifeDevo = await _lifeDevoDetailController.getUserLifeDevo(
      userId: userId,
      lifeDevoSessionId: lifeDevoSessionId,
    );

    if (_lifeDevo != null) {
      setState(() {
        _curLifeDevo = _lifeDevo;
        _controllerAnswer.text = _curLifeDevo.answer;
        _controllerAnswer2.text = _curLifeDevo.answer2;
        _controllerAnswer3.text = _curLifeDevo.answer3;
        _controllerMeditation.text = _curLifeDevo.meditation;
      });
    }

    mergeData();
  }

  // 기존에 _curLifeDevo 의 존재유무에 따라 create 인지, update 인지 나뉜다.
  onTapSaveLifeDevo() async {
    print('Save!');

    // 텍스트 컨트롤러에 있던 정보 옮기기
    _pasteDataToModel();

    LifeDevo? _returnedLifeDevo =
        await _lifeDevoDetailController.onTapSaveLifeDevo(_curLifeDevo);
    if (_returnedLifeDevo != null) {
      _curLifeDevo = _returnedLifeDevo;
    }
  }

  _pasteDataToModel() {
    mergeData();
    _curLifeDevo.answer = _controllerAnswer.text;
    _curLifeDevo.answer2 = _controllerAnswer2.text;
    _curLifeDevo.answer3 = _controllerAnswer3.text;
    _curLifeDevo.meditation = _controllerMeditation.text;
  }

  @override
  void dispose() {
    _controllerAnswer.dispose();
    _controllerAnswer2.dispose();
    _controllerAnswer3.dispose();
    _controllerMeditation.dispose();
    super.dispose();
  }

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
              if (_curLifeDevoSession.skCollection.isEmpty)
                const Center(
                  child: Text('Session data not found.'),
                ),
              if (_curLifeDevoSession.skCollection.isNotEmpty)
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
                                    _curLifeDevoSession.startDateEpoch)),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: adminContentDetailDesc),
                          ),

                          // Title
                          Text(
                            _curLifeDevoSession.title,
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
                            _curLifeDevoSession.scripture,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: adminContentDetailDesc),
                          ),

                          const Divider(
                            color: kPrimaryColor,
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
                          if (_curLifeDevoSession.question.isNotEmpty)
                            _questionComponent(_curLifeDevoSession.question,
                                _controllerAnswer),

                          if (_curLifeDevoSession.question2.isNotEmpty)
                            _questionComponent(_curLifeDevoSession.question2,
                                _controllerAnswer2),

                          if (_curLifeDevoSession.question2.isNotEmpty)
                            _questionComponent(_curLifeDevoSession.question3,
                                _controllerAnswer3),

                          SizedBox(
                            height: adminContentDetailSpace,
                          ),

                          // Meditate (only textfield): 유저 메모 같은거
                          // const Divider(
                          //   color: kPrimaryColor,
                          // ),

                          _meditationComponent(_controllerMeditation),

                          // Save button
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  //width: double.infinity,
                                  //height: 33,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      primary: Colors.white,
                                      backgroundColor: kPrimaryColor,
                                    ),
                                    onPressed: () => onTapSaveLifeDevo(),
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: adminContentDetailDesc,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: SizedBox(
                                  //width: double.infinity,
                                  //height: 33,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      primary: Colors.white,
                                      backgroundColor: kPrimaryColor,
                                    ),
                                    onPressed: () => {},
                                    child: Text(
                                      'Share',
                                      style: TextStyle(
                                        fontSize: adminContentDetailDesc,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          // 코멘트
                          const Divider(
                            color: kPrimaryColor,
                          ),

                          SizedBox(
                            height: adminContentDetailSpace,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Loading
              Obx(() {
                return _lifeDevoDetailController.isLifeDevoLoading.value
                    ? const LoadingWidget()
                    : Container();
              })
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
      mainAxisSize: MainAxisSize.min,
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
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Answer',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: adminContentDetailDesc,
            ),
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

  _meditationComponent(TextEditingController controllerInput) {
    return Column(
      children: [
        SizedBox(
          height: adminContentDetailSpace,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Meditation',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: adminContentDetailDesc,
            ),
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
              hintText: 'Type something...',
              filled: true,
              fillColor: textFieldBackground,
              floatingLabelBehavior: FloatingLabelBehavior.never,
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
