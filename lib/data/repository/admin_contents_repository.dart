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
  Future getAllLiveLifeDevo(Map? exclusiveStartKey) async {
    return await AdminContentsAPIClient.getAllLiveLifeDevo(exclusiveStartKey);
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

  /// **********************************************************************
  /// Sermon
  /// **********************************************************************
  static getAllSermon(Map? exclusiveStartKey) async {
    return await AdminContentsAPIClient.getAllSermon(exclusiveStartKey);
  }
}
