import 'package:flutter_life_devo_app_v2/data/providers/global_api.dart';

const baseUrlDev = "https://api.bclifedevo.com/";
const apiUrlGetLatestLifeDevoSession =
    "admin/lifeDevoSession/getLatestLifeDevoSession";
const apiUrlGetLatestLiveLifeDevo = "admin/liveLifeDevo/getLatestLiveLifeDevo";

class AdminContentsAPIClient {
  static getLatestLifeDevoSession() async {
    return await GlobalAPIClient.getRequest(
        baseUrlDev + apiUrlGetLatestLifeDevoSession);
    /*
          Sample response:
          {
              "statusCode": 200,
              "headers": {
                  "Access-Control-Allow-Origin": "*"
              },
              "message": "Get latest life devo session done!",
              "body": {
                  "active": true,
                  "pkCollection": "LIFE_DEVO_SESSION",
                  "created": 1637307606000,
                  "skCollection": "1637307606000#5dbIHFo5MSYq9iRAVELO",
                  "endDateEpoch": 1637384340000,
                  "id": "5dbIHFo5MSYq9iRAVELO",
                  "startDateEpoch": 1637298000000,
                  "title": "Jesus Casts Out A Demon (Fri)"
              }
          }
        */
  }

  static getLatestLiveLifeDevo() async {
    return await GlobalAPIClient.getRequest(
        baseUrlDev + apiUrlGetLatestLiveLifeDevo);
  }
}
