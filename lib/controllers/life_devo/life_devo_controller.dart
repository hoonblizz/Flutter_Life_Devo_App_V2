/*
  Life devo tab 에 사용.

  원래는 All, My, shared 로 나누어져 있지만, 귀찮으니까 여기 하나에서 컨트롤 하자.
*/

import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_comp_model.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_model.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_session_model.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';
import 'package:get/get.dart';

const currentFileName = "life_devo_controller";

class LifeDevoController extends GetxController {
  final AdminContentsRepository adminContentRepo;
  final UserContentsRepository userContentRepo;
  LifeDevoController(
      {required this.adminContentRepo, required this.userContentRepo});

  GlobalController gc = Get.find();

  @override
  void onInit() {
    // 굳이 여기서 ALL 탭 관련 API 부를건 없고, 그냥 All page init 에서 불러주는것으로 충분하다.
    debugPrint('Life Devo controller init?');
    super.onInit();
  }

  // ignore: slash_for_doc_comments
  /******************************************************
   * Tab: All 
  ******************************************************/
  RxBool isTabAllLoading = false.obs;

  Rx<DateTime> selectedMonthForTabAll = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;

  // List<LifeDevoSessionModel> allLifeDevoSessionList =
  //     <LifeDevoSessionModel>[].obs;
  // List<LifeDevoModel> myLifeDevoList = <LifeDevoModel>[].obs;
  // List<LifeDevoSessionModel> myLifeDevoSessionList =
  //     <LifeDevoSessionModel>[].obs; // filtered sessions from my life devo
  // List<LifeDevoModel> sharedLifeDevoList = <LifeDevoModel>[].obs;
  // List<LifeDevoSessionModel> sharedLifeDevoSessionList =
  //     <LifeDevoSessionModel>[].obs;

  List<LifeDevoCompModel> allLifeDevoList = <LifeDevoCompModel>[].obs;
  List<LifeDevoCompModel> myLifeDevoList = <LifeDevoCompModel>[].obs;
  List<LifeDevoCompModel> sharedLifeDevoList = <LifeDevoCompModel>[].obs;

  void tabAllLoadingStart() {
    isTabAllLoading.value = true;
  }

  void tabAllLoadingEnd() {
    isTabAllLoading.value = false;
  }

  void onChangeMonthForTabAll(DateTime selectedTime) {
    selectedMonthForTabAll.value = selectedTime;
    debugPrint(
        'Selected Month: ${selectedTime.year}-${selectedTime.month} => Epoch: ${selectedTime.millisecondsSinceEpoch} to ${DateTime(selectedTime.year, selectedTime.month + 1, 1).subtract(const Duration(seconds: 10)).millisecondsSinceEpoch}');
  }

  void getAllLifeDevoSession() async {
    tabAllLoadingStart();
    allLifeDevoList.clear(); // 비워주기
    List<LifeDevoSessionModel> foundLifeDevoSessions = [];
    // 시작, 끝 지점 구하기
    DateTime curSelectedTime = selectedMonthForTabAll.value;
    int startDateFrom = curSelectedTime.millisecondsSinceEpoch;
    int startDateTo =
        DateTime(curSelectedTime.year, curSelectedTime.month + 1, 1)
            .subtract(const Duration(seconds: 10))
            .millisecondsSinceEpoch;

    try {
      await Future.delayed(const Duration(seconds: 1));
      Map result = await adminContentRepo.getAllLifeDevoSession(
          startDateFrom, startDateTo);

      //print('Result: ${result.toString()}');
      // 결과가 없으면 빈 array 가 리턴된다.
      if (result['statusCode'] == 200 && result['body'] != null) {
        List<LifeDevoSessionModel> _tempList = [];
        for (int x = 0; x < result['body'].length; x++) {
          _tempList.add(LifeDevoSessionModel.fromJSON(result['body'][x]));
        }

        foundLifeDevoSessions =
            List<LifeDevoSessionModel>.from(_tempList); // Deep copy
      }
    } catch (e) {
      gc.consoleLog('Error get life devo: ${e.toString()}',
          curFileName: currentFileName);
    }

    // 해당 월에 따른 life devo 를 불러왔으면, sessionIdList 를 뽑아보기
    // (searchLifeDevo 에 필요)
    List sessionIdList = foundLifeDevoSessions.map((el) {
      return el.id;
    }).toList();

    // 세션 리스트 뽑았으면, 이제 searchLifeDevo
    List<LifeDevoModel> searchedMyLifeDevoList = [];

    if (sessionIdList.isNotEmpty) {
      try {
        Map result = await userContentRepo.getMyLifeDevo(
            gc.currentUser.userId, sessionIdList);

        if (result['statusCode'] == 200 && result['body'] != null) {
          List<LifeDevoModel> _tempList = [];
          for (int x = 0; x < result['body'].length; x++) {
            _tempList.add(LifeDevoModel.fromJSON(result['body'][x]));
          }
          searchedMyLifeDevoList =
              List<LifeDevoModel>.from(_tempList); // deep copy
        }
      } catch (e) {
        debugPrint('Error searching life devo: ${e.toString()}');
      }

      // All Session 을 기준으로 찾아낸 my life devo 를 붙여서 composite model 만든다.
      List<LifeDevoCompModel> _tempCompModel = [];
      for (LifeDevoSessionModel session in foundLifeDevoSessions) {
        // id 가 매칭하는 Life devo 찾아내자
        LifeDevoModel ldModel = searchedMyLifeDevoList.firstWhere(
            (lifeDevo) => session.id == lifeDevo.sessionId,
            orElse: () => LifeDevoModel());

        _tempCompModel.add(LifeDevoCompModel.generate(session, ldModel));
      }

      // 결과를 Deep copy
      allLifeDevoList = List<LifeDevoCompModel>.from(_tempCompModel);
    }
    tabAllLoadingEnd();
  }

