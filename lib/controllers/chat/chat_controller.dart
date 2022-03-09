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

  // Chat messages
  RxBool isChatMessagesLoading = false.obs;
  List<List<ChatMessageModel>> _chatMessagesList = []; // 2D
  RxList<ChatMessageModel> chatMessagesListMerged =
      <ChatMessageModel>[].obs; // 1D
  List<Map> lastEvaluatedKeyList = [];
  ScrollController scrollController = ScrollController();

  scrollListener(String chatRoomId) {
    scrollController.addListener(() {
      debugPrint('Notified?');
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (isTop) {
          debugPrint('[$chatRoomId] Scroll at the top');
        } else {
          debugPrint('[$chatRoomId] Scroll at the bottom');
          //getComments();
          // 코멘트 로딩을 보여주려면 좀더 내려가야함. -> 근데 이거 하면 bottom 에 한번 더 도달해서 코멘트를 두번 부르게 된다.
          //_scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

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
      //debugPrint('Result getting chat room: ${result.toString()}');
      if (result.isNotEmpty && result['statusCode'] == 200) {
        //List<ChatRoomModel> _tempList = [];
        for (int x = 0; x < result['body'].length; x++) {
          _tempChatRoomList.add(ChatRoomModel.fromJSON(result['body'][x]));
        }
        //_tempChatRoomList = _tempList;
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

    //debugPrint('User id collected: ${_userIdList.toString()}');

    // 유저정보들 한꺼번에 받아서 각각의 채팅방 정보에 붙여넣기
    try {
      Map result =
          await userContentRepo.searchUserByUserId(_userIdList.toList());
      //debugPrint('Result getting user data: ${result.toString()}');

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
    chatRoomList.value = List<ChatRoomModel>.from(_tempChatRoomList);
  }

  startMessageLoading() {
    isChatMessagesLoading.value = true;
  }

  stopMessageLoading() {
    isChatMessagesLoading.value = false;
  }

  mergeContentsList() {
    chatMessagesListMerged.value = _chatMessagesList
        .expand((element) => element)
        .toList(); // Flatten to 1D
  }

  getMessages(String chatRoomId,
      {bool oldToNew = false, lastEvaluatedKey = const {}}) async {
    startMessageLoading();
    debugPrint('Chatroom: $chatRoomId, user: ${gc.currentUser.userId}');
    // 마지막 evaluated key 구하기
    int lastContentIndex = lastEvaluatedKeyList.length - 1;
    Map latestEvalKey = {};
    if (lastContentIndex > -1) {
      latestEvalKey = lastEvaluatedKeyList[lastContentIndex];
    }

    List<ChatMessageModel> _tempList = [];

    try {
      Map result = await messengerRepo.getMessage(
          chatRoomId, gc.currentUser.userId, oldToNew, lastEvaluatedKey);
      debugPrint('Get messages result: ${result.toString()}');
      if (result.isNotEmpty &&
          result['statusCode'] == 200 &&
          result['body']['messages'] != null) {
        for (int x = 0; x < result['body']['messages'].length; x++) {
          _tempList
              .add(ChatMessageModel.fromJSON(result['body']['messages'][x]));
        }
      }

      // oldToNew = false 면 최신부터 나오므로 순서를 뒤집어주자
      _tempList.sort((a, b) => a.createdEpoch.compareTo(b.createdEpoch));

      // Pagination key 등록
      // LEK 크기가 같거나 작다는건, 아직 등록이 안되었고 등록할 필요가 있다는 뜻.
      // 그게 아니면 이미 불러졌던 키라는 뜻.
      // 키 갯수는 항상 메세지수보다 적기때문.
      if (result['body']['exclusiveStartKey'] != null &&
          lastEvaluatedKeyList.length <= _chatMessagesList.length) {
        lastEvaluatedKeyList.add(result['body']['exclusiveStartKey']);
      }

      if (lastEvaluatedKeyList.isEmpty) {
        // 여기에 오는건 컨텐츠가 없거나 컨텐츠가 적을때. 전체 리스트를 세팅해준다.
        debugPrint('Adding more contents');
        _chatMessagesList
            .assign(List<ChatMessageModel>.from(_tempList)); // Deep copy
      } else {
        // 해당 인덱스가 존재하는지 확인. map 으로 바꿔서 확인.
        // -> 가장 마지막 키값을 반복적으로 부르는걸 방지.
        if (_chatMessagesList
            .asMap()
            .containsKey(lastEvaluatedKeyList.length)) {
          debugPrint('Replacing contents');
          _chatMessagesList[lastEvaluatedKeyList.length]
              .assignAll(List<ChatMessageModel>.from(_tempList));
        } else {
          debugPrint('Adding contents because its new');
          _chatMessagesList.add(List<ChatMessageModel>.from(_tempList));
        }
      }

      mergeContentsList(); // 2D -> 1D 로

    } catch (e) {
      debugPrint('Error getting message data: ${e.toString()}');
    }

    await Future.delayed(const Duration(milliseconds: 500)); // 렌더링 기다려준다.
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    await Future.delayed(const Duration(milliseconds: 500)); // 스크롤 기다려준다.

    stopMessageLoading();
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
