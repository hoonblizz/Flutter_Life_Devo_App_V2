import 'package:flutter_life_devo_app_v2/bindings/main_binding.dart';
import 'package:flutter_life_devo_app_v2/views/main/main_page.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/bindings/auth_binding.dart';
import 'package:flutter_life_devo_app_v2/bindings/landing_binding.dart';
import 'package:flutter_life_devo_app_v2/views/auth/auth_page.dart';
import 'package:flutter_life_devo_app_v2/views/home/home_page.dart';
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
  ];
}
