/*
  Discipline Topic
*/

class DisciplineTopicModel {
  String pkCollection;
  String skCollection; // email
  List topicList;

  DisciplineTopicModel({
    this.pkCollection = "",
    this.skCollection = "",
    this.topicList = const [],
  });

  factory DisciplineTopicModel.fromJSON(Map map) {
    return DisciplineTopicModel(
      pkCollection: map['pkCollection'],
      skCollection: map['skCollection'],
      topicList: map['topicList'] ?? [],
    );
  }
}
