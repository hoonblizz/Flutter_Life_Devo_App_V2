import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_life_devo_app_v2/data/repository/admin_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/data/repository/user_contents_repository.dart';
import 'package:flutter_life_devo_app_v2/models/discipline_model.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_comp_model.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_model.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_session_model.dart';
import 'package:flutter_life_devo_app_v2/models/live_life_devo_model.dart';
import 'package:flutter_life_devo_app_v2/models/sermon_model.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/data/repository/auth_repository.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';

const currentFileName = "main_controller";

class MainController extends GetxController {
  final AuthRepository authRepo;
  final AdminContentsRepository adminContentRepo;
  final UserContentsRepository userContentRepo;
  MainController(
      {required this.authRepo,
      required this.adminContentRepo,
      required this.userContentRepo}); // : assert(repository != null);

  // 이미 main 에서 put 해줬으니 찾기만 하면 된다.
  //GlobalController gc = Get.put(GlobalController());
  GlobalController gc = Get.find();
  //final LifeDevoDetailController _lifeDevoDetailController = Get.find();

  // ignore: slash_for_doc_comments
  /******************************************************************
   * Variable collections
  ******************************************************************/
  RxBool isHomeTabLoading = false.obs;
  Rx<LifeDevoCompModel> latestLifeDevoSession = LifeDevoCompModel().obs;
  Rx<LiveLifeDevoModel> latestLiveLifeDevo = LiveLifeDevoModel().obs;
  Rx<DisciplineModel> latestDiscipline = DisciplineModel().obs;
  Rx<SermonModel> latestSermon = SermonModel().obs;

  late AppLifecycleState _lastLifecyleState;

  // ignore: slash_for_doc_comments
  /******************************************************************
   * Functions
  ******************************************************************/

  @override
  void onInit() {
    gc.consoleLog('Init Main page controller', curFileName: currentFileName);
    loadHomeTabFeatures();
    handleAppLifeCycle();

    super.onInit();
  }

  startHomeTabLoading() {
    isHomeTabLoading.value = true;
  }

  stopHomeTabLoading() {
    isHomeTabLoading.value = false;
  }

  // ignore: slash_for_doc_comments
  /******************************************************************
   * Home Tab (1st)
  ******************************************************************/
  loadHomeTabFeatures() async {
    startHomeTabLoading();

    // Load latest life devo, sermon and live life devo, discipline
    await getLatestLifeDevo();
    await getLatestLiveLifeDevo();
    await getLatestDiscipline();
    await getLatestSermon();

    stopHomeTabLoading();
  }

  getLatestLifeDevo() async {
    try {
      // Get latest life devo
      LifeDevoSessionModel _tempSession = LifeDevoSessionModel();
      Map result = await adminContentRepo.getLatestLifeDevoSession();
      //gc.consoleLog('Result: ${result.toString()}');
      if (result['statusCode'] == 200) {
        _tempSession = LifeDevoSessionModel.fromJSON(result['body']);
      }

      // Get matching user life devo
      List<LifeDevoModel> myLifeDevoList = [];
      Map resultMyLifeDevo = await userContentRepo
          .getMyLifeDevo(gc.currentUser.userId, [_tempSession.id]);

      if (resultMyLifeDevo['statusCode'] == 200 &&
          resultMyLifeDevo['body'] != null) {
        List<LifeDevoModel> _tempList = [];
        for (int x = 0; x < resultMyLifeDevo['body'].length; x++) {
          _tempList.add(LifeDevoModel.fromJSON(resultMyLifeDevo['body'][x]));
        }
        myLifeDevoList = List<LifeDevoModel>.from(_tempList); // deep copy
        // 라이프 디보가 하나만 나올거라 생각.
        if (myLifeDevoList.isNotEmpty) {
          latestLifeDevoSession.value =
              LifeDevoCompModel.generate(_tempSession, myLifeDevoList[0]);
        } else {
          latestLifeDevoSession.value =
              LifeDevoCompModel.generate(_tempSession, LifeDevoModel());
        }
      } else {
        latestLifeDevoSession.value =
            LifeDevoCompModel.generate(_tempSession, LifeDevoModel());
      }
    } catch (e) {
      gc.consoleLog('Error falls here: ${e.toString()}');
      // TODO: Do something about errors
    }
  }