  gotoLifeDevoDetail(LifeDevoCompModel lifeDevo) {
    Get.toNamed(Routes.LIFE_DEVO_DETAIL, arguments: [lifeDevo]);
  }

  // ignore: slash_for_doc_comments
  /******************************************************
   * Tab: My 
  ******************************************************/
  RxBool isTabMyLoading = false.obs;
  Rx<DateTime> selectedMonthForTabMy = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;
  void onChangeMonthForTabMy(DateTime selectedTime) {
    selectedMonthForTabMy.value = selectedTime;
  }

  void tabMyLoadingStart() {
    isTabMyLoading.value = true;
  }

  void tabMyLoadingEnd() {
    isTabMyLoading.value = false;
  }

  void getMyLifeDevo() async {
    tabMyLoadingStart();

    myLifeDevoList.clear();
    List<LifeDevoSessionModel> foundLifeDevoSessions = [];
    // 시작, 끝 지점 구하기
    DateTime curSelectedTime = selectedMonthForTabMy.value;
    int startDateFrom = curSelectedTime.millisecondsSinceEpoch;
    int startDateTo =
        DateTime(curSelectedTime.year, curSelectedTime.month + 1, 1)
            .subtract(const Duration(seconds: 10))
            .millisecondsSinceEpoch;

    try {
      await Future.delayed(const Duration(seconds: 1));
      Map result = await adminContentRepo.getAllLifeDevoSession(
          startDateFrom, startDateTo);

      //print('Result: ${result.toString()}');
      // 결과가 없으면 빈 array 가 리턴된다.
      if (result['statusCode'] == 200 && result['body'] != null) {
        List<LifeDevoSessionModel> _tempList = [];
        for (int x = 0; x < result['body'].length; x++) {
          _tempList.add(LifeDevoSessionModel.fromJSON(result['body'][x]));
        }

        foundLifeDevoSessions =
            List<LifeDevoSessionModel>.from(_tempList); // Deep copy
      }
    } catch (e) {
      gc.consoleLog('Error get life devo: ${e.toString()}',
          curFileName: currentFileName);
    }

    // 해당 월에 따른 life devo 를 불러왔으면, sessionIdList 를 뽑아보기
    // (searchLifeDevo 에 필요)
    List sessionIdList = foundLifeDevoSessions.map((el) {
      return el.id;
    }).toList();

    // 세션 리스트 뽑았으면, 이제 searchLifeDevo
    List<LifeDevoModel> searchedMyLifeDevoList = [];

    if (sessionIdList.isNotEmpty) {
      try {
        Map result = await userContentRepo.getMyLifeDevo(
            gc.currentUser.userId, sessionIdList);

        if (result['statusCode'] == 200 && result['body'] != null) {
          for (int x = 0; x < result['body'].length; x++) {
            searchedMyLifeDevoList
                .add(LifeDevoModel.fromJSON(result['body'][x]));
          }
          //myLifeDevoList = List<LifeDevoModel>.from(_tempList); // deep copy
        }
      } catch (e) {
        debugPrint('Error searching life devo: ${e.toString()}');
      }

      // My life devo 를 기준으로 all session 을 붙여서 composite model 만든다.
      List<LifeDevoCompModel> _tempCompModel = [];
      for (LifeDevoModel lifeDevo in searchedMyLifeDevoList) {
        // id 가 매칭하는 Life devo 찾아내자
        LifeDevoSessionModel foundSession = foundLifeDevoSessions.firstWhere(
            (session) => session.id == lifeDevo.sessionId,
            orElse: () => LifeDevoSessionModel());

        _tempCompModel.add(LifeDevoCompModel.generate(foundSession, lifeDevo));
      }

      // 결과를 Deep copy
      myLifeDevoList = List<LifeDevoCompModel>.from(_tempCompModel);
    }

    tabMyLoadingEnd();
  }

