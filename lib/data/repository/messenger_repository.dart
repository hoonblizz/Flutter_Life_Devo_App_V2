import 'package:flutter_life_devo_app_v2/data/providers/messenger_api.dart';

class MessengerRepository {
  Future getChatRoomListByUser(String userId) async {
    return await MessengerAPIClient.getChatRoomListByUser(userId);
  }
}
