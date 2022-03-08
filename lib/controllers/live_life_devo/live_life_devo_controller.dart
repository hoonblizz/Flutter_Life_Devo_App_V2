/*
  
*/

import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/live_life_devo_model.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';
import 'package:get/get.dart';

class LiveLifeDevoController extends GetxController {
  final AdminContentsRepository adminContentRepo;
  LiveLifeDevoController({required this.adminContentRepo});

  GlobalController gc = Get.find();

  RxBool isLoadingList = false.obs;
  List<List<LiveLifeDevoModel>> liveLifeDevoList = []; // 2d array -> new to old
  RxList<LiveLifeDevoModel> liveLifeDevoListMerged =
      <LiveLifeDevoModel>[].obs; // Flattened
  List<Map> lastEvaluatedKeyList = [];

  startLoadingList() {
    isLoadingList.value = true;
  }

  stopLoadingList() {
    isLoadingList.value = false;
  }

  mergeContentsList() {
    // 2D 는 케이스에 따라 다르게 핸들링 해준다.
    liveLifeDevoListMerged.value =
        liveLifeDevoList.expand((element) => element).toList(); // Flatten to 1D
  }

  gotoContentDetail(LiveLifeDevoModel content) {
    Get.toNamed(Routes.LIVE_LIFE_DEVO_DETAIL, arguments: [content]);
  }

  getAllLiveLifeDevo() async {
    startLoadingList();
    // 마지막 evaluated key 구하기
    int lastContentIndex = lastEvaluatedKeyList.length - 1;
    Map latestEvalKey = {};
    if (lastContentIndex > -1) {
      latestEvalKey = lastEvaluatedKeyList[lastContentIndex];
    }

    List<LiveLifeDevoModel> _tempList = [];

    try {
      Map result = await adminContentRepo.getAllLiveLifeDevo(latestEvalKey);
      //debugPrint('Result getting contents: ${result.toString()}');
      if (result.isNotEmpty && result['statusCode'] == 200) {
        for (int x = 0; x < result['body'].length; x++) {
          _tempList.add(LiveLifeDevoModel.fromJSON(result['body'][x]));
        }
      }

      // Pagination key 등록
      // LEK 크기가 같거나 작다는건, 아직 등록이 안되었고 등록할 필요가 있다는 뜻.
      if (result['exclusiveStartKey'] != null &&
          lastEvaluatedKeyList.length <= liveLifeDevoList.length) {
        lastEvaluatedKeyList.add(result['exclusiveStartKey']);
      }

      if (lastEvaluatedKeyList.isEmpty) {
        // 여기에 오는건 컨텐츠가 없거나 컨텐츠가 적을때. 전체 리스트를 세팅해준다.
        debugPrint('Adding more contents');
        liveLifeDevoList
            .assign(List<LiveLifeDevoModel>.from(_tempList)); // Deep copy
      } else {
        // 해당 인덱스가 존재하는지 확인. map 으로 바꿔서 확인.
        if (liveLifeDevoList.asMap().containsKey(lastEvaluatedKeyList.length)) {
          debugPrint('Replacing contents');
          liveLifeDevoList[lastEvaluatedKeyList.length]
              .assignAll(List<LiveLifeDevoModel>.from(_tempList));
        } else {
          debugPrint('Adding contents because its new');
          liveLifeDevoList.add(List<LiveLifeDevoModel>.from(_tempList));
        }
      }

      mergeContentsList(); // 2D -> 1D 로

      debugPrint('Pagination lists: ${lastEvaluatedKeyList.toString()}');
    } catch (e) {
      debugPrint('Error getting contents: ${e.toString()}');
    }

    stopLoadingList();
  }
}
