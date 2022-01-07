class LiveLifeDevo {
  final String pkCollection;
  final String skCollection;
  final String id;
  final String title;
  final String contentText;
  final String videoUrl;
  final DateTime created;
  final DateTime selectedDate;

  LiveLifeDevo({
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

  factory LiveLifeDevo.fromJSON(Map map) {
    return LiveLifeDevo(
      pkCollection: map['pkCollection'] ?? '',
      skCollection: map['skCollection'] ?? '',
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      contentText: map['contentText'] ?? '',
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
