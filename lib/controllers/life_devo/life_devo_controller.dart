/*
  Life devo tab 에 사용.

  원래는 All, My, shared 로 나누어져 있지만, 귀찮으니까 여기 하나에서 컨트롤 하자.
*/

import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
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
    print('Life Devo controller init?');
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

  List<Session> allLifeDevoSessionList = <Session>[].obs;

  void tabAllLoadingStart() {
    isTabAllLoading.value = true;
  }

  void tabAllLoadingEnd() {
    isTabAllLoading.value = false;
  }

  void onChangeMonthForTabAll(DateTime selectedTime) {
    selectedMonthForTabAll.value = selectedTime;
    print(
        'Selected Month: ${selectedTime.year}-${selectedTime.month} => Epoch: ${selectedTime.millisecondsSinceEpoch} to ${DateTime(selectedTime.year, selectedTime.month + 1, 1).subtract(Duration(seconds: 10)).millisecondsSinceEpoch}');
  }

  void getAllLifeDevoSession() async {
    tabAllLoadingStart();
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
        List<Session> _tempList = [];
        for (int x = 0; x < result['body'].length; x++) {
          _tempList.add(Session.fromJSON(result['body'][x]));
        }

        allLifeDevoSessionList = List<Session>.from(_tempList); // Deep copy
      }
    } catch (e) {
      gc.consoleLog('Error get life devo: ${e.toString()}',
          curFileName: currentFileName);
    }
    tabAllLoadingEnd();
  }

  gotoLifeDevoDetail(Session lifeDevoSession) {
    Get.toNamed(Routes.LIFE_DEVO_DETAIL, arguments: [lifeDevoSession]);
  }

  // ignore: slash_for_doc_comments
  /******************************************************
   * Tab: My 
  ******************************************************/
  Rx<DateTime> selectedMonthForTabMy = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;
  void onChangeMonthForTabMy(DateTime selectedTime) {
    selectedMonthForTabMy.value = selectedTime;
  }

  // ignore: slash_for_doc_comments
  /******************************************************
   * Tab: Shared 
  ******************************************************/
  Rx<DateTime> selectedMonthForTabShared = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;
  void onChangeMonthForTabShared(DateTime selectedTime) {
    selectedMonthForTabShared.value = selectedTime;
  }
}
