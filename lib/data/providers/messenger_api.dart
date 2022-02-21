import 'package:flutter_life_devo_app_v2/data/providers/global_api.dart';

const baseUrlDev = "https://api.bclifedevo.com/";
const apiUrlGetMyChatRooms = "messenger/chatRoom/getChatRoomListByUser";

class MessengerAPIClient {
  static getChatRoomListByUser(String userId) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlGetMyChatRooms, {"username": userId});
  }
}
