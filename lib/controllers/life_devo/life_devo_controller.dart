/*
  Life devo tab 에 사용.

  원래는 All, My, shared 로 나누어져 있지만, 귀찮으니까 여기 하나에서 컨트롤 하자.
*/

import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
import 'package:get/get.dart';

class LifeDevoController extends GetxController {
  final UserContentsRepository userContentRepo;
  LifeDevoController({required this.userContentRepo});
  @override
  void onInit() {
    // 굳이 여기서 ALL 탭 관련 API 부를건 없고, 그냥 All page init 에서 불러주는것으로 충분하다.
    print('Life Devo controller init?');
    super.onInit();
  }
}
