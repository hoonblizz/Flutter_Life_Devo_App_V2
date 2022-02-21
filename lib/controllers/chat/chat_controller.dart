import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/data/repository/messenger_repository.dart';
import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
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
  List<ChatRoomModel> chatRoomList = <ChatRoomModel>[].obs;
  RxBool isChatRoomLoading = false.obs;

  startWebSocket() {
    // 연결
    socketConnection = WebSocketChannel.connect(
        Uri.parse('wss://ws.bclifedevo.com/messenger-dev'));

    // 리스너
    socketConnection.stream.listen(
      (dataPacket) async {
        Map data = jsonDecode(dataPacket);
        //debugPrint('New message: ${data['message']}');
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
        List<ChatRoomModel> _tempList = [];
        for (int x = 0; x < result['body'].length; x++) {
          _tempList.add(ChatRoomModel.fromJSON(result['body'][x]));
        }
        _tempChatRoomList = _tempList;
        //chatRoomList = List<ChatRoomModel>.from(_tempList); // Deep copy
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
        for (var x = 0; x < _tempChatRoomList.length; x++) {
          List _foundUserData = result['body'];
          Map _foundMatchUser = _foundUserData.firstWhere((el) =>
              _tempChatRoomList[x].usernameList.contains(el["userId"])) as Map;
          //debugPrint('Match found: ${_foundMatchUser.toString()}');
          _tempChatRoomList[x].userDataList.add(User.fromJSON(_foundMatchUser));
        }
      }
    } catch (e) {
      debugPrint('Error searching user data: ${e.toString()}');
    }

    // 결과를 Deep copy
    chatRoomList = List<ChatRoomModel>.from(_tempChatRoomList);
  }

  getMessages() async {}

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
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
