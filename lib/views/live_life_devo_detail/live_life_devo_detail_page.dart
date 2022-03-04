import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/models/live_life_devo_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveLifeDevoDetailPage extends StatefulWidget {
  const LiveLifeDevoDetailPage({Key? key}) : super(key: key);

  @override
  State<LiveLifeDevoDetailPage> createState() => _LiveLifeDevoDetailPageState();
}

class _LiveLifeDevoDetailPageState extends State<LiveLifeDevoDetailPage> {
  late YoutubePlayerController _controller;
  final LiveLifeDevoModel _curLiveLifeDevo = Get.arguments[0];
  final double spaceBetweenInputs = 35.0;
  final double horizonatalPadding = 25.0;
  final Color horizontalLineColor = Colors.grey.shade300;
  final double horizontalLineHeight = 2.0;

  @override
  void initState() {
    if (_curLiveLifeDevo.videoUrl.isNotEmpty &&
        _curLiveLifeDevo.videoId.isNotEmpty) {
      //String tempUrl = _getVideoIdFromUrl(_curLiveLifeDevo.videoUrl);
      //print('Video id is, $tempUrl');
      _controller = YoutubePlayerController(
        initialVideoId: _curLiveLifeDevo.videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      ); //..addListener(listener);
    }

    super.initState();
  }

  // String _getVideoIdFromUrl(String urlString) {
  //   final regex =
  //       RegExp(r'.*\?v=(.+?)($|[\&])', caseSensitive: false, multiLine: false);
  //   if (regex.hasMatch(urlString)) {
  //     final videoId = regex.firstMatch(urlString).group(1);
  //     return videoId;
  //   } else {
  //     return null;
  //   }
  // }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _dateFormat(DateTime selectedDate) {
    return DateFormat.yMMMMEEEEd().format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: kPrimaryColor,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: navBG,
          appBar: _customAppBar(),
          body: Container(
            color: navBG,
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    //controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        player,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenPaddingHorizontal,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: screenPaddingVertical,
                              ),
                              Text(
                                DateFormat.yMMMMEEEEd().format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        _curLiveLifeDevo.selectedDate
                                            .millisecondsSinceEpoch)),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: adminContentDetailDesc),
                              ),
                              // Title
                              Text(
                                _curLiveLifeDevo.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: adminContentDetailTitle),
                              ),

                              // 타이틀 다음이라 조금 더 공간을 둔다
                              SizedBox(
                                height: adminContentDetailSpace * 2,
                              ),

                              // Youtube player
                              SizedBox(
                                height: adminContentDetailSpace,
                              ),
                              // Contents
                              Text(
                                _curLiveLifeDevo.contentText,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: adminContentDetailDesc),
                              ),
                              SizedBox(
                                height: adminContentDetailSpace,
                              ),
                              const Divider(
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _customAppBar() {
    return AppBar(
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 4), // 오묘하게 센터가 안맞아서 그냥 넣어줌
        child: const Text(
          'Live Life Devo Detail',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: kPrimaryColor,
    );
  }

  // Widget _disciplineTitleWidget(Size screenSize) {
  //   return Container(
  //     color: kPrimary,
  //     child: Padding(
  //       padding: EdgeInsets.fromLTRB(horizonatalPadding,
  //           screenSize.height * 0.03, horizonatalPadding, horizonatalPadding),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             widget.liveLifeDevo.title,
  //             style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w700,
  //                 fontSize: kFontM),
  //           ),
  //           SizedBox(height: 5.0),
  //           Text(
  //             '${_dateFormat(widget.liveLifeDevo.selectedDate)}',
  //             style: TextStyle(
  //               fontSize: kFontS,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _disciplineContentWidget(Size screenSize) {
  //   return Padding(
  //     padding: EdgeInsets.fromLTRB(
  //         horizonatalPadding, screenSize.height * 0.06, horizonatalPadding, 0),
  //     child: Text(
  //       widget.liveLifeDevo.contentText,
  //       style: TextStyle(fontSize: kFontS, fontWeight: FontWeight.w500),
  //     ),
  //   );
  // }
}
