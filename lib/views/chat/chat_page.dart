import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/chat/chat_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/models/chat_comp_model.dart';
import 'package:flutter_life_devo_app_v2/models/chat_message_model.dart';
import 'package:flutter_life_devo_app_v2/models/chat_room_model.dart';
import 'package:flutter_life_devo_app_v2/models/user_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: use_key_in_widget_constructors
class ChatPage extends StatelessWidget {
  //const ChatPage({Key? key}) : super(key: key);
  final GlobalController _gc = Get.find<GlobalController>();
  final ChatController _chatCtrler = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenPaddingHorizontal,
          ),
          child: SingleChildScrollView(
            //physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: screenPaddingVertical,
                ),
                // Page title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      //width: double.infinity,
                      child: Text(
                        'Messenger',
                        style: TextStyle(
                          fontSize: mainPageContentsTitle,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.8),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh,
                          size: 32, color: kPrimaryColor),
                      onPressed: _chatCtrler.getChatRoomList,
                    ),
                  ],
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: Text(
                //     'Messenger',
                //     style: TextStyle(
                //       fontSize: mainPageContentsTitle,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black.withOpacity(.8),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: mainPageContentsSpace,
                ),

                // Chat room list
                Obx(() {
                  // Map to List
                  List<ChatCompModel> _chatCompList = [];
                  _chatCtrler.chatListMap.forEach((key, compModel) {
                    _chatCompList.add(compModel);
                  });

                  // Length 가 0 이면 빈걸로 보여줌
                  if (_chatCtrler.isChatRoomLoading.value) {
                    return const LoadingWidget();
                  }
                  // if (_chatCtrler.chatRoomList.isNotEmpty) {
                  if (_chatCtrler.chatListMap.isNotEmpty) {
                    debugPrint('Chatroom list not empty...');
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ..._chatCompList.map((ChatCompModel el) {
                          ChatRoomModel _chatRoomData = el.chatRoomData;

                          // debugPrint('Element: ${_chatRoomData.chatRoomId}');
                          // debugPrint('My id: ${_gc.currentUser.userId}');
                          // debugPrint(
                          //     'User list: ${_chatRoomData.userDataList[0].userId} and ${_chatRoomData.userDataList[1].userId}');
                          // 내가 아닌 사람의 아이디 찾기
                          String friendName = _chatRoomData.userDataList
                              .firstWhere(
                                (User element) =>
                                    element.userId != _gc.currentUser.userId,
                              )
                              .name;

                          // 가장 최신 메세지 찾기
                          ChatMessageModel _latestMessage = ChatMessageModel();
                          if (el.newMessagesList.isNotEmpty) {
                            _latestMessage = el.newMessagesList[0];
                          } else if (el.oldMessagesList.isNotEmpty) {
                            _latestMessage = el.oldMessagesList[0];
                          }

                          return GestureDetector(
                            onTap: () => _chatCtrler
                                .gotoChatDetailPage(_chatRoomData.chatRoomId),
                            child: Stack(
                              children: [
                                Container(
                                  // 메세지 뱃지를 위해 자리 비워둠
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Card(
                                    elevation: 3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      height: chatRoomListCardHeight,
                                      width: double.maxFinite,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // User info
                                          Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                friendName,
                                                style: TextStyle(
                                                    fontSize:
                                                        chatRoomListCardUserName,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),

                                          // Last message
                                          Container(
                                            padding: const EdgeInsets.only(
                                                right: 15.0),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              _latestMessage
                                                      .skCollection.isNotEmpty
                                                  ? _latestMessage.message
                                                  : "No messages",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize:
                                                      chatRoomListCardLastMsg,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),

                                          // Last message time
                                          Container(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              DateFormat.yMMMd()
                                                  .add_Hms()
                                                  .format(
                                                    DateTime.fromMillisecondsSinceEpoch(
                                                        _chatRoomData
                                                            .lastMessageEventEpoch),
                                                  ),
                                              style: TextStyle(
                                                  fontSize:
                                                      chatRoomListCardDate),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // 뱃지로 새 메세지수 보여준다.
                                if (el.newMessagesCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        color: kSecondaryColor.withOpacity(0.9),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 32,
                                        minHeight: 32,
                                      ),
                                      child: Text(
                                        el.newMessagesCount.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          );
                        }).toList()
                      ],
                    );
                  }
                  return const Text('Empty list');
                }),

                // Life devo content
                // Obx(() {
                //   if (_mainController.latestLifeDevoSession.value
                //       .pkCollectionSession.isNotEmpty) {
                //     return LatestLifeDevo(
                //       _mainController.latestLifeDevoSession.value,
                //     );
                //   }
                //   return Container();
                // })
              ],
            ),
          ),
        ),
        // Obx(() {
        //   return _mainController.isHomeTabLoading.value
        //       ? const LoadingWidget()
        //       : Container();
        // })
      ],
    );
  }
}
