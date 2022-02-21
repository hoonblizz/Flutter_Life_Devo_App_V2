import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_model.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';

const currentFileName = "life_devo_detail_controller";

class LifeDevoDetailController extends GetxController {
  final AuthRepository authRepo;
  //final AdminContentsRepository adminContentRepo;
  final UserContentsRepository userContentRepo;
  LifeDevoDetailController(
      {required this.authRepo,
      //required this.adminContentRepo,
      required this.userContentRepo}); // : assert(repository != null);

  GlobalController gc = Get.find();

  // ignore: slash_for_doc_comments
  /******************************************************************
   * Variable collections
  ******************************************************************/
  RxBool isLifeDevoLoading = false.obs;
  RxBool isCommentsLoading = false.obs;

  // ignore: slash_for_doc_comments
  /******************************************************************
   * Functions
  ******************************************************************/

  @override
  void onInit() {
    super.onInit();
  }

  _startLifeDevoLoading() {
    isLifeDevoLoading.value = true;
  }

  _stopLifeDevoLoading() {
    isLifeDevoLoading.value = false;
  }

  Future<LifeDevoModel?> onTapSaveLifeDevo(LifeDevoModel _lifeDevo) async {
    _startLifeDevoLoading();

    if (_lifeDevo.skCollection.isNotEmpty) {
      await updateLifeDevo(_lifeDevo);
    } else {
      LifeDevoModel? createdLifeDevo = await createLifeDevo(_lifeDevo);
      if (createdLifeDevo != null) {
        // 저장이 잘 안되면 null 이 리턴된다. 그럴땐 기존의 텍스트를 없애지 않도록...
        _lifeDevo = createdLifeDevo;
      }
    }

    // 끝나면 그냥 한번 더 불러주자.
    LifeDevoModel? returnedLifeDevo = await getUserLifeDevo(
        userId: _lifeDevo.createdBy, lifeDevoSessionId: _lifeDevo.sessionId);

    _stopLifeDevoLoading();

    return returnedLifeDevo;
  }

  Future<LifeDevoModel?> getUserLifeDevo(
      {required String userId, required String lifeDevoSessionId}) async {
    String _skCollection = userId + '#' + lifeDevoSessionId;

    try {
      Map result = await userContentRepo.getLifeDevo(_skCollection);
      gc.consoleLog('Result getting User life devo: ${result.toString()}',
          curFileName: currentFileName);
      if (result['statusCode'] == 200 &&
          result['body'] != null &&
          result['body']['pkCollection'] != null) {
        return LifeDevoModel.fromJSON(result['body']);
      }
    } catch (e) {
      gc.consoleLog('Error get life devo: ${e.toString()}',
          curFileName: currentFileName);
    }
  }

  Future<LifeDevoModel?> createLifeDevo(LifeDevoModel _lifeDevo) async {
    try {
      Map result = await userContentRepo.createLifeDevo(_lifeDevo);
      // gc.consoleLog('Result: ${result.toString()}',
      //     curFileName: currentFileName);
      if (result['statusCode'] == 200 && result['body'] != null) {
        return LifeDevoModel.fromJSON(result['body']);
      }
    } catch (e) {
      gc.consoleLog('Error creating life devo', curFileName: currentFileName);
    }
  }

  Future updateLifeDevo(LifeDevoModel _lifeDevo) async {
    try {
      Map result = await userContentRepo.updateLifeDevo(_lifeDevo);
      // gc.consoleLog('Result: ${result.toString()}',
      //     curFileName: currentFileName);
    } catch (e) {
      gc.consoleLog('Error updating life devo', curFileName: currentFileName);
    }
  }

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
  }

  // ignore: slash_for_doc_comments
  /******************************************************************
   * Comments
  ******************************************************************/
  Future<Map> getComments(String sessionId, Map exclusiveStartKey) async {
    try {
      Map result =
          await userContentRepo.getComment(sessionId, exclusiveStartKey);
      // gc.consoleLog('Result: ${result.toString()}',
      //     curFileName: currentFileName);
      return result;
    } catch (e) {
      gc.consoleLog('Error getting comments', curFileName: currentFileName);
    }
    return {};
  }

  Future createComments(String sessionId, String userId, String content) async {
    try {
      Map result =
          await userContentRepo.createComment(sessionId, userId, content);
      gc.consoleLog('Result creating comment: ${result.toString()}',
          curFileName: currentFileName);
    } catch (e) {
      gc.consoleLog('Error creating comments', curFileName: currentFileName);
    }
  }

  // ignore: slash_for_doc_comments
  /******************************************************************
   * User
  ******************************************************************/
  Future<Map> searchUserByUserId(List userIdList) async {
    try {
      return await userContentRepo.searchUserByUserId(userIdList);
    } catch (e) {
      gc.consoleLog('Error searching users', curFileName: currentFileName);
    }
    return {};
  }
}
