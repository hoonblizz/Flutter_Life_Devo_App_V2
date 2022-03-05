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

  List<SermonModel> _sermonList = [];
  bool isLoading = false;

  @override
  void initState() {
    // 이제 처음부터 불러오자.
    callInit();
    super.initState();
  }

  startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  callInit() async {
    startLoading();
    List<SermonModel> _tempList = await _sermonController.getAllSermon();
    setState(() {
      _sermonList = _tempList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
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
                    ..._sermonList.map((SermonModel el) {
                      return GestureDetector(
                        //onTap: () => _lifeDevoController.gotoLifeDevoDetail(el),
                        child: Card(
                          elevation: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            height: contentListCardHeight,
                            width: double.maxFinite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          .selectedDate.millisecondsSinceEpoch),
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
                  ],
                ),
              ),
            ),

            // Loading
            if (isLoading) const LoadingWidget(),
          ],
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
      backgroundColor: kPrimaryColor,
    );
  }
}
