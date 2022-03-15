import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/sermon/sermon_controller.dart';
import 'package:flutter_life_devo_app_v2/models/sermon_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SermonListPage extends StatefulWidget {
  const SermonListPage({Key? key}) : super(key: key);

  @override
  State<SermonListPage> createState() => _SermonListPageState();
}

class _SermonListPageState extends State<SermonListPage> {
  final SermonController _sermonController = Get.find();

  final _scrollController = ScrollController();

  bool isLoading = false;

  @override
  void initState() {
    // 이제 처음부터 불러오자.
    callContents();
    scrollListener();
    super.initState();
  }

  scrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          debugPrint('Scroll at the top');
        } else {
          debugPrint('Scroll at the bottom');
          callContents();
          // 코멘트 로딩을 보여주려면 좀더 내려가야함. -> 근데 이거 하면 bottom 에 한번 더 도달해서 코멘트를 두번 부르게 된다.
          //_scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  callContents() async {
    await _sermonController.getAllSermon();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _customAppBar(),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenPaddingHorizontal,
            ),
            child: Obx(
              () {
                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: screenPaddingVertical,
                      ),
                      ..._sermonController.sermonListMerged
                          .map((SermonModel el) {
                        return GestureDetector(
                          onTap: () => _sermonController.gotoContentDetail(el),
                          child: Card(
                            elevation: 3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              height: contentListCardHeight,
                              width: double.maxFinite,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        el.title,
                                        style: TextStyle(
                                            fontSize: contentListCardTitle,
                                            fontWeight: FontWeight.w600),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      DateFormat.yMMMEd().format(
                                        DateTime.fromMillisecondsSinceEpoch(el
                                            .selectedDate
                                            .millisecondsSinceEpoch),
                                      ),
                                      style: TextStyle(
                                          fontSize: contentListCardDate),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                      const SizedBox(
                        height: 30,
                      ),
                      // Loading
                      if (_sermonController.isLoadingList.value)
                        Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: double.infinity,
                          child: const LoadingWidget(
                            shape: "CIRCLE",
                            loaderSize: 26,
                          ),
                        ),

                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
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
          'Sermons',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      backgroundColor: kPrimaryColor,
    );
  }
}
