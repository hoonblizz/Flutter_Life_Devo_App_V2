import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReuseButton extends StatelessWidget {
  ReuseButton(
      {required this.g,
      required this.text,
      required this.color,
      required this.fontColor,
      required this.onPressed,
      required this.height});

  final Color color;
  final String text;
  final Color fontColor;
  final bool g;
  final onPressed;
  final height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: color,
        gradient: g
            ? LinearGradient(
                colors: [
                  Color(0xFFFDEAC0),
                  Color(0xFFFCBA9D),
                ],
              )
            : null,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      width: context.isPhone ? Get.width * 0.8 : Get.width * 0.6,
      height: height,
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                fontSize:
                    context.isPhone ? Get.height * 0.0175 : Get.height * 0.019,
                color: fontColor),
          )),
    );
  }
}
