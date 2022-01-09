import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  Widget childWidget;
  CustomAppBar(this.childWidget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: customAppBarHeight,
      color: kPrimaryColor,
      child: childWidget,
    );
  }
}
