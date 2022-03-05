import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/sermon_model.dart';
import 'package:get/get.dart';

class SermonController extends GetxController {
  final AdminContentsRepository adminContentRepo;
  SermonController({required this.adminContentRepo});

  GlobalController gc = Get.find();

  Future<List<SermonModel>> getAllSermon(
      [Map exclusiveStartKey = const {}]) async {
    try {
      Map result = await adminContentRepo.getAllSermon(exclusiveStartKey);
      debugPrint('Result getting contents: ${result.toString()}');
      if (result.isNotEmpty && result['statusCode'] == 200) {
        List<SermonModel> _tempList = [];

        for (int x = 0; x < result['body'].length; x++) {
          _tempList.add(SermonModel.fromJSON(result['body'][x]));
        }

        // return when its done
        return _tempList;
      }
    } catch (e) {
      debugPrint('Error getting contents: ${e.toString()}');
    }
    return [];
  }
}
