import 'package:flutter_life_devo_app_v2/data/providers/global_api.dart';

const baseUrlDev = "https://api.bclifedevo.com/";
const apiUrlGetMyChatRooms = "messenger/chatRoom/getChatRoomListByUser";
const apiUrlGetMessage = "messenger/message/getMessage";
const apiUrlCreateMessage = "messenger/message/createMessage";

class MessengerAPIClient {
  static getChatRoomListByUser(String userId) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlGetMyChatRooms, {"username": userId});
  }

  static getMessage(
    String chatRoomId,
    String username, {
    bool oldToNew = false,
    Map lastEvaluatedKey = const {},
    String messageUntilKey = "",
    int? maxNumOfMessages,
  }) async {
    return await GlobalAPIClient.postRequest(baseUrlDev + apiUrlGetMessage, {
      "chatRoomId": chatRoomId,
      "username": username,
      "oldToNew": oldToNew,
      "lastEvaluatedKey": lastEvaluatedKey.isEmpty ? null : lastEvaluatedKey,
      "messageUntilKey": messageUntilKey, // nullable 이 아니고 빈 스트링이 들어가야한다.
      "maxNumOfMessages": maxNumOfMessages
    });
  }

  static sendMessage(String myUserId, String chatRoomId, String message,
      String tempClientId) async {
    return await GlobalAPIClient.postRequest(baseUrlDev + apiUrlCreateMessage, {
      "chatRoomId": chatRoomId,
      "usernameSender": myUserId,
      "message": message,
      "tempClientId": tempClientId,
    });
  }
}
