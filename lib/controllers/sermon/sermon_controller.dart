import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/sermon_model.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';
import 'package:get/get.dart';

class SermonController extends GetxController {
  final AdminContentsRepository adminContentRepo;
  SermonController({required this.adminContentRepo});

  GlobalController gc = Get.find();

  RxBool isLoadingList = false.obs;
  List<List<SermonModel>> sermonList = []; // 2d array -> new to old
  RxList<SermonModel> sermonListMerged = <SermonModel>[].obs; // Flattened
  List<Map> lastEvaluatedKeyList = [];

  startLoadingList() {
    isLoadingList.value = true;
  }

  stopLoadingList() {
    isLoadingList.value = false;
  }

  mergeContentsList() {
    sermonListMerged.value =
        sermonList.expand((element) => element).toList(); // Flatten to 1D
  }

  gotoContentDetail(SermonModel content) {
    Get.toNamed(Routes.SERMON_DETAIL, arguments: [content]);
  }

  getAllSermon() async {
    startLoadingList();
    // 마지막 evaluated key 구하기
    int lastContentIndex = lastEvaluatedKeyList.length - 1;
    Map latestEvalKey = {};
    if (lastContentIndex > -1) {
      latestEvalKey = lastEvaluatedKeyList[lastContentIndex];
    }

    List<SermonModel> _tempList = [];

    try {
      Map result = await adminContentRepo.getAllSermon(latestEvalKey);
      //debugPrint('Result getting contents: ${result.toString()}');
      if (result.isNotEmpty && result['statusCode'] == 200) {
        for (int x = 0; x < result['body'].length; x++) {
          _tempList.add(SermonModel.fromJSON(result['body'][x]));
        }
      }

      // Pagination key 등록
      // LEK 크기가 같거나 작다는건, 아직 등록이 안되었고 등록할 필요가 있다는 뜻.
      if (result['exclusiveStartKey'] != null &&
          lastEvaluatedKeyList.length <= sermonList.length) {
        lastEvaluatedKeyList.add(result['exclusiveStartKey']);
      }

      if (lastEvaluatedKeyList.isEmpty) {
        // 여기에 오는건 컨텐츠가 없거나 컨텐츠가 적을때. 전체 리스트를 세팅해준다.
        debugPrint('Adding more contents');
        sermonList.assign(List<SermonModel>.from(_tempList)); // Deep copy
      } else {
        // 해당 인덱스가 존재하는지 확인. map 으로 바꿔서 확인.
        if (sermonList.asMap().containsKey(lastEvaluatedKeyList.length)) {
          debugPrint('Replacing contents');
          sermonList[lastEvaluatedKeyList.length]
              .assignAll(List<SermonModel>.from(_tempList));
        } else {
          debugPrint('Adding contents because its new');
          sermonList.add(List<SermonModel>.from(_tempList));
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
