//import 'dart:io';

//import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AuthInAppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
  }

  // inappbrowser 로 로그인 / 사인업을 마치면 여기에 코드와 함께 뜬다.
  // 예를들어, https://bclifedevo.com/?code=d30f6e3f-00ef-471d-ae0f-0b918f420f63
  @override
  Future onLoadStop(url) async {
    print("Stopped $url");
    // https://bclifedevo.com 으로 시작하면 로그인이 완료 되었다는걸로 간주하고, 브라우저를 종료 시키자.
    if (url.toString().startsWith("https://bclifedevo.com")) {
      close();
    }
  }

  @override
  void onLoadError(url, code, message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser closed!");
  }
}
