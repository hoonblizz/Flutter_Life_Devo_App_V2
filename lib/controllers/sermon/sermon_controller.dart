import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/sermon_model.dart';
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

  mergeContentsList(List<SermonModel> contents) {
    sermonList.add(contents); // in 2D
    sermonListMerged.value =
        sermonList.expand((element) => element).toList(); // Flatten to 1D
  }

  getAllSermon() async {
    startLoadingList();
    // 마지막 evaluated key 구하기
    int lastContentIndex = lastEvaluatedKeyList.length - 1;
    Map latestEvalKey = {};
    if (lastContentIndex > -1) {
      latestEvalKey = lastEvaluatedKeyList[lastContentIndex];
    }

    try {
      Map result = await adminContentRepo.getAllSermon(latestEvalKey);
      debugPrint('Result getting contents: ${result.toString()}');
      if (result.isNotEmpty && result['statusCode'] == 200) {
        List<SermonModel> _tempList = [];

        for (int x = 0; x < result['body'].length; x++) {
          _tempList.add(SermonModel.fromJSON(result['body'][x]));
        }

        mergeContentsList(_tempList);
      }

      // Pagination key 등록
      if (result['exclusiveStartKey'] != null) {
        lastEvaluatedKeyList.add(result['exclusiveStartKey']);
      }

      debugPrint('Pagination lists: ${lastEvaluatedKeyList.toString()}');
    } catch (e) {
      debugPrint('Error getting contents: ${e.toString()}');
    }

    stopLoadingList();
  }
}
