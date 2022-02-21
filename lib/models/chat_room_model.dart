/*
  Life devo 에 종속되는 코멘트 모델
*/

import 'package:flutter_life_devo_app_v2/models/user_model.dart';

class ChatRoomModel {
  String pkCollection;
  String skCollection; // email
  String chatRoomId;
  List usernameList;
  List<User> userDataList; // 내가 대화하는 상대
  int lastMessageEventEpoch;
  int createdEpoch;

  ChatRoomModel({
    this.pkCollection = "",
    this.skCollection = "",
    this.chatRoomId = "",
    this.usernameList = const [],
    this.userDataList = const [],
    this.lastMessageEventEpoch = 0,
    this.createdEpoch = 0,
  });

  factory ChatRoomModel.fromJSON(Map map) {
    return ChatRoomModel(
      pkCollection: map['pkCollection'] ?? "",
      skCollection: map['skCollection'] ?? "",
      chatRoomId: map['chatRoomId'] ?? "",
      usernameList: map['usernameList'] ?? [],
      userDataList: [],
      lastMessageEventEpoch: map['lastMessageEventEpoch'] ?? 0,
      createdEpoch: map['createdEpoch'] ?? 0,
    );
  }
}
