import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, this.shape = "", this.loaderSize = 35.0})
      : super(key: key);
  final String shape;
  final double loaderSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.black.withOpacity(0),
      child: Center(
        child: _loadingType(shape, loaderSize),
      ),
    );
  }

  Widget _loadingType(String shape, double loaderSize) {
    switch (shape) {
      case "CIRCLE":
        return SpinKitRing(
          color: kPrimaryColor,
          size: loaderSize,
        );
      default:
        return SpinKitFadingCube(
          color: kPrimaryColor,
          size: loaderSize,
        );
    }
  }
}
