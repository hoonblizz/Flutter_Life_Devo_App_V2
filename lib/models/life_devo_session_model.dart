import 'dart:convert';

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
    //Map map = jsonDecode(jsonEncode(tempMap));

    // 특수문자가 안나올수 있기 때문에, conversion 필요
    String newScripture = map['scripture'] != null
        ? const Utf8Decoder().convert(map['scripture'].toString().codeUnits)
        : '';

    String newQuestion1 = map['question'] != null
        ? const Utf8Decoder().convert(map['question'].toString().codeUnits)
        : '';
    String newQuestion2 = map['question2'] != null
        ? const Utf8Decoder().convert(map['question2'].toString().codeUnits)
        : '';
    String newQuestion3 = map['question2'] != null
        ? const Utf8Decoder().convert(map['question3'].toString().codeUnits)
        : '';

    return Session(
      pkCollection: map['pkCollection'] ?? '',
      skCollection: map['skCollection'] ?? '',
      sessionNum: map['sessionNum'] ?? -1,
      title: map['title'] ?? '',
      scripture: newScripture,
      question: newQuestion1,
      created: map['created'] ?? -1, // 원래는 epoch 형태임
      startDate: map['startDate'] ?? "",
      startDateEpoch:
          map['startDateEpoch'] ?? DateTime.now().millisecondsSinceEpoch,
      endDate: map['endDate'] ?? "",
      endDateEpoch:
          map['endDateEpoch'] ?? DateTime.now().millisecondsSinceEpoch,
      active: map['active'] ?? false,
      question2: newQuestion2,
      question3: newQuestion3,
    );
  }
}
