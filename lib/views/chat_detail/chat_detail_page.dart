/*
  로딩시에도 로딩 뒤에서는 리스트가 만들어져야한다.
  그래야 스크롤의 사이즈가 정해지고, 그래야 jumpTo 스크롤이 가능해지므로.
*/

import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/chat/chat_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/models/chat_message_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';
import 'package:get/get.dart';

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

  final ScrollController _privateScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    debugPrint('Chatroom id is, $chatRoomId');
    _chatController.scrollController = _privateScrollController;
    _chatController.scrollListener(chatRoomId);
    initChatDetails();
    super.initState();
  }

  // scrollListener() {
  //   _chatController.scrollController.addListener(() {
  //     if (_chatController.scrollController.position.atEdge) {
  //       bool isTop = _chatController.scrollController.position.pixels == 0;
  //       if (isTop) {
  //         debugPrint('Scroll at the top');
  //       } else {
  //         debugPrint('Scroll at the bottom');
  //         //getComments();
  //         // 코멘트 로딩을 보여주려면 좀더 내려가야함. -> 근데 이거 하면 bottom 에 한번 더 도달해서 코멘트를 두번 부르게 된다.
  //         //_scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  //       }
  //     }
  //   });
  // }

  initChatDetails() async {
    await getMessages();
    //await Future.delayed(const Duration(seconds: 1));
    // _chatController.scrollController
    //     .jumpTo(_chatController.scrollController.position.maxScrollExtent);
  }

  getMessages() async {
    await _chatController.getMessages(chatRoomId);
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    _chatController.scrollController.dispose();
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
            Obx(() {
              return SingleChildScrollView(
                controller: _chatController.scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ..._chatController.chatMessagesListMerged
                        .map((ChatMessageModel el) {
                      bool isMyself = el.sentFrom == _gc.currentUser.userId;

                      return Container(
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: (!isMyself
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (!isMyself
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              el.message,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    }),
                    // 하단의 텍스트 치는곳 만큼 자리를 띄워주자.
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              );
            }),

            // 로딩시에도 위에서는 리스트가 만들어져야한다.
            Obx(() {
              if (_chatController.isChatMessagesLoading.value) {
                return const LoadingWidget(
                  color: Colors.white,
                  colorOpacity: 1,
                );
              }
              return Container();
            }),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Container(
                    //     height: 30,
                    //     width: 30,
                    //     decoration: BoxDecoration(
                    //       color: Colors.lightBlue,
                    //       borderRadius: BorderRadius.circular(30),
                    //     ),
                    //     child: Icon(
                    //       Icons.add,
                    //       color: Colors.white,
                    //       size: 20,
                    //     ),
                    //   ),
                    // ),
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
