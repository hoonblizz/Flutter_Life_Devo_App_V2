/*
  Life devo 에 종속되는 코멘트 모델
*/

import 'package:flutter_life_devo_app_v2/models/user_model.dart';

class FriendRequestModel {
  String pkCollection;
  String skCollection; // email
  String toUserId;
  late User toUser;
  String fromUserId;
  late User fromUser;
  String status;
  int lastModifiedEpoch;
  int createdEpoch;

  FriendRequestModel({
    this.pkCollection = "",
    this.skCollection = "",
    this.toUserId = "",
    this.fromUserId = "",
    this.status = "",
    this.lastModifiedEpoch = 0,
    this.createdEpoch = 0,
  });

  factory FriendRequestModel.fromJSON(Map map) {
    return FriendRequestModel(
      pkCollection: map['pkCollection'] ?? "",
      skCollection: map['skCollection'] ?? "",
      toUserId: map['toUserId'] ?? "",
      fromUserId: map['fromUserId'] ?? "",
      status: map['status'] ?? "",
      lastModifiedEpoch: map['lastModifiedEpoch'] ?? 0,
      createdEpoch: map['createdEpoch'] ?? 0,
    );
  }
}
