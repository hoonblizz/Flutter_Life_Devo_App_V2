import 'package:flutter_life_devo_app_v2/data/providers/global_api.dart';

const baseUrlDev = "https://api.bclifedevo.com/";
// Life devo session APIs
const apiUrlGetLatestLifeDevoSession =
    "admin/lifeDevoSession/getLatestLifeDevoSession";
const apiUrlSearchLifeDevoSession =
    "admin/lifeDevoSession/searchLifeDevoSession";

// Live Life devo APIs
const apiUrlGetLatestLiveLifeDevo = "admin/liveLifeDevo/getLatestLiveLifeDevo";

class AdminContentsAPIClient {
  static getLatestLifeDevoSession() async {
    return await GlobalAPIClient.getRequest(
        baseUrlDev + apiUrlGetLatestLifeDevoSession);
  }

  static getAllLifeDevoSession(int startDateFrom, int startDateTo) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlSearchLifeDevoSession,
        {"startDateFrom": startDateFrom, "startDateTo": startDateTo});
  }

  static getLatestLiveLifeDevo() async {
    return await GlobalAPIClient.getRequest(
        baseUrlDev + apiUrlGetLatestLiveLifeDevo);
  }
}
