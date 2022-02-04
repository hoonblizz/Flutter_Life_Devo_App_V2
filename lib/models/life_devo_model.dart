import 'dart:convert';

class LifeDevoModel {
  String pkCollection;
  String skCollection;
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

  LifeDevoModel(
      {this.pkCollection = "",
      this.skCollection = "",
      this.answer = "",
      this.meditation = "",
      this.note = "",
      this.sessionId = "",
      this.createdBy = "",
      this.lastModified = "",
      this.lastModifiedEpoch = 0,
      this.shared = const [],
      this.answer2 = "",
      this.answer3 = ""});

  factory LifeDevoModel.fromJSON(Map map) {
    // 특수문자가 안나올수 있기 때문에, conversion 필요
    String newAnswer = map['answer'] != null
        ? const Utf8Decoder().convert(map['answer'].toString().codeUnits)
        : '';

    String newAnswer2 = map['answer2'] != null
        ? const Utf8Decoder().convert(map['answer2'].toString().codeUnits)
        : '';

    String newAnswer3 = map['answer3'] != null
        ? const Utf8Decoder().convert(map['answer3'].toString().codeUnits)
        : '';

    String newMeditation = map['meditation'] != null
        ? const Utf8Decoder().convert(map['meditation'].toString().codeUnits)
        : '';

    String newNote = map['note'] != null
        ? const Utf8Decoder().convert(map['note'].toString().codeUnits)
        : '';

    return LifeDevoModel(
      pkCollection: map['pkCollection'] ?? '',
      skCollection: map['skCollection'] ?? '',
      answer: newAnswer,
      meditation: newMeditation,
      note: newNote,
      sessionId: map['sessionId'] ?? '',
      createdBy: map['createdBy'] ?? '',
      lastModified: map['lastModified'] ?? '',
      lastModifiedEpoch: map['lastModifiedEpoch'] ?? '',
      shared: map['shared'] ?? [],
      answer2: newAnswer2,
      answer3: newAnswer3,
    );
  }

  Map toJSON() {
    return {
      "pkCollection": pkCollection,
      "skCollection": skCollection,
      "answer": answer,
      "meditation": meditation,
      "note": note,
      "sessionId": sessionId,
      "createdBy": createdBy,
      "lastModified": lastModified,
      "lastModifiedEpoch": lastModifiedEpoch,
      "shared": shared,
      "answer2": answer2,
      "answer3": answer3,
    };
  }
}
