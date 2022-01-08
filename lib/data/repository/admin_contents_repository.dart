import 'package:flutter_life_devo_app_v2/data/providers/admin_contents_api.dart';

class AdminContentsRepository {
  Future getLatestLifeDevoSession() async {
    return await AdminContentsAPIClient.getLatestLifeDevoSession();
  }

  Future getLatestLiveLifeDevo() async {
    return await AdminContentsAPIClient.getLatestLiveLifeDevo();
  }
}
