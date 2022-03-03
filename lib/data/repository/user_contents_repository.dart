import 'package:flutter_life_devo_app_v2/data/providers/user_contents_api.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_model.dart';

class UserContentsRepository {
  Future getLifeDevo(String skCollection) async {
    return await UserContentsAPIClient.getLifeDevo(skCollection);
  }

  Future createLifeDevo(LifeDevoModel lifedevo) async {
    return await UserContentsAPIClient.createLifeDevo(lifedevo);
  }

  Future updateLifeDevo(LifeDevoModel lifedevo) async {
    return await UserContentsAPIClient.updateLifeDevo(lifedevo);
  }

  Future getMyLifeDevo(String userId, List sessionIdList) async {
    return await UserContentsAPIClient.getMyLifeDevo(userId, sessionIdList);
  }

  Future getSharedLifeDevo(String userId, List sessionIdList) async {
    return await UserContentsAPIClient.getSharedLifeDevo(userId, sessionIdList);
  }

  // ignore: slash_for_doc_comments
  /*****************************************************************
  * Comments
  *****************************************************************/
  Future createComment(String sessionId, String userId, String content) async {
    return await UserContentsAPIClient.createComment(
        sessionId, userId, content);
  }

  Future getComment(String sessionId, Map exclusiveStartKey) async {
    return await UserContentsAPIClient.getComment(sessionId, exclusiveStartKey);
  }

  Future updateComment(
      String sessionId, String commentSkCollection, String content) async {
    return await UserContentsAPIClient.updateComment(
        sessionId, commentSkCollection, content);
  }

  Future deleteComment(String sessionId, String commentSkCollection) async {
    return await UserContentsAPIClient.deleteComment(
        sessionId, commentSkCollection);
  }

  // ignore: slash_for_doc_comments
  /*****************************************************************
  * User
  *****************************************************************/
  Future searchUserByUserId(List userIdList) async {
    return await UserContentsAPIClient.searchUserByUserId(userIdList);
  }

  Future searchUserByEmail(String email) async {
    return await UserContentsAPIClient.searchUserByEmail(email);
  }

  // ignore: slash_for_doc_comments
  /*****************************************************************
  * Friend Request
  *****************************************************************/
  Future getFriendRequest(String userId) async {
    return await UserContentsAPIClient.getFriendRequest(userId);
  }

  Future cretaeFriendRequest(String fromUserId, String toUserId) async {
    return await UserContentsAPIClient.createFriendRequest(
        fromUserId, toUserId);
  }

  Future acceptFriendRequest(
      String requestSkCollection, String fromUserId, String toUserId) async {
    return await UserContentsAPIClient.acceptFriendRequest(
        requestSkCollection, fromUserId, toUserId);
  }

  Future declineFriendRequest(String requestSkCollection) async {
    return await UserContentsAPIClient.declineFriendRequest(
        requestSkCollection);
  }
}
