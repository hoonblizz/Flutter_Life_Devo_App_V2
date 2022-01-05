class UserTokenModel {
  //late int id;
  String accessToken = "";
  String refreshToken = "";
  String idToken = "";
  String email =
      ""; // May know from the response of Login && VerifyUserToken API

  UserTokenModel({
    accessToken,
    refreshToken,
    idToken,
    email,
  });

  UserTokenModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['AccessToken'] ?? "";
    refreshToken = json['RefreshToken'] ?? "";
    idToken = json['IdToken'] ?? "";
    email = json['email'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =
        <String, dynamic>{}; // It was like, Map<String, dynamic>()
    data['AccessToken'] = accessToken;
    data['RefreshToken'] = refreshToken;
    data['IdToken'] = idToken;
    data['email'] = email;
    return data;
  }
}
