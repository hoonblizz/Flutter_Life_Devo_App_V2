class Session {
  final String pkCollection;
  final String skCollection;
  final int sessionNum;
  final String title;
  final String scripture;
  final String question;
  final DateTime created;
  final DateTime startDate;
  final int startDateEpoch;
  final DateTime endDate;
  final int endDateEpoch;
  final bool active;
  final String question2;
  final String question3;

  Session(
      {required this.pkCollection,
      required this.skCollection,
      this.sessionNum = 0,
      this.title = "",
      this.scripture = "",
      this.question = "",
      DateTime? created,
      DateTime? startDate,
      this.startDateEpoch = 0,
      DateTime? endDate,
      this.endDateEpoch = 0,
      this.active = false,
      this.question2 = "",
      this.question3 = ""})
      : created = created ?? DateTime.now(),
        startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now();

  factory Session.fromJSON(Map map) {
    //print('[SESSION] Received: ${map}');

    return Session(
      pkCollection: map['pkCollection'] ?? '',
      skCollection: map['skCollection'] ?? '',
      sessionNum: map['sessionNum'] ?? '',
      title: map['title'] ?? '',
      scripture: map['scripture'] ?? '',
      question: map['question'] ?? '',
      created: map['created'].toDate() ??
          DateTime.now(), // June 13, 2020 at 12:41:05 AM UTC-4 이런 포멧이다.
      startDate: map['startDate'].toDate() ?? DateTime.now(),
      startDateEpoch:
          map['startDateEpoch'] ?? DateTime.now().millisecondsSinceEpoch,
      endDate: map['endDate'].toDate() ?? DateTime.now(),
      endDateEpoch:
          map['endDateEpoch'] ?? DateTime.now().millisecondsSinceEpoch,
      active: map['active'] ?? false,
      question2: map['question2'] ?? '',
      question3: map['question3'] ?? '',
    );
  }
}
