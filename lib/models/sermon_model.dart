import 'dart:convert';

class SermonModel {
  final String pkCollection;
  final String skCollection;
  final String id;
  final String title;
  final String contentText;
  final String videoUrl;
  final String videoId;
  final String thumbnailUrl;
  final DateTime created;
  final DateTime selectedDate;

  SermonModel({
    this.pkCollection = "",
    this.skCollection = "",
    this.id = "",
    this.title = "",
    this.contentText = "",
    this.videoUrl = "",
    this.videoId = "",
    this.thumbnailUrl = "",
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

    // Youtube 비디오 주소가 있으면 parse 해서 썸네일까지 뽑아낸다.
    String videoId = "";
    String thumbnailUrl = "";
    if (map['url'] != null &&
        map['url'] != "" &&
        map['url'].contains('https://www.youtube.com/')) {
      var parsedUri = Uri.parse(map['url']);
      parsedUri.queryParameters.forEach((key, value) {
        if (key == "v") {
          videoId = value;
          thumbnailUrl = "https://img.youtube.com/vi/$value/hqdefault.jpg";
        }
      });
    }

    return SermonModel(
      pkCollection: map['pkCollection'] ?? '',
      skCollection: map['skCollection'] ?? '',
      id: map['id'] ?? '',
      title: newTitle,
      contentText: newContentText,
      videoUrl:
          map['url'] != null && map['url'].contains('https://www.youtube.com/')
              ? map['url']
              : '',
      videoId: videoId,
      thumbnailUrl: thumbnailUrl,
      created: map['created'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['created'])
          : DateTime.now(),
      selectedDate: map['selectedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['selectedDate'])
          : DateTime.now(),
    );
  }
}
