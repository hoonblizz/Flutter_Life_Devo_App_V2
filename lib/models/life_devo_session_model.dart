class Session {
  final String pkCollection;
  final String skCollection;
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

  Session(
      {this.pkCollection = "",
      this.skCollection = "",
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
      this.question3 = ""})
      : startDate = startDate ?? "",
        endDate = endDate ?? "";

  factory Session.fromJSON(Map map) {
    //print('[SESSION] Received: ${map}');

    return Session(
      pkCollection: map['pkCollection'] ?? '',
      skCollection: map['skCollection'] ?? '',
      sessionNum: map['sessionNum'] ?? -1,
      title: map['title'] ?? '',
      scripture: map['scripture'] ?? '',
      question: map['question'] ?? '',
      created: map['created'] ?? -1, // 원래는 epoch 형태임
      startDate: map['startDate'] ?? "",
      startDateEpoch:
          map['startDateEpoch'] ?? DateTime.now().millisecondsSinceEpoch,
      endDate: map['endDate'] ?? "",
      endDateEpoch:
          map['endDateEpoch'] ?? DateTime.now().millisecondsSinceEpoch,
      active: map['active'] ?? false,
      question2: map['question2'] ?? '',
      question3: map['question3'] ?? '',
    );
  }
}
