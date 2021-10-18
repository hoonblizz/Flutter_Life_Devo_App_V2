import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';

class HomeController extends GetxController {
  final AuthRepository authRepo;
  HomeController({required this.authRepo}); // : assert(repository != null);
  GlobalController gc = Get.put(GlobalController());

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
  }
}
