import 'package:flutter_life_devo_app_v2/data/providers/user_contents_api.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_model.dart';

class UserContentsRepository {
  Future getLifeDevo(String skCollection) async {
    return await UserContentsAPIClient.getLifeDevo(skCollection);
  }

  Future createLifeDevo(LifeDevoModel lifedevo) async {
    return await UserContentsAPIClient.createLifeDevo(lifedevo);
  }

  Future updateLifeDevo(LifeDevoModel lifedevo) async {
    return await UserContentsAPIClient.updateLifeDevo(lifedevo);
  }
  // Future getLatestLifeDevoSession() async {
  //   return await AdminContentsAPIClient.getLatestLifeDevoSession();
  // }

  // Future getLatestLiveLifeDevo() async {
  //   return await AdminContentsAPIClient.getLatestLiveLifeDevo();
  // }

  Future getMyLifeDevo(String userId, List sessionIdList) async {
    return await UserContentsAPIClient.getMyLifeDevo(userId, sessionIdList);
  }

  Future getSharedLifeDevo(String userId, List sessionIdList) async {
    return await UserContentsAPIClient.getMyLifeDevo(userId, sessionIdList);
  }
}
