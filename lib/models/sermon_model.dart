import 'dart:convert';

class SermonModel {
  final String pkCollection;
  final String skCollection;
  final String id;
  final String title;
  final String contentText;
  final String videoUrl;
  final DateTime created;
  final DateTime selectedDate;

  SermonModel({
    required this.pkCollection,
    required this.skCollection,
    this.id = "",
    this.title = "",
    this.contentText = "",
    this.videoUrl = "",
    DateTime? created,
    DateTime? selectedDate,
  })  : created = created ?? DateTime.now(),
        selectedDate = selectedDate ?? DateTime.now();

  factory SermonModel.fromJSON(Map map) {
    // 특수문자가 안나올수 있기 때문에, conversion 필요
    String newTitle = map['title'] != null
        ? const Utf8Decoder().convert(map['title'].toString().codeUnits)
        : '';

    String newContentText = map['contentText'] != null
        ? const Utf8Decoder().convert(map['contentText'].toString().codeUnits)
        : '';

    return SermonModel(
      pkCollection: map['pkCollection'] ?? '',
      skCollection: map['skCollection'] ?? '',
      id: map['id'] ?? '',
      title: newTitle,
      contentText: newContentText,
      videoUrl: map['url'] ?? '',
      created: map['created'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['created'])
          : DateTime.now(),
      selectedDate: map['selectedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['selectedDate'])
          : DateTime.now(),
    );
  }
}
