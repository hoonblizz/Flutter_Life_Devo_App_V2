import 'package:flutter_life_devo_app_v2/data/providers/global_api.dart';

const baseUrlDev = "https://api.bclifedevo.com/";
const apiUrlGetMyChatRooms = "messenger/chatRoom/getChatRoomListByUser";
const apiUrlGetMessage = "messenger/message/getMessage";

class MessengerAPIClient {
  static getChatRoomListByUser(String userId) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlGetMyChatRooms, {"username": userId});
  }

  static getMessage(String chatRoomId, String username,
      [bool oldToNew = false,
      Map lastEvaluatedKey = const {},
      String messageUntilKey = ""]) async {
    return await GlobalAPIClient.postRequest(baseUrlDev + apiUrlGetMessage, {
      "chatRoomId": chatRoomId,
      "username": username,
      "oldToNew": oldToNew,
      "lastEvaluatedKey": lastEvaluatedKey.isEmpty ? null : lastEvaluatedKey,
      "messageUntilKey": messageUntilKey, // nullable 이 아니고 빈 스트링이 들어가야한다.
    });
  }
}
