import 'package:flutter_life_devo_app_v2/data/providers/admin_contents_api.dart';

class AdminContentsRepository {
  Future getLatestLifeDevoSession() async {
    return await AdminContentsAPIClient.getLatestLifeDevoSession();
  }

  Future getAllLifeDevoSession(int startDateFrom, int startDateTo) async {
    return await AdminContentsAPIClient.getAllLifeDevoSession(
        startDateFrom, startDateTo);
  }

  Future getLatestLiveLifeDevo() async {
    return await AdminContentsAPIClient.getLatestLiveLifeDevo();
  }
}
