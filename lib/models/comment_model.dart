/*
  Life devo 에 종속되는 코멘트 모델
*/

import 'dart:convert';

class CommentModel {
  String pkCollection;
  String skCollection; // email
  String content;
  String userId;
  int lastModifiedEpoch;
  int createdEpoch;
  String userName; // 유저 찾기 후에 여기에 붙여넣는다.
  String userProfileImageUrl;

  CommentModel({
    this.pkCollection = "",
    this.skCollection = "",
    this.content = "",
    this.userId = "",
    this.lastModifiedEpoch = 0,
    this.createdEpoch = 0,
    this.userName = "",
    this.userProfileImageUrl = "",
  });

  factory CommentModel.fromJSON(Map map) {
    String newContent = map['content'] != null
        ? const Utf8Decoder().convert(map['content'].toString().codeUnits)
        : '';

    return CommentModel(
      pkCollection: map['pkCollection'],
      skCollection: map['skCollection'],
      content: newContent,
      userId: map['userId'],
      lastModifiedEpoch: map['lastModifiedEpoch'],
      createdEpoch: map['createdEpoch'],
    );
  }
}
