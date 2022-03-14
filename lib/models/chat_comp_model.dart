/*
  채팅방 UI 구성에 쓰기 편하게 해놓은 composite 모델
*/

import 'dart:core';

import 'package:flutter_life_devo_app_v2/models/chat_message_model.dart';
import 'package:flutter_life_devo_app_v2/models/chat_room_model.dart';
import 'package:get/get.dart';

class ChatCompModel {
  final ChatRoomModel chatRoomData;
  List<ChatMessageModel> oldMessagesList; // 기존에 있던 메세지들
  List<ChatMessageModel> newMessagesList; // 리얼타임으로 새로 불러온 메세지들
  Map lastEvaluatedKey; // 더 올드 메세지로 가야할때 필요
  bool newMessageNumIsSmall; // 이제 안쓴다.
  String latestMessageSK;

  ChatCompModel(
      {required this.chatRoomData,
      this.oldMessagesList = const [],
      this.newMessagesList = const [],
      this.lastEvaluatedKey = const {},
      this.newMessageNumIsSmall = false,
      this.latestMessageSK = ""});

  factory ChatCompModel.generate(
    ChatRoomModel chatRoomData,
    List<ChatMessageModel> oldMessagesList,
    List<ChatMessageModel> newMessagesList,
    Map lastEvaluatedKey,
    String latestMessageSK,
  ) {
    return ChatCompModel(
      chatRoomData: chatRoomData,
      oldMessagesList: oldMessagesList,
      newMessagesList: newMessagesList,
      lastEvaluatedKey: lastEvaluatedKey,
      latestMessageSK: latestMessageSK,
    );
  }

  factory ChatCompModel.copyFrom(ChatCompModel _chatCompModel) {
    return ChatCompModel(
      chatRoomData: _chatCompModel.chatRoomData,
      oldMessagesList: _chatCompModel.oldMessagesList,
      newMessagesList: _chatCompModel.newMessagesList,
      lastEvaluatedKey: _chatCompModel.lastEvaluatedKey,
      latestMessageSK: _chatCompModel.latestMessageSK,
    );
  }
}
