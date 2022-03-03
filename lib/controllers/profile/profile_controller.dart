import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';
import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/friend_request_model.dart';
import 'package:flutter_life_devo_app_v2/models/user_model.dart';
import 'package:get/get.dart';

const String currentFileName = "Profile_Controller";

class ProfileController extends GetxController {
  final AuthRepository authRepo;
  final UserContentsRepository userContentRepo;

  GlobalController gc = Get.find();
  List<FriendRequestModel> friendRequestList = <FriendRequestModel>[].obs;
  RxBool isRequestLoading = false.obs;

  ProfileController({
    required this.authRepo,
    required this.userContentRepo,
  });

  startRequestLoading() {
    isRequestLoading.value = true;
  }

  stopRequestLoading() {
    isRequestLoading.value = false;
  }

  getFriendRequests() async {
    if (gc.currentUser.userId.isEmpty) {
      return;
    }

    startRequestLoading();

    List<FriendRequestModel> _tempRequestList = [];
    try {
      Map result =
          await userContentRepo.getFriendRequest(gc.currentUser.userId);
      if (result.isNotEmpty && result['statusCode'] == 200) {
        List<FriendRequestModel> _tempList = [];
        for (int x = 0; x < result['body'].length; x++) {
          _tempList.add(FriendRequestModel.fromJSON(result['body'][x]));
        }
        _tempRequestList = _tempList;
      }
    } catch (e) {
      debugPrint('Error getting friend request: ${e.toString()}');
    }

    if (_tempRequestList.isEmpty) {
      friendRequestList = [];
      stopRequestLoading();
      return;
    }

    // 리스트 돌면서 유저 정보 모으기
    List<String> _userIdList = [];
    for (FriendRequestModel request in _tempRequestList) {
      _userIdList.add(request.toUserId);
      _userIdList.add(request.fromUserId);
    }
    _userIdList.toSet(); //toSet 으로 중복 없애줌.

    debugPrint('User id collected: ${_userIdList.toString()}');

    // 유저정보들 한꺼번에 받아서 각각의 리스트 정보에 붙여넣기
    try {
      Map result =
          await userContentRepo.searchUserByUserId(_userIdList.toList());
      debugPrint('Result getting user data: ${result.toString()}');

      if (result['statusCode'] == 200 && result['body'] != null) {
        for (var x = 0; x < _tempRequestList.length; x++) {
          List _foundUserData = result['body'];
          // Get toUser
          Map _foundMatchUser = _foundUserData.firstWhere(
              (el) => _tempRequestList[x].toUserId == el["userId"]) as Map;
          _tempRequestList[x].toUser = User.fromJSON(_foundMatchUser);
          debugPrint('To User: ${_tempRequestList[x].toUser.userId}');
          // Get fromUser
          Map _foundMatchUser2 = _foundUserData.firstWhere(
              (el) => _tempRequestList[x].fromUserId == el["userId"]) as Map;
          _tempRequestList[x].fromUser = User.fromJSON(_foundMatchUser2);
          debugPrint('From User: ${_tempRequestList[x].fromUser.userId}');
        }
      }
    } catch (e) {
      debugPrint('Error searching user data: ${e.toString()}');
    }

    // 결과를 Deep copy
    friendRequestList = List<FriendRequestModel>.from(_tempRequestList);

    stopRequestLoading();
  }

  onPressAcceptFriendRequest(requestSkCollection, fromUserId, toUserId) async {
    await userContentRepo.acceptFriendRequest(
        requestSkCollection, fromUserId, toUserId);
    await getFriendRequests();
  }

  onPressDeclineFriendRequest(requestSkCollection) async {
    try {
      Map result =
          await userContentRepo.declineFriendRequest(requestSkCollection);
      debugPrint('Result decline: ${result.toString()}');
    } catch (e) {
      debugPrint('Error declining request: ${e.toString()}');
    }

    await getFriendRequests();
  }

  onPressInviteFriend(String email) async {
    Map foundUser = {};
    // 해당 이메일을 가진 유저 찾기
    try {
      Map result = await userContentRepo.searchUserByEmail(email);
      if (result['statusCode'] == 200 && result['body'].length > 0) {
        foundUser = result['body'][0]; // 하나만 찾아질것. 무조건 0 인덱스만 보내주자.
      }
      debugPrint('Result searching user: ${result.toString()}');
    } catch (e) {
      debugPrint('Error searching user: ${e.toString()}');
    }

    if (foundUser.isEmpty || foundUser['userId'] == null) {
      return;
    }

    String targetUserId = foundUser['userId'];

    // 친구 추가 초대 보내기
    try {
      Map result = await userContentRepo.cretaeFriendRequest(
          gc.currentUser.userId, targetUserId);
      debugPrint('Result sending request: ${result.toString()}');
    } catch (e) {
      debugPrint('Error sending request: ${e.toString()}');
    }

    // 리프레쉬
    await getFriendRequests();
  }

  @override
  void onInit() {
    gc.consoleLog(
      "Init profile page controller",
      curFileName: currentFileName,
    );
    getFriendRequests();
    super.onInit();
  }
}
