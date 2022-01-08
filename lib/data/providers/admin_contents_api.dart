import 'package:flutter_life_devo_app_v2/data/providers/global_api.dart';

const baseUrlDev = "https://api.bclifedevo.com/";
const apiUrlGetLatestLifeDevoSession = "";
const apiUrlGetLatestLiveLifeDevo = "";

class AdminContentsAPIClient {
  static getLatestLifeDevoSession() async {
    return await GlobalAPIClient.getRequest(
        baseUrlDev + apiUrlGetLatestLifeDevoSession);
  }

  static getLatestLiveLifeDevo() async {
    return await GlobalAPIClient.getRequest(
        baseUrlDev + apiUrlGetLatestLiveLifeDevo);
  }
}
