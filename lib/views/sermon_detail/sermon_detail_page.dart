import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/models/sermon_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SermonDetailPage extends StatefulWidget {
  const SermonDetailPage({Key? key}) : super(key: key);

  @override
  State<SermonDetailPage> createState() => _SermonDetailPageState();
}

class _SermonDetailPageState extends State<SermonDetailPage> {
  late YoutubePlayerController _controller;
  final SermonModel _curSermon = Get.arguments[0];
  final double spaceBetweenInputs = 35.0;
  final double horizonatalPadding = 25.0;
  final Color horizontalLineColor = Colors.grey.shade300;
  final double horizontalLineHeight = 2.0;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: _curSermon.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    ); //..addListener(listener);

    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
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
                                        _curSermon.selectedDate
                                            .millisecondsSinceEpoch)),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: adminContentDetailDesc),
                              ),
                              // Title
                              Text(
                                _curSermon.title,
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
                                _curSermon.contentText,
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
          'Sermon Detail',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: kPrimaryColor,
    );
  }
}
