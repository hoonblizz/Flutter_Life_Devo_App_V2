import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/data/providers/global_api.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_model.dart';

const baseUrlDev = "https://api.bclifedevo.com/";
const apiUrlGetLifeDevo = "user/lifeDevo/getLifeDevo";
const apiUrlCreateLifeDevo = "user/lifeDevo/createLifeDevo";
const apiUrlUpdateLifeDevo = "user/lifeDevo/updateLifeDevo";
const apiUrlSearchLifeDevo = "user/lifeDevo/searchLifeDevo";
// Comments
const apiUrlCreateComment = "user/comment/createComment";
const apiUrlGetComment = "user/comment/getComment";
const apiUrlUpdateComment = "user/comment/updateComment";
const apiUrlDeleteComment = "user/comment/deleteComment";
// User
const apiUrlSearchUserByUserId = "user/user/searchUserByUserId";
// Friend Request
const apiUrlSearchFriendRequest = "user/friendRequest/searchFriendRequest";
const apiUrlCreateFriendRequest = "user/friendRequest/createFriendRequest";
const apiUrlUpdateFriendRequest = "user/friendRequest/updateFriendRequest";

class UserContentsAPIClient {
  static getLifeDevo(String skCollection) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlGetLifeDevo, {"skCollection": skCollection});
  }

  // 새로 만드는거라 여기에는 pk, sk collection 등 몇가지 데이터는 없다.
  static createLifeDevo(LifeDevoModel lifedevo) async {
    debugPrint('Life devo check before create: ${lifedevo.toJSON()}');
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlCreateLifeDevo, lifedevo.toJSON());
  }

  static updateLifeDevo(LifeDevoModel lifedevo) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlUpdateLifeDevo, lifedevo.toJSON());
  }

  static getMyLifeDevo(String userId, List sessionIdList) async {
    return GlobalAPIClient.postRequest(baseUrlDev + apiUrlSearchLifeDevo,
        {"userId": userId, "sessionIdList": sessionIdList});
  }

  static getSharedLifeDevo(String userId, List sessionIdList) async {
    return GlobalAPIClient.postRequest(baseUrlDev + apiUrlSearchLifeDevo,
        {"userId": userId, "sessionIdList": sessionIdList, "sharedToMe": true});
  }

  // ignore: slash_for_doc_comments
  /*****************************************************************
  * Comments
  *****************************************************************/
  static createComment(String sessionId, String userId, String content) async {
    return GlobalAPIClient.postRequest(baseUrlDev + apiUrlCreateComment,
        {"lifeDevoId": sessionId, "userId": userId, "content": content});
  }

  static getComment(String sessionId, Map exclusiveStartKey) async {
    Map param = {"lifeDevoId": sessionId};
    if (exclusiveStartKey.isNotEmpty) {
      param["exclusiveStartKey"] = exclusiveStartKey;
    }
    debugPrint('Param to get comments: ${param.toString()}');
    return GlobalAPIClient.postRequest(baseUrlDev + apiUrlGetComment, param);
  }

  static updateComment(
      String sessionId, String commentSkCollection, String content) async {
    return GlobalAPIClient.postRequest(baseUrlDev + apiUrlUpdateComment, {
      "lifeDevoId": sessionId,
      "commentSkCollection": commentSkCollection,
      "content": content
    });
  }

  static deleteComment(String sessionId, String commentSkCollection) async {
    return GlobalAPIClient.postRequest(baseUrlDev + apiUrlDeleteComment,
        {"lifeDevoId": sessionId, "commentSkCollection": commentSkCollection});
  }

  // ignore: slash_for_doc_comments
  /*****************************************************************
  * User
  *****************************************************************/
  static searchUserByUserId(List userIdList) async {
    return GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlSearchUserByUserId, {"userIdList": userIdList});
  }

  // ignore: slash_for_doc_comments
  /*****************************************************************
  * Friend Requests
  *****************************************************************/
  static getFriendRequest(String userId) async {
    return GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlSearchFriendRequest, {"userId": userId});
  }

  static createFriendRequest(String fromUserId, String toUserId) async {
    return GlobalAPIClient.postRequest(baseUrlDev + apiUrlCreateFriendRequest,
        {"fromUserId": fromUserId, "toUserId": toUserId});
  }

  static acceptFriendRequest(
      String requestSkCollection, String fromUserId, String toUserId) async {
    return GlobalAPIClient.postRequest(baseUrlDev + apiUrlUpdateFriendRequest, {
      "requestSkCollection": requestSkCollection,
      "status": "ACCEPTED",
      "fromUserId": fromUserId,
      "toUserId": toUserId
    });
  }

  static declineFriendRequest(String requestSkCollection) async {
    return GlobalAPIClient.postRequest(baseUrlDev + apiUrlUpdateFriendRequest,
        {"requestSkCollection": requestSkCollection, "status": "DECLINED"});
  }
}
