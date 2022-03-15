/*
  로딩시에도 로딩 뒤에서는 리스트가 만들어져야한다.
  그래야 스크롤의 사이즈가 정해지고, 그래야 jumpTo 스크롤이 가능해지므로.
*/

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_life_devo_app_v2/controllers/chat/chat_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/models/chat_message_model.dart';
import 'package:flutter_life_devo_app_v2/models/chat_room_model.dart';
import 'package:flutter_life_devo_app_v2/models/user_model.dart';
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

  final ScrollController _scrollController = ScrollController();
  late Key oldMessageListKey;
  late Key newMessageListKey;
  late Key bottomKey;
  bool newMessageNumIsSmall = true;
  Map<String, Key> keyCollection = {}; // sk, key 모음

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
    // 메세지 하나당 대충 70~80 정도 잡는다 (싱글라인 메세지 경우)
    if (_scrollController.position.extentBefore < (80 * 10) && !isLoadingData) {
      debugPrint('Calling old messages...');
      getOldMessages();
    }
  }

  initChatDetails() async {
    setState(() {
      displayLoading = true;
    });
    await _chatController.getMessages(chatRoomId);

    setState(() {
      displayLoading = false;
    });
  }

  getOldMessages() async {
    Map _curLastEvalKey =
        _chatController.chatListMap[chatRoomId]!.lastEvaluatedKey;
    debugPrint(
        'Last eval key: ${_chatController.chatListMap[chatRoomId]!.lastEvaluatedKey.toString()}');

    if (_curLastEvalKey.isNotEmpty) {
      debugPrint('Start calling OLD messages =======================>');
      isLoadingData = true;
      await _chatController.getMessages(
        chatRoomId,
        attachTo: "OLD",
        attachType: "ADD",
        lastEvaluatedKey: _curLastEvalKey,
      );
      // 마구잡이로 로딩하는걸 막아줌.
      await Future.delayed(const Duration(milliseconds: 1000));
      debugPrint('Finish calling OLD messages <=======================');
      isLoadingData = false;
    }
  }

  sendMessage() async {
    if (_messageTextController.text.isNotEmpty) {
      _chatController.sendMessage(chatRoomId, _messageTextController.text);
      _messageTextController.text = "";
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
    // UI 가 점핑하는게 별로다.
    //bool _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: navBG,
        appBar: _customAppBar(
            _chatController.chatListMap[chatRoomId]!.chatRoomData),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: <Widget>[
              Obx(() {
                // 강제로 렌더링 시켜줘야 되므로 로딩을 넣었다.

                List<ChatMessageModel> _oldMessagesList =
                    _chatController.chatListMap[chatRoomId]!.oldMessagesList;

                List<ChatMessageModel> _newMessagesList =
                    _chatController.chatListMap[chatRoomId]!.newMessagesList;

                // bool _newMessageNumIsSmall =
                //     _chatController.chatListMap[chatRoomId]!.newMessageNumIsSmall;

                return GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        child: Scrollable(
                          controller: _scrollController,
                          viewportBuilder:
                              (BuildContext context, ViewportOffset position) {
                            return Viewport(
                              offset: position,

                              center: _newMessagesList.isEmpty
                                  ? newMessageListKey
                                  : bottomKey,
                              //center: bottomKey,

                              anchor:
                                  0.78, //!_newMessageNumIsSmall ? 0.40 : 0.90,
                              axisDirection: AxisDirection.down,
                              slivers: [
                                _messagesList(
                                  _oldMessagesList,
                                  isLoadingData,
                                  oldMessageListKey,
                                ),
                                _messagesList(
                                  _newMessagesList,
                                  isLoadingData,
                                  newMessageListKey,
                                ),
                                _messagesList([], isLoadingData, bottomKey),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // 이니셜하게 로딩했을때 스크롤이 밑으로 내려가는걸 가려준다.
              if (displayLoading)
                const LoadingWidget(
                  color: Colors.white,
                  colorOpacity: 1,
                ),

              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    border: Border(
                      left: BorderSide(
                        color: kPrimaryColor,
                        width: 8,
                      ),
                      right: BorderSide(
                        color: kPrimaryColor,
                        width: 8,
                      ),
                      top: BorderSide(
                        color: kPrimaryColor,
                        width: 8,
                      ),
                      bottom: BorderSide(
                        color: kPrimaryColor,
                        width: 30,
                      ),
                    ),
                  ),

                  width: double.infinity,
                  //color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: kPrimaryColor, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.only(
                        left: 10, bottom: 5, top: 5, right: 10),
                    constraints:
                        const BoxConstraints(minHeight: 50, maxHeight: 200),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _messageTextController,
                            minLines: 1,
                            maxLines: 3,
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
                          onPressed: sendMessage,
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 22,
                          ),
                          backgroundColor: kPrimaryColor,
                          elevation: 0,
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

  Widget _messagesList(List<ChatMessageModel> messageList, isLoading, key) {
    return SliverList(
      key: key,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          ChatMessageModel _curMessage = messageList[index];
          bool isMyself = _curMessage.sentFrom == _gc.currentUser.userId;

          //debugPrint('Attaching: ${_curMessage.message}');

          return Container(
            // width: double.infinity,
            padding:
                const EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 5),
            child: Container(
              alignment: (!isMyself ? Alignment.topLeft : Alignment.topRight),
              child: Column(
                crossAxisAlignment: (!isMyself
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end),
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: (!isMyself
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end),
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      // 로컬 메세지면 아이콘 하나 찍어준다.
                      if (_curMessage.isLocalMessage)
                        Container(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.upload,
                              color: kPrimaryColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      Container(
                        constraints: BoxConstraints(
                            minWidth: 10, maxWidth: Get.width * 0.8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (!isMyself
                              ? Colors.grey.shade200
                              : Colors.blue[200]),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Text(
                          _curMessage.message,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
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
                ],
              ),
            ),
          );
        },
        childCount: messageList.length,
      ),
    );
  }

  _customAppBar(ChatRoomModel _chatRoomData) {
    // 상대방 이름찾기
    User _friendData = _chatRoomData.userDataList
        .firstWhere((el) => el.userId != _gc.currentUser.userId);

    return AppBar(
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 4), // 오묘하게 센터가 안맞아서 그냥 넣어줌
        child: Text(
          _friendData.name.isNotEmpty ? _friendData.name : "Messages",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      backgroundColor: kPrimaryColor,
    );
  }
}
