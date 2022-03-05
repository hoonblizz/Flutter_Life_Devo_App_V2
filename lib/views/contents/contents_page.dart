import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/routes/app_pages.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:get/get.dart';

const enumContentsNames = ["Sermon", "Live Life Devo", "Spiritual Discipline"];

// ignore: use_key_in_widget_constructors
class ContentsPage extends StatelessWidget {
  //const ContentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenPaddingHorizontal,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: screenPaddingVertical,
            ),
            // Life devo title
            SizedBox(
              width: double.infinity,
              child: Text(
                'Contents',
                style: TextStyle(
                  fontSize: mainPageContentsTitle,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(.8),
                ),
              ),
            ),
            SizedBox(
              height: mainPageContentsSpace,
            ),
            ...enumContentsNames.map((String contentsName) {
              return GestureDetector(
                onTap: () {
                  switch (contentsName) {
                    case "Sermon":
                      Get.toNamed(Routes.SERMON_LIST);
                      break;
                    case "Live Life Devo":
                      break;
                    case "Spiritual Discipline":
                      break;
                  }
                },
                child: Card(
                  elevation: 3,
                  color: kPrimaryColor.withOpacity(1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    height: contentsCardHeight,
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            contentsName,
                            style: TextStyle(
                                color: navBG,
                                fontSize: contentsCardTitle,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
