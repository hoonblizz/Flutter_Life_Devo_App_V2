import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/main/main_controller.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_comp_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LatestLifeDevo extends StatelessWidget {
  LifeDevoCompModel latestLifeDevoSession;

  LatestLifeDevo(this.latestLifeDevoSession, {Key? key}) : super(key: key);

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
          // Image.asset(
          //   'assets/nature.jpg',
          //   fit: BoxFit.cover,
          // ),

          // ListTile(
          //   leading: CircleAvatar(
          //     backgroundImage: AssetImage('assets/user.png'),
          //   ),
          //   title: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       Text(
          //         'Hossin El ghazli',
          //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          //       ),
          //       Text('31m ago',
          //           style: TextStyle(
          //               fontSize: 12,
          //               color: Colors.grey,
          //               fontWeight: FontWeight.bold)),
          //     ],
          //   ),
          // ),

          Text(
            latestLifeDevoSession.question,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(fontSize: mainPageContentsDesc),
          ),
          SizedBox(
            height: mainPageContentsSpace,
          ),
          Center(
            child: TextButton(
                style: TextButton.styleFrom(
                  //minimumSize: Size(_width, _height),
                  backgroundColor: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                ),
                onPressed: () =>
                    _mainController.gotoLifeDevoDetail(latestLifeDevoSession),
                child: Text(
                  'Continue Reading',
                  style: TextStyle(
                      fontSize: mainPageContentsDesc,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                )),
          ),

          // Likes and # of comments
          // Padding(
          //   padding: const EdgeInsets.all(12),
          //   child: Row(
          //     children: <Widget>[
          //       Row(
          //         children: <Widget>[
          //           Icon(
          //             Icons.favorite,
          //             color: Colors.red,
          //           ),
          //           SizedBox(
          //             width: 4,
          //           ),
          //           Text(
          //             "231",
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           )
          //         ],
          //       ),
          //       SizedBox(
          //         width: 24,
          //       ),
          //       Row(
          //         children: <Widget>[
          //           Icon(
          //             Icons.comment,
          //           ),
          //           SizedBox(
          //             width: 4,
          //           ),
          //           Text(
          //             "231",
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           )
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

          // Filled space
          // Container(
          //   color: Colors.red,
          //   child: Center(
          //     child: Padding(
          //       padding: const EdgeInsets.all(32),
          //       child: Text(
          //         'data test new text for flutter app',
          //         style: TextStyle(color: Colors.white),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
