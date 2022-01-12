import 'package:flutter_life_devo_app_v2/data/providers/user_contents_api.dart';

class UserContentsRepository {
  Future getLifeDevo(String skCollection) async {
    return await UserContentsAPIClient.getLifeDevo(skCollection);
  }

  Future updateLifeDevo(String skCollection,
      [String? answer,
      String? answer2,
      String? answer3,
      String? meditation,
      String? note,
      List? shared]) async {
    return await UserContentsAPIClient.updateLifeDevo(
        skCollection, answer, answer2, answer3, meditation, note, shared);
  }
  // Future getLatestLifeDevoSession() async {
  //   return await AdminContentsAPIClient.getLatestLifeDevoSession();
  // }

  // Future getLatestLiveLifeDevo() async {
  //   return await AdminContentsAPIClient.getLatestLiveLifeDevo();
  // }
}
