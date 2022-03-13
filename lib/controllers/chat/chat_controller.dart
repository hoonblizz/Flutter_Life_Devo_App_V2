import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/data/repository/messenger_repository.dart';
import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/chat_comp_model.dart';
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
  //RxList<ChatRoomModel> chatRoomList = <ChatRoomModel>[].obs;
  // Key 값으로 방 id를 쓴다.
  RxMap<String, ChatCompModel> chatListMap = <String, ChatCompModel>{}.obs;
  RxBool isChatRoomLoading = false.obs;

  // Chat detail
  String latestMessageSK = ""; // getMessage로 최신꺼 가져올때 사용
  RxBool isChatDetailLoading = false.obs; // 대단한 기능은 아니지만 강제로 렌더링 시켜줄때 쓴다.

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
          // 어디까지 받아와야 하는지 sk
          debugPrint(
              'Message until key: ${chatListMap[data['chatRoomId']]!.latestMessageSK}');
          await getMessages(
            data['chatRoomId'],
            attachTo: "NEW",
            attachType: "ADD",
            //oldToNew: false,
            messageUntilKey: chatListMap[data['chatRoomId']]!.latestMessageSK,
          );
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
    List _foundUserDataList = [];
    try {
      Map result =
          await userContentRepo.searchUserByUserId(_userIdList.toList());
      debugPrint('Result getting user data: ${result.toString()}');

      if (result['statusCode'] == 200 && result['body'] != null) {
        _foundUserDataList = result['body'];
      }
    } catch (e) {
      debugPrint('Error searching user data: ${e.toString()}');
    }

    // 방 정보와 유저 정보 조합. 정보가 잘 들러붙나 확인
    for (var x = 0; x < _tempChatRoomList.length; x++) {
      ChatRoomModel _curChatRoomData = _tempChatRoomList[x];
      List _curUserNameList = _curChatRoomData.usernameList;

      // 각 방의 포함된 유저들 보면서, 찾아낸 유저 리스트에서 매칭 되는거 찾아서 넣어줌.
      for (var y = 0; y < _curUserNameList.length; y++) {
        Map _foundMatchUser = _foundUserDataList
            .firstWhere((el) => _curUserNameList[y] == el["userId"]) as Map;
        debugPrint('Match found: ${_foundMatchUser.toString()}');
        _curChatRoomData.userDataList.add(User.fromJSON(_foundMatchUser));
      }

      // updated: 03.12.2022 맵으로 전체 방을 관리해주자
      // 방 정보가 완성 되었으므로, 이제 Chat composite 모델 생성
      chatListMap[_curChatRoomData.chatRoomId] =
          ChatCompModel(chatRoomData: _curChatRoomData);
    }

    // 결과를 Deep copy
    //chatRoomList.value = List<ChatCompModel>.from(_tempChatRoomList);
    //debugPrint('Chat room list: ${chatRoomList.length}');
  }

  getMessages(
    String chatRoomId, {
    String attachTo = "OLD", // or NEW
    String attachType = "OVERWRITE", // or ADD
    bool oldToNew = false,
    Map lastEvaluatedKey = const {},
    String messageUntilKey = "",
  }) async {
    Map _newLastEvaluatedKey = {};
    List<ChatMessageModel> _tempList = [];
    try {
      Map result = await messengerRepo.getMessage(
        chatRoomId,
        gc.currentUser.userId,
        oldToNew,
        lastEvaluatedKey,
        messageUntilKey,
      );
      //debugPrint('Get messages result: ${result.toString()}');
      if (result.isNotEmpty &&
          result['statusCode'] == 200 &&
          result['body']['messages'] != null) {
        for (int x = 0; x < result['body']['messages'].length; x++) {
          _tempList
              .add(ChatMessageModel.fromJSON(result['body']['messages'][x]));
        }
      }

      debugPrint(
          'First: ${_tempList[0].message}, Last: ${_tempList[_tempList.length - 1].message}');

      // oldToNew = false 면 최신부터 나오므로 순서를 뒤집어주자 -> display 시에 쓰이는 테크닉 때문에 그냥 써준다.
      //_tempList.sort((a, b) => b.createdEpoch.compareTo(a.createdEpoch));

      if (result['body']['LastEvaluatedKey'] != null) {
        _newLastEvaluatedKey = result['body']['LastEvaluatedKey'];
      }
    } catch (e) {
      debugPrint('Error getting message data: ${e.toString()}');
    }

    // ChatRoom list 구할때 init 되었지만 그래도 확인.
    // attachTo 에 따라서 어느 메세지 리스트에 붙이는지 달라짐.
    // Pagination 은 올드 메세지에만 붙는다.
    // 대신 new 는 message until 로 커버
    if (chatListMap[chatRoomId] != null) {
      // 실제 데이터
      if (attachTo == "OLD") {
        // Pagination key
        chatListMap[chatRoomId]!.lastEvaluatedKey = _newLastEvaluatedKey;

        if (attachType == "OVERWRITE") {
          chatListMap[chatRoomId] = ChatCompModel(
            chatRoomData: chatListMap[chatRoomId]!.chatRoomData,
            newMessagesList: chatListMap[chatRoomId]!.newMessagesList,
            oldMessagesList: _tempList,
            lastEvaluatedKey: chatListMap[chatRoomId]!.lastEvaluatedKey,
          );
        } else if (attachType == "ADD") {
          // Deep copy 도 렌더링을 못해주더라. 아마 너무 딥하게 들어가서 그런듯.
          // 그냥 새로 assign 해주자
          chatListMap[chatRoomId] = ChatCompModel(
            chatRoomData: chatListMap[chatRoomId]!.chatRoomData,
            newMessagesList: chatListMap[chatRoomId]!.newMessagesList,
            oldMessagesList: [
              ...chatListMap[chatRoomId]!.oldMessagesList,
              ..._tempList
            ],
            lastEvaluatedKey: chatListMap[chatRoomId]!.lastEvaluatedKey,
          );
        }
      } else if (attachTo == "NEW") {
        if (attachType == "OVERWRITE") {
          // chatListMap[chatRoomId] = ChatCompModel(
          //   chatRoomData: chatListMap[chatRoomId]!.chatRoomData,
          //   oldMessagesList: chatListMap[chatRoomId]!.oldMessagesList,
          //   newMessagesList: _tempList,
          //   lastEvaluatedKey: chatListMap[chatRoomId]!.lastEvaluatedKey,
          // );
        } else if (attachType == "ADD") {
          chatListMap[chatRoomId] = ChatCompModel(
            chatRoomData: chatListMap[chatRoomId]!.chatRoomData,
            newMessagesList: chatListMap[chatRoomId]!.newMessagesList,
            oldMessagesList: [
              ..._tempList,
              ...chatListMap[chatRoomId]!.oldMessagesList,
            ],
            lastEvaluatedKey: chatListMap[chatRoomId]!.lastEvaluatedKey,
          );
        }
      }
    }

    checkLatestMessageSK(chatRoomId); // 새 메세지 받아올때 기준점 제시
  }

  checkLatestMessageSK(String chatRoomId) {
    // List<ChatMessageModel> _curNewMessagesList =
    //     chatListMap[chatRoomId]!.newMessagesList;
    List<ChatMessageModel> _curOldMessagesList =
        chatListMap[chatRoomId]!.oldMessagesList;

    // if (_curNewMessagesList.isNotEmpty) {
    //   chatListMap[chatRoomId]!.latestMessageSK =
    //       _curNewMessagesList[0].skCollection;
    // } else if (_curOldMessagesList.isNotEmpty) {
    //   chatListMap[chatRoomId]!.latestMessageSK =
    //       _curOldMessagesList[0].skCollection;
    // }
    if (_curOldMessagesList.isNotEmpty) {
      chatListMap[chatRoomId]!.latestMessageSK =
          _curOldMessagesList[0].skCollection;
    }
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
