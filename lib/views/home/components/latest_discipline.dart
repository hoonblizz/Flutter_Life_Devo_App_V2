import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/main/main_controller.dart';
import 'package:flutter_life_devo_app_v2/models/discipline_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LatestDiscipline extends StatelessWidget {
  DisciplineModel latestDiscipline;

  LatestDiscipline(this.latestDiscipline, {Key? key}) : super(key: key);

  final MainController _mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          vertical: mainPageContentsSpace, horizontal: mainPageContentsSpace),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: mainPageContentsDivider),
              bottom: BorderSide(color: mainPageContentsDivider))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Thumbnail image
          (latestDiscipline.thumbnailUrl.isNotEmpty)
              ? SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    latestDiscipline.thumbnailUrl,
                    fit: BoxFit.fitWidth,
                  ))
              : Container(),

          SizedBox(
            height: mainPageContentsSpace,
          ),
          Text(
            latestDiscipline.title,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(fontSize: mainPageContentsDesc),
          ),
          SizedBox(
            height: mainPageContentsSpace,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                //minimumSize: Size(_width, _height),
                backgroundColor: kPrimaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              ),
              onPressed: () {
                _mainController.gotoDisciplineDetailPage(latestDiscipline);
              },
              child: Text(
                'Watch the video',
                style: TextStyle(
                    fontSize: mainPageContentsDesc,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
