import 'dart:convert';
import 'package:flutter_life_devo_app_v2/data/providers/global_api.dart';
import 'package:flutter_life_devo_app_v2/models/user_token_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const baseUrlDev = "https://api.bclifedevo.com/";
const apiUrlVerifyUserToken = "user/auth/verifyUserToken";
const apiUrlGetUserBySystemId = "user/auth/getUserBySystemId";
const apiUrlLogin = "user/auth/login";
const keyUserToken = "USER_TOKEN";

class AuthAPIClient {
  //AuthAPIClient();

  static Future<UserTokenModel> getUserTokenFromLocal() async {
    // Call shared preference instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the token
    String userTokenString = prefs.getString(keyUserToken) ?? "";

    if (userTokenString.isNotEmpty) {
      // Parse the string
      try {
        Map<String, dynamic> userTokenParsed = jsonDecode(userTokenString);
        return UserTokenModel.fromJson(userTokenParsed);
      } catch (e) {
        // Issue with the token (Maybe wrong format somehow). Reset.
        bool removeDone = await prefs.remove(keyUserToken);
        // ignore: avoid_print
        print('Remove done: $removeDone');
      }
    }

    return UserTokenModel();
  }

  static setUserTokenToLocal(UserTokenModel token) async {
    // Call shared preference instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert to JSON -> String
    String tokenInString = jsonEncode(token.toJson());
    return await prefs.setString(keyUserToken, tokenInString);
  }

  static checkUserTokenIsValid(UserTokenModel userTokenModel) async {
    /*
      Example response:
      {
        "username": "",
        "clientId": "",
        "e": {
            "name": "TokenExpiredError",
            "message": "jwt expired",
            "expiredAt": "2021-09-28T18:48:31.000Z"
        },
        "isValid": false
      }
    */
    return await GlobalAPIClient.postRequest(
      baseUrlDev + apiUrlVerifyUserToken,
      {'token': userTokenModel.accessToken},
    );
  }

  static login(String username, String password) async {
    // Wait for better looking UI
    await Future.delayed(const Duration(seconds: 1));

    return await GlobalAPIClient.postRequest(
      baseUrlDev + apiUrlLogin,
      {'username': username, 'password': password},
    );
  }

  static getUserDataBySystemId(String systemId) async {
    return await GlobalAPIClient.postRequest(
      baseUrlDev + apiUrlGetUserBySystemId,
      {'systemId': systemId},
    );
  }

  /// **********************************************************************
  /// Private functions
  /// **********************************************************************

}
