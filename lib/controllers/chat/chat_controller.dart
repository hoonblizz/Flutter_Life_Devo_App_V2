import 'dart:async';
import 'dart:convert';
import 'dart:math';

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

  // Utils: 소켓 연결시간 확인
  DateTime startConnectionTime = DateTime.now();
  DateTime endConnectionTime = DateTime.now();

  startWebSocket() {
    // 연결
    socketConnection = WebSocketChannel.connect(
        Uri.parse('wss://ws.bclifedevo.com/messenger-dev'));

    startConnectionTime = DateTime.now();

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
          debugPrint('Current route: ${Get.currentRoute}');
          await getMessages(
            data['chatRoomId'],
            attachTo: "NEW",
            attachType: "ADD",
            //oldToNew: false,
            messageUntilKey: chatListMap[data['chatRoomId']]!.latestMessageSK,
            addUpBadge:
                Get.currentRoute == "/main", // 메인 (채팅방 리스트) 에서만 뱃지를 위해 카운트 해준다.
          );
        }
      },
      cancelOnError: true,
      onError: (e) {
        debugPrint('Error on socket listener: ${e.toString()}');
      },
      onDone: () {
        endConnectionTime = DateTime.now();
        debugPrint(
            '==============> Done on socket listener: ${endConnectionTime.difference(startConnectionTime).inMinutes}');
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
      socketConnection.sink.add(
        jsonEncode(
          {
            "action": 'logConnection',
            "username": gc.currentUser.userId,
          },
        ),
      );
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

      // 방의 마지막 메세지정도 불러본다.
      await getLatestMessage(_curChatRoomData.chatRoomId);
    }

    // 결과를 Deep copy
    //chatRoomList.value = List<ChatCompModel>.from(_tempChatRoomList);
    //debugPrint('Chat room list: ${chatRoomList.length}');
  }

  getLatestMessage(String chatRoomId) async {
    // 전에 맵에서 ChatCompModel 을 이미 생성했다고 가정한다.
    // 어차피 방안에 들어가면 메세지들 새로 불러온다.
    List<ChatMessageModel> _tempList = [];
    try {
      // 1 개 부르지만 결과는 여러개 나온다. 첫번째가 최신
      Map result = await messengerRepo
          .getMessage(chatRoomId, gc.currentUser.userId, maxNumOfMessages: 1);
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
    } catch (e) {
      debugPrint('Error getting message data: ${e.toString()}');
    }

    if (chatListMap[chatRoomId] != null) {
      // 딥카피를 위해 하나 본 떠준다.
      ChatCompModel _tempModel =
          ChatCompModel.copyFrom(chatListMap[chatRoomId]!);

      _tempModel.newMessagesList = [];
      _tempModel.oldMessagesList = _tempList;

      // 볼일 다 끝났으면 이제 교체해준다.
      chatListMap[chatRoomId] = _tempModel;
    }
  }

  getMessages(
    String chatRoomId, {
    String attachTo = "OLD", // or NEW
    String attachType = "OVERWRITE", // or ADD
    bool oldToNew = false,
    Map lastEvaluatedKey = const {},
    String messageUntilKey = "",
    bool addUpBadge = false,
  }) async {
    Map _newLastEvaluatedKey = {};
    List<ChatMessageModel> _tempList = [];
    try {
      Map result = await messengerRepo.getMessage(
        chatRoomId,
        gc.currentUser.userId,
        oldToNew: oldToNew,
        lastEvaluatedKey: lastEvaluatedKey,
        messageUntilKey: messageUntilKey,
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
      // 딥카피를 위해 하나 본 떠준다.
      ChatCompModel _tempModel =
          ChatCompModel.copyFrom(chatListMap[chatRoomId]!);

      // 실제 데이터
      if (attachTo == "OLD") {
        // Pagination key
        _tempModel.lastEvaluatedKey = _newLastEvaluatedKey;

        if (attachType == "OVERWRITE") {
          // 올드 메세지를 오버라이트 해야되는 경우는, 채팅방에 막 들어와서 새로 깔아줘야 할때.

          _tempModel.newMessagesList = [];
          _tempModel.oldMessagesList = _tempList;
          _tempModel.newMessagesCount = 0;
        } else if (attachType == "ADD") {
          _tempModel.oldMessagesList = [
            ..._tempModel.oldMessagesList,
            ..._tempList
          ];
        }
      } else if (attachTo == "NEW") {
        if (attachType == "OVERWRITE") {
          // 새 메세지를 오버라이트 하는 경우는 아직 없는듯?
        } else if (attachType == "ADD") {
          // 새 메세지가 혹시 내가 보낸거면 tempClientId 로 필터 한번 해주자.
          // tempClientId 는 유니크하고 하나만 있다고 가정
          for (ChatMessageModel _curMes in _tempList) {
            _tempModel.newMessagesList.removeWhere((element) =>
                element.tempClientId.isNotEmpty &&
                element.tempClientId == _curMes.tempClientId);
          }

          _tempModel.newMessagesList = [
            ..._tempList,
            ..._tempModel.newMessagesList,
          ];

          if (addUpBadge) {
            _tempModel.newMessagesCount++;
          }
        }
      }

      // 볼일 다 끝났으면 이제 교체해준다.
      chatListMap[chatRoomId] = _tempModel;
    }

    checkLatestMessageSK(chatRoomId); // 새 메세지 받아올때 기준점 제시
  }

  checkLatestMessageSK(String chatRoomId) {
    List<ChatMessageModel> _curNewMessagesList =
        chatListMap[chatRoomId]!.newMessagesList;
    List<ChatMessageModel> _curOldMessagesList =
        chatListMap[chatRoomId]!.oldMessagesList;

    if (_curNewMessagesList.isNotEmpty) {
      chatListMap[chatRoomId]!.latestMessageSK =
          _curNewMessagesList[0].skCollection;
    } else if (_curOldMessagesList.isNotEmpty) {
      chatListMap[chatRoomId]!.latestMessageSK =
          _curOldMessagesList[0].skCollection;
    }
  }

  sendMessage(String chatRoomId, String message) async {
    // 메세지를 보낼때 clientId 를 같이 보내서, 내가 보낸 메세지를 구분지어준다.
    // 나중에 getMessage 할때 필터링 해주도록 하자.
    //debugPrint('Sending Message: ${message}');
    String randomCode = generateRandomCode(20);

    // 먼저 로컬로 메세지를 만들어서 리스트에 넣어서 보여주자.
    // 기본적으로 메세지를 리스트에 보여주는데 필요한것만 있으면 된다.
    chatListMap[chatRoomId] = ChatCompModel(
      chatRoomData: chatListMap[chatRoomId]!.chatRoomData,
      oldMessagesList: chatListMap[chatRoomId]!.oldMessagesList,
      newMessagesList: [
        ...[
          ChatMessageModel(
            chatRoomId: chatRoomId,
            message: message,
            createdEpoch: DateTime.now().millisecondsSinceEpoch,
            sentFrom: gc.currentUser.userId,
            tempClientId: randomCode,
            isLocalMessage: true,
          )
        ],
        ...chatListMap[chatRoomId]!.newMessagesList,
      ],
      lastEvaluatedKey: chatListMap[chatRoomId]!.lastEvaluatedKey,
      latestMessageSK: chatListMap[chatRoomId]!.latestMessageSK,
    );

    // 이제 API 불러서 진짜 메세지 보내준다.
    try {
      Map result = await messengerRepo.sendMessage(
        gc.currentUser.userId,
        chatRoomId,
        message,
        randomCode,
      );

      // 메세지가 성공적으로 갔을때...는 아무것도 하게 없지만,
      // 전송이 실패 하면 그 다음 할것이 있다. (다시 보내기랄지...)
      if (result.isNotEmpty && result['statusCode'] == 200) {
        // TODO:
      }
    } catch (e) {
      debugPrint('Error sending a new message: ${e.toString()}');
    }
  }

  String generateRandomCode(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );
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
