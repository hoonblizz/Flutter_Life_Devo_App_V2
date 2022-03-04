import 'package:flutter_life_devo_app_v2/data/providers/admin_contents_api.dart';

class AdminContentsRepository {
  /// **********************************************************************
  /// Life Devo
  /// **********************************************************************
  Future getLatestLifeDevoSession() async {
    return await AdminContentsAPIClient.getLatestLifeDevoSession();
  }

  Future getAllLifeDevoSession(int startDateFrom, int startDateTo) async {
    return await AdminContentsAPIClient.getAllLifeDevoSession(
        startDateFrom, startDateTo);
  }

  /// **********************************************************************
  /// Live Life Devo:
  /// **********************************************************************
  Future getAllLiveLifeDevo([Map exclusiveStartKey = const {}]) async {
    return await AdminContentsAPIClient.getAllLiveLifeDevo(exclusiveStartKey);
  }

  Future getLiveLifeDevo(String skCollection) async {
    return await AdminContentsAPIClient.getLiveLifeDevo(skCollection);
  }

  /// **********************************************************************
  /// Dicipline Topic
  /// **********************************************************************
  Future getDisciplineTopic() async {
    return await AdminContentsAPIClient.getDisciplineTopic();
  }

  /// **********************************************************************
  /// Discipline
  /// **********************************************************************
  Future getAllDiscipline(String selectedTopic) async {
    return await AdminContentsAPIClient.getAllDiscipline(selectedTopic);
  }

  Future getDiscipline(String skCollection) async {
    return await AdminContentsAPIClient.getDiscipline(skCollection);
  }

  /// **********************************************************************
  /// Sermon
  /// **********************************************************************
  Future getAllSermon([Map exclusiveStartKey = const {}]) async {
    return await AdminContentsAPIClient.getAllSermon(exclusiveStartKey);
  }

  Future getSermon(String skCollection) async {
    return await AdminContentsAPIClient.getSermon(skCollection);
  }
}
