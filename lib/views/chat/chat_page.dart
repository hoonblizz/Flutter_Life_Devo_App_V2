import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/chat/chat_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/models/chat_room_model.dart';
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
                  //List<ChatRoomModel> _chatRoomList = _chatCtrler.chatRoomList;

                  if (_chatCtrler.isChatRoomLoading.value) {
                    return const LoadingWidget();
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _chatCtrler.chatRoomList.map((ChatRoomModel el) {
                      return GestureDetector(
                        onTap: () =>
                            _chatCtrler.gotoChatDetailPage(el.chatRoomId),
                        child: Card(
                          elevation: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            height: chatRoomListCardHeight,
                            width: double.maxFinite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // User info
                                Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      el.userDataList
                                          .firstWhere((element) =>
                                              element.userId !=
                                              _gc.currentUser.userId)
                                          .name,
                                      style: TextStyle(
                                          fontSize: chatRoomListCardUserName,
                                          fontWeight: FontWeight.w600),
                                    )),

                                // Last message
                                Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      el.chatRoomId,
                                      style: TextStyle(
                                          fontSize: chatRoomListCardLastMsg,
                                          fontWeight: FontWeight.w500),
                                    )),

                                // Last message time
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    DateFormat.yMMMEd().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          el.lastMessageEventEpoch),
                                    ),
                                    style: TextStyle(
                                        fontSize: chatRoomListCardDate),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                })

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
