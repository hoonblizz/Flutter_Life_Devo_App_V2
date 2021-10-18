import 'package:flutter_life_devo_app_v2/data/providers/auth_api.dart';
import 'package:flutter_life_devo_app_v2/models/user_token_model.dart';

class AuthRepository {
  static AuthRepository instance = AuthRepository();

  Future getUserTokenFromLocal() async {
    return await AuthAPIClient.getUserTokenFromLocal();
  }

  Future setUserTokenToLocal(UserTokenModel userTokenModel) async {
    return await AuthAPIClient.setUserTokenToLocal(userTokenModel);
  }

  Future login(String username, String password) async {
    return await AuthAPIClient.login(username, password);
  }

  Future<Map<String, dynamic>> checkUserTokenIsValid(
      UserTokenModel userTokenModel) async {
    return await AuthAPIClient.checkUserTokenIsValid(userTokenModel);
  }
}