  // ignore: slash_for_doc_comments
  /******************************************************
   * Tab: Shared 
  ******************************************************/
  RxBool isTabSharedLoading = false.obs;
  Rx<DateTime> selectedMonthForTabShared = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;
  void onChangeMonthForTabShared(DateTime selectedTime) {
    selectedMonthForTabShared.value = selectedTime;
  }

  void tabSharedLoadingStart() {
    isTabSharedLoading.value = true;
  }

  void tabSharedLoadingEnd() {
    isTabSharedLoading.value = false;
  }

  void getSharedLifeDevo() async {
    tabSharedLoadingStart();

    sharedLifeDevoList.clear();
    List<LifeDevoSessionModel> foundLifeDevoSessions = [];
    // 시작, 끝 지점 구하기
    DateTime curSelectedTime = selectedMonthForTabShared.value;
    int startDateFrom = curSelectedTime.millisecondsSinceEpoch;
    int startDateTo =
        DateTime(curSelectedTime.year, curSelectedTime.month + 1, 1)
            .subtract(const Duration(seconds: 10))
            .millisecondsSinceEpoch;

    try {
      await Future.delayed(const Duration(seconds: 1));
      Map result = await adminContentRepo.getAllLifeDevoSession(
          startDateFrom, startDateTo);

      //print('Result: ${result.toString()}');
      // 결과가 없으면 빈 array 가 리턴된다.
      if (result['statusCode'] == 200 && result['body'] != null) {
        List<LifeDevoSessionModel> _tempList = [];
        for (int x = 0; x < result['body'].length; x++) {
          _tempList.add(LifeDevoSessionModel.fromJSON(result['body'][x]));
        }

        foundLifeDevoSessions =
            List<LifeDevoSessionModel>.from(_tempList); // Deep copy
      }
    } catch (e) {
      gc.consoleLog('Error get life devo: ${e.toString()}',
          curFileName: currentFileName);
    }

    // 해당 월에 따른 life devo 를 불러왔으면, sessionIdList 를 뽑아보기
    // (searchLifeDevo 에 필요)
    List sessionIdList = foundLifeDevoSessions.map((el) {
      return el.id;
    }).toList();

    // 세션 리스트 뽑았으면, 이제 searchLifeDevo
    List<LifeDevoModel> searchedSharedLifeDevoList = [];

    if (sessionIdList.isNotEmpty) {
      try {
        Map result = await userContentRepo.getSharedLifeDevo(
            gc.currentUser.userId, sessionIdList);

        if (result['statusCode'] == 200 && result['body'] != null) {
          for (int x = 0; x < result['body'].length; x++) {
            searchedSharedLifeDevoList
                .add(LifeDevoModel.fromJSON(result['body'][x]));
          }
          //sharedLifeDevoList = List<LifeDevoModel>.from(_tempList); // deep copy
        }
      } catch (e) {
        debugPrint('Error searching life devo: ${e.toString()}');
      }

      // Shared life devo 를 기준으로 all session 을 붙여서 composite model 만든다.
      List<LifeDevoCompModel> _tempCompModel = [];
      for (LifeDevoModel lifeDevo in searchedSharedLifeDevoList) {
        // id 가 매칭하는 Life devo 찾아내자
        LifeDevoSessionModel foundSession = foundLifeDevoSessions.firstWhere(
            (session) => session.id == lifeDevo.sessionId,
            orElse: () => LifeDevoSessionModel());

        _tempCompModel.add(LifeDevoCompModel.generate(foundSession, lifeDevo));
      }

      // 유저 id들의 이름을 찾아준다.
      if (_tempCompModel.isNotEmpty) {
        List<String> _userIdList = _tempCompModel
            .map((e) => e.createdBy)
            .toSet()
            .toList(); // toSet 으로 중복 없애줌.
        try {
          Map result = await userContentRepo.searchUserByUserId(_userIdList);
          debugPrint('Result getting user data: ${result.toString()}');

          if (result['statusCode'] == 200 && result['body'] != null) {
            for (var x = 0; x < _tempCompModel.length; x++) {
              List _foundUserData = result['body'];
              Map _foundMatchUser = _foundUserData.firstWhere(
                  (el) => _tempCompModel[x].createdBy == el["userId"]) as Map;
              //debugPrint('Match found: ${_foundMatchUser.toString()}');
              _tempCompModel[x].userName = _foundMatchUser["name"];
            }
          }
        } catch (e) {
          debugPrint('Error searching user data: ${e.toString()}');
        }
      }

      // 결과를 Deep copy
      sharedLifeDevoList = List<LifeDevoCompModel>.from(_tempCompModel);
    }

    tabSharedLoadingEnd();
  }
}
