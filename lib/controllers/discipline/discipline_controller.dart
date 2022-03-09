/*
  Discipline Topic 도 같이 핸들링 해주자.
*/

import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/discipline_model.dart';
import 'package:flutter_life_devo_app_v2/models/discipline_topic_model.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';
import 'package:get/get.dart';

class DisciplineController extends GetxController {
  final AdminContentsRepository adminContentRepo;
  DisciplineController({required this.adminContentRepo});

  GlobalController gc = Get.find();

  RxBool isLoadingTopicList = false.obs;
  RxBool isLoadingList = false.obs;

  Rx<DisciplineTopicModel> disciplineTopic = DisciplineTopicModel().obs;
  RxList<DisciplineModel> disciplineList = <DisciplineModel>[].obs;

  startLoadingTopicList() {
    isLoadingTopicList.value = true;
  }

  stopLoadingTopicList() {
    isLoadingTopicList.value = false;
  }

  startLoadingList() {
    isLoadingList.value = true;
  }

  stopLoadingList() {
    isLoadingList.value = false;
  }

  gotoContentList(String topicId) {
    Get.toNamed(Routes.DISPLINE_LIST, arguments: [topicId]);
  }

  gotoContentDetail(DisciplineModel content) {
    Get.toNamed(Routes.DISPLINE_DETAIL, arguments: [content]);
  }

  getDisciplineTopic() async {
    try {
      Map result = await adminContentRepo.getDisciplineTopic();
      //debugPrint('Result getting contents: ${result.toString()}');
      if (result.isNotEmpty &&
          result['statusCode'] == 200 &&
          result['body'] != null) {
        disciplineTopic.value = DisciplineTopicModel.fromJSON(result['body']);
      }
    } catch (e) {
      debugPrint('Error getting contents: ${e.toString()}');
    }
  }

  getDisciplineList(String topicId) async {
    disciplineList.value = [];
    List<DisciplineModel> _tempList = [];
    try {
      Map result = await adminContentRepo.getAllDiscipline(topicId);
      //debugPrint('Result getting contents: ${result.toString()}');
      if (result.isNotEmpty &&
          result['statusCode'] == 200 &&
          result['body'] != null) {
        for (int x = 0; x < result['body'].length; x++) {
          _tempList.add(DisciplineModel.fromJSON(result['body'][x]));
        }

        disciplineList.value = List<DisciplineModel>.from(_tempList);
      }
    } catch (e) {
      debugPrint('Error getting contents: ${e.toString()}');
    }
  }
}
