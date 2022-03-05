/*
  
*/

import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:get/get.dart';

class LiveLifeDevoController extends GetxController {
  final AdminContentsRepository adminContentRepo;
  LiveLifeDevoController({required this.adminContentRepo});

  GlobalController gc = Get.find();
}
