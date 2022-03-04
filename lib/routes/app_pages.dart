import 'package:flutter_life_devo_app_v2/bindings/chat_detail_binding.dart';
import 'package:flutter_life_devo_app_v2/bindings/life_devo_detail_binding.dart';
import 'package:flutter_life_devo_app_v2/bindings/main_binding.dart';
import 'package:flutter_life_devo_app_v2/views/chat/chat_page.dart';
import 'package:flutter_life_devo_app_v2/views/life_devo_detail/life_devo_detail_page.dart';
import 'package:flutter_life_devo_app_v2/views/live_life_devo_detail/live_life_devo_detail_page.dart';
import 'package:flutter_life_devo_app_v2/views/main/main_page.dart';
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

    GetPage(
      name: Routes.LIVE_LIFE_DEVO_DETAIL,
      page: () => const LiveLifeDevoDetailPage(),
      //binding: LiveLifeDevoDetailBinding(),
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
