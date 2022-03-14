import 'package:flutter_life_devo_app_v2/data/providers/messenger_api.dart';

class MessengerRepository {
  Future getChatRoomListByUser(String userId) async {
    return await MessengerAPIClient.getChatRoomListByUser(userId);
  }

  Future getMessage(
    String chatRoomId,
    String username, {
    bool oldToNew = false,
    Map lastEvaluatedKey = const {},
    String messageUntilKey = "",
    int? maxNumOfMessages,
  }) async {
    return await MessengerAPIClient.getMessage(
      chatRoomId,
      username,
      oldToNew: oldToNew,
      lastEvaluatedKey: lastEvaluatedKey,
      messageUntilKey: messageUntilKey,
      maxNumOfMessages: maxNumOfMessages,
    );
  }

  Future sendMessage(String myUserId, String chatRoomId, String message,
      String tempClientId) async {
    return await MessengerAPIClient.sendMessage(
      myUserId,
      chatRoomId,
      message,
      tempClientId,
    );
  }
}
