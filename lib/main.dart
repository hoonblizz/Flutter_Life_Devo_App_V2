import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';
import 'package:flutter_life_devo_app_v2/theme/app_theme.dart';
import 'package:flutter_life_devo_app_v2/translations/app_translations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // For inappwebview

  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }

  Get.put(GlobalController());

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: Routes.INITIAL,
    // theme: lightTheme,
    // darkTheme: darkTheme,
    themeMode: ThemeMode.light,
    defaultTransition: Transition.fade,
    getPages: AppPages.pages,
    locale: const Locale('pt', 'BR'),
    translationsKeys: AppTranslation.translationList,
  ));
}
