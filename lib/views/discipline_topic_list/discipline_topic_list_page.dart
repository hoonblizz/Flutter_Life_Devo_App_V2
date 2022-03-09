import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/discipline/discipline_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/sermon/sermon_controller.dart';
import 'package:flutter_life_devo_app_v2/models/sermon_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DisciplineTopicListPage extends StatefulWidget {
  const DisciplineTopicListPage({Key? key}) : super(key: key);

  @override
  State<DisciplineTopicListPage> createState() =>
      _DisciplineTopicListPageState();
}

class _DisciplineTopicListPageState extends State<DisciplineTopicListPage> {
  final DisciplineController _disciplineController = Get.find();

  @override
  void initState() {
    // 이제 처음부터 불러오자.
    callContents();
    super.initState();
  }

  callContents() async {
    await _disciplineController.getDisciplineTopic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenPaddingHorizontal,
          ),
          child: Obx(
            () {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: screenPaddingVertical,
                    ),
                    ..._disciplineController.disciplineTopic.value.topicList
                        .map((el) {
                      return GestureDetector(
                        onTap: () =>
                            _disciplineController.gotoContentList(el['id']),
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
                                      el['topicName'] ?? "",
                                      style: TextStyle(
                                          fontSize: contentListCardTitle,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
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
          'Spiritual Discipline',
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
