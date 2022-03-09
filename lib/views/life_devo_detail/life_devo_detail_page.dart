//import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/life_devo_detail/life_devo_detail_controller.dart';
import 'package:flutter_life_devo_app_v2/models/comment_model.dart';
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

  final _scrollController = ScrollController();

  final TextEditingController _controllerAnswer = TextEditingController();
  final TextEditingController _controllerAnswer2 = TextEditingController();
  final TextEditingController _controllerAnswer3 = TextEditingController();
  final TextEditingController _controllerMeditation = TextEditingController();
  final TextEditingController _controllerComment = TextEditingController();

  bool isLoading = false;
  bool isGetCommentLoading = false;
  bool isCommentLoading = false;
  bool isMyLifeDevo = false;
  List<List<CommentModel>> commentList = []; // 2d array -> new to old
  List<CommentModel> commentListMerged = []; // Flattened
  List<Map> lastEvaluatedKeyList = []; // 여기에 키값들 저장.
  // Map lastEvaluatedKey = {};
  // Map lastEvaluatedKeyPrev = {}; // Previous key

  @override
  void initState() {
    // 기존 데이터 (존재하면)와 widget 들 합치기 (텍스트 컨트롤러 등등)
    setData();
    // 해당 life devo 의 코멘트 가져오기
    getComments();

    scrollListener();

    super.initState();
  }

  scrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          debugPrint('Scroll at the top');
        } else {
          debugPrint('Scroll at the bottom');
          getComments();
          // 코멘트 로딩을 보여주려면 좀더 내려가야함. -> 근데 이거 하면 bottom 에 한번 더 도달해서 코멘트를 두번 부르게 된다.
          //_scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  getComments() async {
    // 이미 로딩중이면 부르지 말자.
    if (isGetCommentLoading) {
      return;
    }

    setState(() {
      isGetCommentLoading = true;
    });

    // 바로 직전의 api 에서 나온 키가 있으면 그걸 쓰고, 아니면 그 전 키를 사용.
    // 예를들어, 리스트 쭉 부르다가 맨 끝에 도달한 경우, 키 값은 비게 된다.
    // 그 상태에서 리스트를 한번 더 부를때, 빈 키로 부르면 안된다.
    Map keyToBeUsed = lastEvaluatedKeyList.isNotEmpty
        ? lastEvaluatedKeyList[lastEvaluatedKeyList.length - 1]
        : {};

    List<CommentModel> _tempList = [];

    await Future.delayed(const Duration(seconds: 1));
    Map result = await _lifeDevoDetailController.getComments(
        _curLifeDevoSession.id, keyToBeUsed);

    //debugPrint('Result ${result.toString()}');

    if (result["statusCode"] != null && result["statusCode"] == 200) {
      if (result["body"] != null) {
        for (var x = 0; x < result["body"].length; x++) {
          _tempList.add(CommentModel.fromJSON(result["body"][x]));
        }
      }

      if (result["resultExclusiveStartKey"] != null) {
        // 만약 키가 있었으면 백업
        Map lastEvaluatedKey = result["resultExclusiveStartKey"];

        // ignore: iterable_contains_unrelated_type
        if (!lastEvaluatedKeyList
            .contains((Map el) => mapEquals(el, lastEvaluatedKey))) {
          debugPrint('Last Eval not exist. Adding one...');
          lastEvaluatedKeyList.add(lastEvaluatedKey);
        }

        //debugPrint('Pagination key: ${lastEvaluatedKeyList.toString()}');
      }

      // user id 로 user data 구하기. username 코멘트에 등록.
      if (_tempList.isNotEmpty) {
        List<String> _userIdList =
            _tempList.map((e) => e.userId).toSet().toList(); // toSet 으로 중복 없애줌.
        try {
          Map result =
              await _lifeDevoDetailController.searchUserByUserId(_userIdList);
          //debugPrint('Result getting user data: ${result.toString()}');

          if (result['statusCode'] == 200 && result['body'] != null) {
            for (var x = 0; x < _tempList.length; x++) {
              List _foundUserData = result['body'];
              Map _foundMatchUser = _foundUserData
                  .firstWhere((el) => _tempList[x].userId == el["userId"]);
              _tempList[x].userName = _foundMatchUser["name"];
            }
          }
        } catch (e) {
          debugPrint('Error searching user data: ${e.toString()}');
        }
      }

      setState(() {
        // 키값의 0 인덱스는 코멘트의 1 인덱스.
        if (lastEvaluatedKeyList.isEmpty) {
          // 여기에 오는건 코멘트가 없거나 코멘트가 적을때. 전체 리스트를 세팅해준다.
          debugPrint('Adding more comments');
          commentList.assign(List<CommentModel>.from(_tempList)); // Deep copy
        } else {
          // 해당 인덱스가 존재하는지 확인. map 으로 바꿔서 확인.
          if (commentList.asMap().containsKey(lastEvaluatedKeyList.length)) {
            debugPrint('Replacing comments');
            commentList[lastEvaluatedKeyList.length]
                .assignAll(List<CommentModel>.from(_tempList));
          } else {
            debugPrint('Adding comments because its new');
            commentList.add(List<CommentModel>.from(_tempList));
          }
        }

        commentListMerged =
            commentList.expand((element) => element).toList(); // Flatten
      });
    }

    setState(() {
      isGetCommentLoading = false;
    });
  }

  createComment() async {
    if (_controllerComment.text.isNotEmpty) {
      setState(() {
        isCommentLoading = true;
      });
      await _lifeDevoDetailController.createComments(_curLifeDevoSession.id,
          _globalController.currentUser.userId, _controllerComment.text);

      // 최신이 가장 위에 있으므로, 리셋 시켜주고 다시 불러오자
      setState(() {
        _controllerComment.text = "";
        commentList =
            []; // 실질적으로 쓰이는건 commentList 가 아니라 commnetListMerged 라서 괜찮다.
        lastEvaluatedKeyList = [];
        isCommentLoading = false;
      });

      await getComments();
    }
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
                      controller: _scrollController,
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

                          // 내 코멘트 인풋 박스
                          _commentInputComponent(
                              _controllerComment, createComment),

                          // 테스팅용 코멘트 부르기 버튼
                          // GestureDetector(
                          //   onTap: getComments,
                          //   child: const Text('Load comments'),
                          // ),
                          // 코멘트들
                          _commentsComponent(commentListMerged),
                          // 코멘트 로딩을 잘 보여주기 위해 넣은 공간
                          const SizedBox(
                            height: 30,
                          ),
                          // 코멘트 로딩
                          if (isGetCommentLoading)
                            Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: double.infinity,
                              child: const LoadingWidget(
                                shape: "CIRCLE",
                                loaderSize: 26,
                              ),
                            ),
                          // 코멘트 로딩을 잘 보여주기 위해 넣은 공간
                          const SizedBox(
                            height: 50,
                          )
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

  _commentInputComponent(TextEditingController controllerInput, onPressSend) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          minRadius: 18,
          maxRadius: 18,
          child: Text(
            _globalController.currentUser.name.isNotEmpty
                ? _globalController.currentUser.name[0]
                : "?",
            style: const TextStyle(fontSize: 24),
          ),
        ),
        SizedBox(
          width: adminContentDetailSpace,
        ),
        Expanded(
          child: TextFormField(
            controller: controllerInput,
            minLines: 1,
            maxLines: 3,
            expands: false,
            keyboardType: TextInputType.multiline,
            autofocus: false,
            decoration: InputDecoration(
                hintText: 'Write a comment...',
                filled: true,
                fillColor: textFieldBackground,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none),
          ),
        ),
        SizedBox(
          width: adminContentDetailSpace,
        ),
        if (isCommentLoading)
          const CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: kPrimaryColor,
          ),
        if (!isCommentLoading)
          IconButton(
            onPressed: onPressSend,
            icon: Icon(
              Icons.send,
              size: navIcon,
              color: kPrimaryColor,
            ),
          ),
      ],
    );
  }

  _commentsComponent(List<CommentModel> comments) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: comments.map((CommentModel comment) {
        return ListTile(
          leading: CircleAvatar(
            minRadius: 14,
            maxRadius: 14,
            child: Text(
              comment.userName.isNotEmpty ? comment.userName[0] : "?",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          horizontalTitleGap: 8,
          dense: true,
          title: Text(comment.userName),
          subtitle: Text(comment.content),
        );
      }).toList(),
    );
  }
}
