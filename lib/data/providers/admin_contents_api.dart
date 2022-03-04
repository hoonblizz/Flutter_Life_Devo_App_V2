import 'package:flutter_life_devo_app_v2/data/providers/global_api.dart';

const baseUrlDev = "https://api.bclifedevo.com/";
// Life devo session APIs
const apiUrlGetLatestLifeDevoSession =
    "admin/lifeDevoSession/getLatestLifeDevoSession";
const apiUrlSearchLifeDevoSession =
    "admin/lifeDevoSession/searchLifeDevoSession";

// Live Life devo APIs
const apiUrlGetAllLiveLifeDevo = "admin/liveLifeDevo/getAllLiveLifeDevo";
const apiUrlGetLiveLifeDevo = "admin/liveLifeDevo/getLiveLifeDevo";

// Discipline Topic
const apiUrlGetDisciplineTopic =
    "admin/disciplineTopic/getDisciplineTopic"; // Get request
// Discipline
const apiUrlGetAllDiscipline = "admin/discipline/getAllDiscipline";
const apiUrlGetDiscipline = "admin/discipline/getDiscipline";
// Sermon
const apiUrlGetAllSermon = "admin/sermon/getAllSermon";
const apiUrlGetSermon = "admin/sermon/getSermon";

class AdminContentsAPIClient {
  /// **********************************************************************
  /// Life Devo
  /// **********************************************************************
  static getLatestLifeDevoSession() async {
    return await GlobalAPIClient.getRequest(
        baseUrlDev + apiUrlGetLatestLifeDevoSession);
  }

  static getAllLifeDevoSession(int startDateFrom, int startDateTo) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlSearchLifeDevoSession,
        {"startDateFrom": startDateFrom, "startDateTo": startDateTo});
  }

  /// **********************************************************************
  /// Live Life Devo:
  /// 최근꺼는 전체에서 가장 첫번째만 불러온다.
  /// **********************************************************************
  static getAllLiveLifeDevo([Map exclusiveStartKey = const {}]) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlGetAllLiveLifeDevo, {
      "exclusiveStartKey": exclusiveStartKey.isEmpty ? null : exclusiveStartKey
    });
  }

  static getLiveLifeDevo(String skCollection) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlGetLiveLifeDevo, {"skCollection": skCollection});
  }

  /// **********************************************************************
  /// Dicipline Topic
  /// **********************************************************************
  static getDisciplineTopic() async {
    return await GlobalAPIClient.getRequest(
        baseUrlDev + apiUrlGetDisciplineTopic);
  }

  /// **********************************************************************
  /// Discipline
  /// Pagination 없는 해당 토픽에 대한 내용만 가져온다.
  /// **********************************************************************
  static getAllDiscipline([String selectedTopic = ""]) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlGetAllDiscipline,
        {"selectedTopic": selectedTopic.isEmpty ? null : selectedTopic});
  }

  static getDiscipline(String skCollection) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlGetDiscipline, {"skCollection": skCollection});
  }

  /// **********************************************************************
  /// Sermon
  /// **********************************************************************
  static getAllSermon([Map exclusiveStartKey = const {}]) async {
    return await GlobalAPIClient.postRequest(baseUrlDev + apiUrlGetAllSermon, {
      "exclusiveStartKey": exclusiveStartKey.isEmpty ? null : exclusiveStartKey
    });
  }

  static getSermon(String skCollection) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlGetSermon, {"skCollection": skCollection});
  }
}