  getLatestLiveLifeDevo() async {
    try {
      // 맨위의것을 가져와야 하니까 pagination key 없이 가져온다.
      Map result = await adminContentRepo.getAllLiveLifeDevo();
      //debugPrint('Latest live life devo: ${result.toString()}');
      if (result.isNotEmpty &&
          result['statusCode'] == 200 &&
          result['body'].length > 0) {
        //debugPrint('Copying live life devo: ${result['body'][0].toString()}');
        latestLiveLifeDevo.value =
            LiveLifeDevoModel.fromJSON(result['body'][0]);
      }
    } catch (e) {
      debugPrint('Error getting latest live life devo: ${e.toString()}');
    }
  }

  getLatestDiscipline() async {
    try {
      // 맨위의것을 가져와야 하니까 pagination key 없이 가져온다.
      Map result = await adminContentRepo.getAllDiscipline();
      //debugPrint('Latest discipline: ${result.toString()}');
      if (result.isNotEmpty &&
          result['statusCode'] == 200 &&
          result['body'].length > 0) {
        //debugPrint('Copying discipline: ${result['body'][0].toString()}');
        latestDiscipline.value = DisciplineModel.fromJSON(result['body'][0]);
      }
    } catch (e) {
      debugPrint('Error getting latest discipline: ${e.toString()}');
    }
  }

  getLatestSermon() async {
    try {
      // 맨위의것을 가져와야 하니까 pagination key 없이 가져온다.
      Map result = await adminContentRepo.getAllSermon();
      //debugPrint('Latest sermon: ${result.toString()}');
      if (result.isNotEmpty &&
          result['statusCode'] == 200 &&
          result['body'].length > 0) {
        //debugPrint('Copying sermon: ${result['body'][0].toString()}');
        latestSermon.value = SermonModel.fromJSON(result['body'][0]);
      }
    } catch (e) {
      debugPrint('Error getting latest sermon: ${e.toString()}');
    }
  }

  gotoLifeDevoDetail(LifeDevoCompModel lifeDevo) {
    Get.toNamed(Routes.LIFE_DEVO_DETAIL, arguments: [lifeDevo]);
  }

  gotoLiveLifeDevoDetailPage(LiveLifeDevoModel liveLifeDevo) {
    Get.toNamed(Routes.LIVE_LIFE_DEVO_DETAIL, arguments: [liveLifeDevo]);
  }

  gotoDisciplineDetailPage(DisciplineModel discipline) {
    Get.toNamed(Routes.DISPLINE_DETAIL, arguments: [discipline]);
  }

  gotoSermonDetailPage(SermonModel sermon) {
    Get.toNamed(Routes.SERMON_DETAIL, arguments: [sermon]);
  }

  /******************************************************************
   * Contents Tab (2nd)
  ******************************************************************/

  /******************************************************************
   * Life devo Tab (3rd)
  ******************************************************************/

  /******************************************************************
   * People tab (4th)
  ******************************************************************/

  // ignore: slash_for_doc_comments
  /******************************************************************
   * Profile tab (5th)
  ******************************************************************/

  gotoAuthPage() {
    Get.toNamed(Routes.AUTH);
  }

  // ignore: slash_for_doc_comments
  /******************************************************************
   * App status (BG, FG)
   * 백드라운드로 들어가면 순서가 inactive --(~1s)---> paused
   * Foreground 순서는 inactive -- (~1s) ---->  resumed
   * 웹소켓은 Done 상태가 되는데, 이때 자동으로 다시 연결해주므로, 굳이 여기서 해결 안해도 될듯?
  ******************************************************************/
  handleAppLifeCycle() {
    SystemChannels.lifecycle.setMessageHandler((message) async {
      debugPrint('System channel: $message');

      switch (message) {
        case "AppLifecycleState.paused":
          _lastLifecyleState = AppLifecycleState.paused;
          break;
        case "AppLifecycleState.inactive":
          _lastLifecyleState = AppLifecycleState.inactive;
          break;
        case "AppLifecycleState.resumed":
          _lastLifecyleState = AppLifecycleState.resumed;
          break;
        case "AppLifecycleState.detached":
          _lastLifecyleState = AppLifecycleState.detached;
          break;
        default:
      }

      return;
    });
  }
}
