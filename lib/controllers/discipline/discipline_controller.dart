/*
  Discipline Topic 도 같이 핸들링 해주자.
*/

import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:get/get.dart';

class DisciplineController extends GetxController {
  final AdminContentsRepository adminContentRepo;
  DisciplineController({required this.adminContentRepo});

  GlobalController gc = Get.find();
}
