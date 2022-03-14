/*
  
*/

//import 'package:flutter_life_devo_app_v2/models/user_model.dart';

import 'dart:convert';

class ChatMessageModel {
  String pkCollection;
  String skCollection;
  String chatRoomId;
  List sentTo;
  //List<User> userDataList; // sentTo 데이터를 유저 데이터로 쥐고 있는것. chatroom 에서 가져오면 된다.
  Map readBy;
  String messageId;
  int createdEpoch;
  String sentFrom;
  String message;
  String tempClientId;
  bool isLocalMessage; // 메세지 보낼때, 서버에서 가져온게 아니라 내가 일단 보낸 메세지인가

  ChatMessageModel({
    this.pkCollection = "",
    this.skCollection = "",
    this.chatRoomId = "",
    this.sentTo = const [],
    //this.userDataList = const [],
    this.readBy = const {},
    this.messageId = "",
    this.createdEpoch = 0,
    this.sentFrom = "",
    this.message = "",
    this.tempClientId = "",
    this.isLocalMessage = false,
  });

  factory ChatMessageModel.fromJSON(Map map) {
    String newMessage = map['message'] != null
        ? const Utf8Decoder().convert(map['message'].toString().codeUnits)
        : '';

    return ChatMessageModel(
      pkCollection: map['pkCollection'] ?? "",
      skCollection: map['skCollection'] ?? "",
      chatRoomId: map['chatRoomId'] ?? "",
      sentTo: map['sentTo'] ?? [],
      //userDataList: [],
      readBy: map['readBy'] ?? {},
      messageId: map['messageId'] ?? "",
      createdEpoch: map['createdEpoch'] ?? 0,
      sentFrom: map['sentFrom'] ?? "",
      message: newMessage,
      tempClientId: map['tempClientId'] ?? "",
      isLocalMessage: map['localMessage'] ?? false,
    );
  }
}
