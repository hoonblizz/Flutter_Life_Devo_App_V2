class SampleModel {
  late int id;
  String? title;
  String? body;

  SampleModel({
    required this.id,
    this.title,
    this.body,
  });

  SampleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =
        <String, dynamic>{}; // It was like, Map<String, dynamic>()
    data['name'] = title;
    data['body'] = body;
    return data;
  }
}
