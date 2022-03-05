import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/main/main_controller.dart';
import 'package:flutter_life_devo_app_v2/models/sermon_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LatestSermon extends StatelessWidget {
  SermonModel latestSermon;

  LatestSermon(this.latestSermon, {Key? key}) : super(key: key);

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
          (latestSermon.thumbnailUrl.isNotEmpty)
              ? SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    latestSermon.thumbnailUrl,
                    fit: BoxFit.fitWidth,
                  ))
              : Container(),

          SizedBox(
            height: mainPageContentsSpace,
          ),
          Text(
            latestSermon.title,
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
                  _mainController.gotoSermonDetailPage(latestSermon);
                },
                child: Text(
                  'Watch the video',
                  style: TextStyle(
                      fontSize: mainPageContentsDesc,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                )),
          ),
        ],
      ),
    );
  }
}
