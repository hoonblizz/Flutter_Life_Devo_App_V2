/*
  유저 아이디가 두개가 있는데,  
  userId: 내가 만드는 아이디. 컨텐츠에 접근할때 사용되는 아이디. 
  (Firebase 에서 import 된 경우도 있고, 새로 만들면 nanoid 로 만들어진다.)   
  systemId: AWS Cognito 에서 생성해준 id.  
*/

class User {
  String pkCollection;
  String skCollection; // email
  bool fromFirebase;
  String systemId;
  String userId;
  String email;
  String name;
  bool sessionCreator;
  int created;
  String lastModified;
  List partners;

  User({
    this.pkCollection = "",
    this.skCollection = "",
    this.fromFirebase = false,
    this.systemId = "",
    this.userId = "",
    this.email = "",
    this.name = "",
    this.sessionCreator = false,
    this.created = 0,
    this.lastModified = "",
    this.partners = const [],
  });

  factory User.fromJSON(Map map) {
    return User(
      pkCollection: map['pkCollection'] ?? '',
      skCollection: map['skCollection'] ?? '',
      fromFirebase: map['fromFirebase'] ?? false,
      systemId: map['systemId'] ?? '',
      userId: map['userId'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      sessionCreator: map['sessionCreator'] ?? false,
      created: map['created'] ?? 0,
      lastModified: map['lastModified'] ?? '',
      partners: map['partners'] ?? [],
    );
  }
}
