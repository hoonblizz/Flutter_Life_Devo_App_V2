class LifeDevo {
  String pkCollection;
  String skCollection;
  String answer;
  String meditation;
  String note;
  String sessionId; // life devo session ID
  String createdBy;
  String lastModified;
  int lastModifiedEpoch;
  List shared;
  String answer2;
  String answer3;

  LifeDevo(
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

  factory LifeDevo.fromJSON(Map map) {
    return LifeDevo(
      pkCollection: map['pkCollection'] ?? '',
      skCollection: map['skCollection'] ?? '',
      answer: map['answer'] ?? '',
      meditation: map['meditation'] ?? '',
      note: map['note'] ?? '',
      sessionId: map['sessionId'] ?? '',
      createdBy: map['createdBy'] ?? '',
      lastModified: map['lastModified'] ?? '',
      lastModifiedEpoch: map['lastModifiedEpoch'] ?? '',
      shared: map['shared'] ?? [],
      answer2: map['answer2'] ?? '',
      answer3: map['answer3'] ?? '',
    );
  }

  Map toJSON() {
    return {
      pkCollection: pkCollection,
      skCollection: skCollection,
      answer: answer,
      meditation: meditation,
      note: note,
      sessionId: sessionId,
      createdBy: createdBy,
      lastModified: lastModified,
      lastModifiedEpoch: lastModifiedEpoch,
      shared: shared,
      answer2: answer2,
      answer3: answer3,
    };
  }
}
