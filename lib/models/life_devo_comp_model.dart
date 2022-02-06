/*
  편의를 위해 만든 composite model. 
  Life devo, session 을 합쳤다.
  각각의 모델에서 기본값들 왠만한건 다 해결했으니 그냥 합쳐주기만 하자
*/

import 'package:flutter_life_devo_app_v2/models/life_devo_model.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_session_model.dart';

class LifeDevoCompModel {
  // From Life devo session
  final String pkCollectionSession;
  final String skCollectionSession;
  final int sessionNum;
  final String title;
  final String scripture;
  final String question;
  final int created;
  final String startDate;
  final int startDateEpoch;
  final String endDate;
  final int endDateEpoch;
  final bool active;
  final String question2;
  final String question3;
  final String id; // 해당 admin life devo 의 세션 id

  // From life devo
  String pkCollectionLifeDevo;
  String skCollectionLifeDevo;
  String answer;
  String meditation;
  String note;
  String sessionId; // life devo session ID
  String createdBy; // User id. NOT system id!
  String lastModified;
  int lastModifiedEpoch;
  List shared;
  String answer2;
  String answer3;

  LifeDevoCompModel(
      {this.pkCollectionSession = "",
      this.skCollectionSession = "",
      this.sessionNum = 0,
      this.title = "",
      this.scripture = "",
      this.question = "",
      //DateTime? created,
      this.created = 0,
      String? startDate,
      this.startDateEpoch = 0,
      String? endDate,
      this.endDateEpoch = 0,
      this.active = false,
      this.question2 = "",
      this.question3 = "",
      this.id = "",
      // From Life devo
      this.pkCollectionLifeDevo = "",
      this.skCollectionLifeDevo = "",
      this.answer = "",
      this.meditation = "",
      this.note = "",
      this.sessionId = "",
      this.createdBy = "",
      this.lastModified = "",
      this.lastModifiedEpoch = 0,
      this.shared = const [],
      this.answer2 = "",
      this.answer3 = ""})
      : startDate = startDate ?? "",
        endDate = endDate ?? "";

  factory LifeDevoCompModel.generate(
      LifeDevoSessionModel session, LifeDevoModel lifeDevo) {
    return LifeDevoCompModel(
      // From Life devo session
      pkCollectionSession: session.pkCollection,
      skCollectionSession: session.skCollection,
      sessionNum: session.sessionNum,
      title: session.title,
      scripture: session.scripture,
      question: session.question,
      created: session.created, // 원래는 epoch 형태임
      startDate: session.startDate,
      startDateEpoch: session.startDateEpoch,
      endDate: session.endDate,
      endDateEpoch: session.endDateEpoch,
      active: session.active,
      question2: session.question2,
      question3: session.question3,
      id: session.id,

      // From Life devo
      pkCollectionLifeDevo: lifeDevo.pkCollection,
      skCollectionLifeDevo: lifeDevo.skCollection,
      answer: lifeDevo.answer,
      meditation: lifeDevo.meditation,
      note: lifeDevo.note,
      sessionId: lifeDevo.sessionId,
      createdBy: lifeDevo.createdBy,
      lastModified: lifeDevo.lastModified,
      lastModifiedEpoch: lifeDevo.lastModifiedEpoch,
      shared: lifeDevo.shared,
      answer2: lifeDevo.answer2,
      answer3: lifeDevo.answer3,
    );
  }

  LifeDevoModel toLifeDevoModel(LifeDevoCompModel model) {
    return LifeDevoModel(
      pkCollection: model.pkCollectionLifeDevo,
      skCollection: model.skCollectionLifeDevo,
      answer: model.answer,
      meditation: model.meditation,
      note: model.note,
      sessionId: model.sessionId,
      createdBy: model.createdBy,
      lastModified: model.lastModified,
      lastModifiedEpoch: model.lastModifiedEpoch,
      shared: model.shared,
      answer2: model.answer2,
      answer3: model.answer3,
    );
  }
}
