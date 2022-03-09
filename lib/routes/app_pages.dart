import 'package:flutter_life_devo_app_v2/bindings/discipline_binding.dart';
import 'package:flutter_life_devo_app_v2/bindings/life_devo_detail_binding.dart';
import 'package:flutter_life_devo_app_v2/bindings/live_life_devo_binding.dart';
import 'package:flutter_life_devo_app_v2/bindings/main_binding.dart';
import 'package:flutter_life_devo_app_v2/bindings/sermon_binding.dart';
import 'package:flutter_life_devo_app_v2/views/discipline_detail/discipline_detail_page.dart';
import 'package:flutter_life_devo_app_v2/views/discipline_list/discipline_list_page.dart';
import 'package:flutter_life_devo_app_v2/views/discipline_topic_list/discipline_topic_list_page.dart';
import 'package:flutter_life_devo_app_v2/views/life_devo_detail/life_devo_detail_page.dart';
import 'package:flutter_life_devo_app_v2/views/live_life_devo_detail/live_life_devo_detail_page.dart';
import 'package:flutter_life_devo_app_v2/views/live_life_devo_list/live_life_devo_list_page.dart';
import 'package:flutter_life_devo_app_v2/views/main/main_page.dart';
import 'package:flutter_life_devo_app_v2/views/sermon_detail/sermon_detail_page.dart';
import 'package:flutter_life_devo_app_v2/views/sermon_list/sermon_list_page.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/bindings/auth_binding.dart';
import 'package:flutter_life_devo_app_v2/bindings/landing_binding.dart';
import 'package:flutter_life_devo_app_v2/views/auth/auth_page.dart';
import 'package:flutter_life_devo_app_v2/views/landing/landing_page.dart';
part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => LandingPage(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: Routes.AUTH,
      page: () => AuthPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),

    // Main components of Main page tabs are handled in main page

    GetPage(
      name: Routes.LIFE_DEVO_DETAIL,
      page: () => const LifeDevoDetailPage(),
      binding: LifeDevoDetailBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),

    // Live Life Devo
    GetPage(
      name: Routes.LIVE_LIFE_DEVO_DETAIL,
      page: () => const LiveLifeDevoDetailPage(),
      binding: LiveLifeDevoBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: Routes.LIVE_LIFE_DEVO_LIST,
      page: () => const LiveLifeDevoListPage(),
      binding: LiveLifeDevoBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),

    // Discipline
    GetPage(
      name: Routes.DISPLINE_DETAIL,
      page: () => const DisciplineDetailPage(),
      binding: DisciplineBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: Routes.DISPLINE_LIST,
      page: () => const DisciplineListPage(),
      binding: DisciplineBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: Routes.DISPLINE_TOPIC,
      page: () => const DisciplineTopicListPage(),
      binding: DisciplineBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),

    // Sermon
    GetPage(
      name: Routes.SERMON_DETAIL,
      page: () => const SermonDetailPage(),
      binding: SermonBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: Routes.SERMON_LIST,
      page: () => const SermonListPage(),
      binding: SermonBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 150),
    ),

    // GetPage(
    //   name: Routes.CHAT_DETAIL,
    //   page: () => ChatPage(),
    //   binding: ChatBinding(),
    // ),
  ];
}
