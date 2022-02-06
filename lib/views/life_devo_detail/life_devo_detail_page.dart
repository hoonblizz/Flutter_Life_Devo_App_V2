import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/life_devo_detail/life_devo_detail_controller.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_comp_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:flutter_life_devo_app_v2/views/helper/keyboard.dart';
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
  final LifeDevoCompModel _curLifeDevoSession = Get.arguments[0];

  final TextEditingController _controllerAnswer = TextEditingController();
  final TextEditingController _controllerAnswer2 = TextEditingController();
  final TextEditingController _controllerAnswer3 = TextEditingController();
  final TextEditingController _controllerMeditation = TextEditingController();

  bool isLoading = false;
  bool isMyLifeDevo = false;

  @override
  void initState() {
    // 유저 answer 가 있는지, 있으면 가져오기
    // 2022.02.04 - Composite model 로 따로 가져올 필요 없게끔.
    // getUserLifeDevo(
    //     userId: _globalController.currentUser.userId,
    //     lifeDevoSessionId: _curLifeDevoSession.id);
    setData();
    // 해당 life devo 의 코멘트 가져오기

    super.initState();
  }

  setData() {
    setState(() {
      _controllerAnswer.text = _curLifeDevoSession.answer;
      _controllerAnswer2.text = _curLifeDevoSession.answer2;
      _controllerAnswer3.text = _curLifeDevoSession.answer3;
      _controllerMeditation.text = _curLifeDevoSession.meditation;

      // 새 라잎 디보일때 ||
      // 전에 있던 라잎 디보를 불러왔을때
      if (_curLifeDevoSession.skCollectionLifeDevo.isEmpty ||
          (_curLifeDevoSession.skCollectionLifeDevo.isNotEmpty &&
              _curLifeDevoSession.createdBy ==
                  _globalController.currentUser.userId)) {
        debugPrint(
            'Created by ${_curLifeDevoSession.createdBy} and accessed by ${_globalController.currentUser.userId}');

        isMyLifeDevo = true;
      }
    });
  }

  mergeData() {
    // Life devo 의 id 넣기
    _curLifeDevoSession.sessionId = _curLifeDevoSession.id;

    // Life devo 에 현재 유저 정보 넣기
    _curLifeDevoSession.createdBy = _globalController.currentUser.userId;
  }

  // 기존에 _curLifeDevo 의 존재유무에 따라 create 인지, update 인지 나뉜다.
  onTapSaveLifeDevo() async {
    debugPrint('Save!');

    // 텍스트 컨트롤러에 있던 정보 옮기기
    _pasteDataToModel();

    await _lifeDevoDetailController.onTapSaveLifeDevo(
        LifeDevoCompModel().toLifeDevoModel(_curLifeDevoSession));
  }

  _pasteDataToModel() {
    mergeData();
    _curLifeDevoSession.answer = _controllerAnswer.text;
    _curLifeDevoSession.answer2 = _controllerAnswer2.text;
    _curLifeDevoSession.answer3 = _controllerAnswer3.text;
    _curLifeDevoSession.meditation = _controllerMeditation.text;
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
              if (_curLifeDevoSession.skCollectionSession.isEmpty)
                const Center(
                  child: Text('Session data not found.'),
                ),
              if (_curLifeDevoSession.skCollectionSession.isNotEmpty)
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
                          if (!isLoading &&
                              _curLifeDevoSession.question.isNotEmpty)
                            _questionComponent(_curLifeDevoSession.question,
                                _controllerAnswer, isMyLifeDevo),

                          if (!isLoading &&
                              _curLifeDevoSession.question2.isNotEmpty)
                            _questionComponent(_curLifeDevoSession.question2,
                                _controllerAnswer2, isMyLifeDevo),

                          if (!isLoading &&
                              _curLifeDevoSession.question2.isNotEmpty)
                            _questionComponent(_curLifeDevoSession.question3,
                                _controllerAnswer3, isMyLifeDevo),

                          SizedBox(
                            height: adminContentDetailSpace,
                          ),

                          // Meditate (only textfield): 유저 메모 같은거
                          // const Divider(
                          //   color: kPrimaryColor,
                          // ),
                          if (!isLoading)
                            _meditationComponent(
                                _controllerMeditation, isMyLifeDevo),

                          // Save button
                          if (isMyLifeDevo)
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

  _questionComponent(String question, TextEditingController controllerInput,
      bool isMyLifeDevo) {
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
          readOnly: !isMyLifeDevo,
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
        ),
        SizedBox(
          height: adminContentDetailSpace,
        ),
      ],
    );
  }

  _meditationComponent(
      TextEditingController controllerInput, bool isMyLifeDevo) {
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
          readOnly: !isMyLifeDevo,
          keyboardType: TextInputType.multiline,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Type something...',
              filled: true,
              fillColor: textFieldBackground,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none),
        ),
        SizedBox(
          height: adminContentDetailSpace,
        ),
      ],
    );
  }
}
