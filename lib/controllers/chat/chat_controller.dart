import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/data/repository/messenger_repository.dart';
import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/chat_message_model.dart';
import 'package:flutter_life_devo_app_v2/models/chat_room_model.dart';
import 'package:flutter_life_devo_app_v2/models/user_model.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const String currentFileName = "Chat_Controller";

class ChatController extends GetxController {
  final AuthRepository authRepo;
  final UserContentsRepository userContentRepo;
  final MessengerRepository messengerRepo;
  ChatController({
    required this.authRepo,
    required this.userContentRepo,
    required this.messengerRepo,
  });

  // 이미 main 에서 put 해줬으니 찾기만 하면 된다.
  //GlobalController gc = Get.put(GlobalController());
  GlobalController gc = Get.find();

  // Variables
  late WebSocketChannel socketConnection;
  RxList<ChatRoomModel> chatRoomList = <ChatRoomModel>[].obs;
  RxBool isChatRoomLoading = false.obs;

  startWebSocket() {
    // 연결
    socketConnection = WebSocketChannel.connect(
        Uri.parse('wss://ws.bclifedevo.com/messenger-dev'));

    // 리스너
    socketConnection.stream.listen(
      (dataPacket) async {
        Map data = jsonDecode(dataPacket);
        // 해당 data 에 eventType: NEW_MESSAGE_RECEIVED 가 있을때만 새 메세지 받은것.
        //debugPrint('New message: ${data.toString()}');

        if (data['eventType'] == "NEW_MESSAGE_RECEIVED" &&
            data['chatRoomId'] != null) {
          debugPrint('New message: ${data.toString()}');
          //await getMessages(false, data['chatRoomId']);
        }
      },
      cancelOnError: true,
      onError: (e) {
        debugPrint('Error on socket listener: ${e.toString()}');
      },
      onDone: () {
        debugPrint('Done on socket listener');
      },
    );

    // 연결 지속
    socketConnector(socketConnection);
    Timer.periodic(
      const Duration(seconds: 10),
      (_) => socketConnector(socketConnection),
    );
  }

  socketConnector(socketConnection) {
    if (gc.currentUser.userId.isNotEmpty) {
      //sending login action to socket
      socketConnection.sink.add(jsonEncode(
          {"action": 'logConnection', "username": gc.currentUser.userId}));
      //debugPrint('system notification : Sent Log to socket');
    }
  }

  getChatRoomList() async {
    String userId = gc.currentUser.userId;
    if (userId.isEmpty) {
      return null;
    }

    List<ChatRoomModel> _tempChatRoomList = [];
    try {
      Map result = await messengerRepo.getChatRoomListByUser(userId);
      debugPrint('Result getting chat room: ${result.toString()}');
      if (result.isNotEmpty && result['statusCode'] == 200) {
        for (int x = 0; x < result['body'].length; x++) {
          _tempChatRoomList.add(ChatRoomModel.fromJSON(result['body'][x]));
        }
      }
    } catch (e) {
      debugPrint('Error getting chatroom list: ${e.toString()}');
    }

    // 채팅방 돌면서 유저 정보 모으기
    List<String> _userIdList = []; //toSet 으로 중복 없애줌.
    for (ChatRoomModel chatroom in _tempChatRoomList) {
      _userIdList.addAll(chatroom.usernameList.map((e) => e));
    }
    _userIdList.toSet();

    debugPrint('User id collected: ${_userIdList.toString()}');

    // 유저정보들 한꺼번에 받아서 각각의 채팅방 정보에 붙여넣기
    try {
      Map result =
          await userContentRepo.searchUserByUserId(_userIdList.toList());
      debugPrint('Result getting user data: ${result.toString()}');

      if (result['statusCode'] == 200 && result['body'] != null) {
        // 각 방마다 돌면서
        for (var x = 0; x < _tempChatRoomList.length; x++) {
          List _foundUserData = result['body'];
          List _curUserNameList = _tempChatRoomList[x].usernameList;

          // 각 방의 포함된 유저들 보면서, 찾아낸 유저 리스트에서 매칭 되는거 찾아서 넣어줌.
          for (var y = 0; y < _curUserNameList.length; y++) {
            Map _foundMatchUser = _foundUserData
                .firstWhere((el) => _curUserNameList[y] == el["userId"]) as Map;
            debugPrint('Match found: ${_foundMatchUser.toString()}');
            _tempChatRoomList[x]
                .userDataList
                .add(User.fromJSON(_foundMatchUser));
          }
        }
      }
    } catch (e) {
      debugPrint('Error searching user data: ${e.toString()}');
    }

    // 결과를 Deep copy
    chatRoomList.value = List<ChatRoomModel>.from(_tempChatRoomList);
    debugPrint('Chat room list: ${chatRoomList.length}');
  }

  Future<Map> getMessages(String chatRoomId,
      {bool oldToNew = false, lastEvaluatedKey = const {}}) async {
    Map _newLastEvaluatedKey = {};
    List<ChatMessageModel> _tempList = [];
    try {
      Map result = await messengerRepo.getMessage(
          chatRoomId, gc.currentUser.userId, oldToNew, lastEvaluatedKey);
      //debugPrint('Get messages result: ${result.toString()}');
      if (result.isNotEmpty &&
          result['statusCode'] == 200 &&
          result['body']['messages'] != null) {
        for (int x = 0; x < result['body']['messages'].length; x++) {
          _tempList
              .add(ChatMessageModel.fromJSON(result['body']['messages'][x]));
        }
      }

      // oldToNew = false 면 최신부터 나오므로 순서를 뒤집어주자 -> display 시에 쓰이는 테크닉 때문에 그냥 써준다.
      //_tempList.sort((a, b) => b.createdEpoch.compareTo(a.createdEpoch));

      if (result['body']['LastEvaluatedKey'] != null) {
        _newLastEvaluatedKey = result['body']['LastEvaluatedKey'];
      }
    } catch (e) {
      debugPrint('Error getting message data: ${e.toString()}');
    }
    return {"lastEvaluatedKey": _newLastEvaluatedKey, "messageList": _tempList};
  }

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
  }

  gotoChatDetailPage(String chatRoomId) {
    Get.toNamed(Routes.CHAT_DETAIL, arguments: [chatRoomId]);
  }

  @override
  void onInit() {
    gc.consoleLog(
      "Init Chat page controller",
      curFileName: currentFileName,
    );
    startWebSocket();
    getChatRoomList();
    super.onInit();
  }
}
