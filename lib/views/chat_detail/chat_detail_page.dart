/*
  로딩시에도 로딩 뒤에서는 리스트가 만들어져야한다.
  그래야 스크롤의 사이즈가 정해지고, 그래야 jumpTo 스크롤이 가능해지므로.
*/

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_life_devo_app_v2/controllers/chat/chat_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/models/chat_message_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({Key? key}) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageTextController = TextEditingController();

  final ChatController _chatController = Get.find();
  final GlobalController _gc = Get.find();
  String chatRoomId = Get.arguments[0];

  bool displayLoading = false;
  bool isLoadingData = false;
  int _curScrollIndex = 0;
  int _prevScrollIndex = 0;

  late ScrollController _scrollController = ScrollController();
  late Key oldMessageListKey;
  late Key newMessageListKey;
  late Key bottomKey;
  bool newMessageNumIsSmall = true;
  Map<String, Key> keyCollection = {}; // sk, key 모음

  List<ChatMessageModel> _oldChatMessageList = [];
  List<ChatMessageModel> _newChatMessageList = [];
  Map _curLastEvalKey = {};

  @override
  void initState() {
    debugPrint('Chatroom id is, $chatRoomId');
    //_scrollController = AutoScrollController()..addListener(_scrollListener);
    _scrollController.addListener(_scrollListener);
    oldMessageListKey = UniqueKey();
    newMessageListKey = UniqueKey();
    bottomKey = UniqueKey();

    initChatDetails();
    super.initState();
  }

  _scrollListener() {
    //debugPrint('Position: ${_scrollController.position.extentBefore}');
    // if (_scrollController.position.extentBefore < 2000 &&
    //     _messengerController.chatroomList[foundIndex].readMessageList.length >= 198 &&
    //     _messengerController.chatroomList[foundIndex].lastEvaluatedKey.isNotEmpty) {
    //   _messengerController.createTempMessageList(chatroomData.chatRoomId, "top");
    // } else if (_scrollController.position.extentAfter < 3000 &&
    //     _messengerController.unreadMessageNotExisting.value == false) {
    //   _messengerController.createTempMessageList(chatroomData.chatRoomId, "bottom");
    // }else if(_scrollController.position.extentAfter == 0){
    //   _messengerController.newMessageReceived(false);
    // }

    if (_scrollController.position.extentBefore < 100 && !isLoadingData) {
      debugPrint(
          'Last eval key: ${_curLastEvalKey.toString()}. Calling Previous messages...');
      getOldMessages();
    }
  }

  checkNewMessageNum() {
    if (_newChatMessageList.length < 8) {
      newMessageNumIsSmall = true;
    } else {
      newMessageNumIsSmall = false;
    }
  }

  initChatDetails() async {
    setState(() {
      displayLoading = true;
    });
    Map result = await _chatController.getMessages(chatRoomId);
    setState(() {
      _curLastEvalKey = result['lastEvaluatedKey'];
      List<ChatMessageModel> _tempList = result['messageList'];
      _oldChatMessageList = _tempList;
      checkNewMessageNum();
    });

    setState(() {
      displayLoading = false;
    });
  }

  getOldMessages() async {
    if (_curLastEvalKey.isNotEmpty) {
      debugPrint('Start calling OLD messages =======================>');
      isLoadingData = true;

      Map result = await _chatController.getMessages(chatRoomId,
          lastEvaluatedKey: _curLastEvalKey);

      setState(() {
        _curLastEvalKey = result['lastEvaluatedKey'];
        List<ChatMessageModel> _tempList = result['messageList'];
        if (_tempList.isNotEmpty) {
          _oldChatMessageList = [
            ..._oldChatMessageList,
            ..._tempList,
          ];
          debugPrint(
              '${_tempList.length} more messages attached to OLD: \nFrom: ${_tempList[0].message}  \nTo: ${_tempList[_tempList.length - 1].message}');
        } else {
          debugPrint('More old messages returned empty. No need to attach.');
        }
      });

      await Future.delayed(const Duration(milliseconds: 1000));

      debugPrint('Finish calling OLD messages <=======================');

      isLoadingData = false;
    }
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    _scrollController.dispose();
    debugPrint('Dispose takes an action!!!!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navBG,
      appBar: _customAppBar(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: Scrollable(
                    controller: _scrollController,
                    viewportBuilder:
                        (BuildContext context, ViewportOffset position) {
                      return Viewport(
                        offset: position,
                        center: !newMessageNumIsSmall
                            ? newMessageListKey
                            : bottomKey,
                        anchor: !newMessageNumIsSmall ? 0.40 : 0.90,
                        slivers: [
                          _messagesList(_oldChatMessageList, isLoadingData,
                              oldMessageListKey),
                          _messagesList(_newChatMessageList, isLoadingData,
                              newMessageListKey),
                          _messagesList([], isLoadingData, bottomKey),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),

            // 이니셜하게 로딩했을때 스크롤이 밑으로 내려가는걸 가려준다.
            if (displayLoading)
              const LoadingWidget(
                color: Colors.white,
                colorOpacity: 1,
              ),

            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageTextController,
                        decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    FloatingActionButton(
                      onPressed: () {},
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: kPrimaryColor,
                      elevation: 0,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messagesList(List<ChatMessageModel> messageList, isLoading, key) {
    return SliverList(
      key: key,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          ChatMessageModel _curMessage = messageList[index];
          bool isMyself = _curMessage.sentFrom == _gc.currentUser.userId;

          return Container(
            padding:
                const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            child: Align(
              alignment: (!isMyself ? Alignment.topLeft : Alignment.topRight),
              child: Column(
                crossAxisAlignment: (!isMyself
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                          (!isMyself ? Colors.grey.shade200 : Colors.blue[200]),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _curMessage.message,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      DateFormat.yMMMd().add_Hms().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              _curMessage.createdEpoch)),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),

                  // // 마지막 아이템에는 sizedbox 를 더 넣어준다.
                ],
              ),
            ),
          );
        },
        childCount: messageList.length,
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
          'Friend chat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: kPrimaryColor,
    );
  }
}
