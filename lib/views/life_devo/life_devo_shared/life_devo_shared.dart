import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/life_devo/life_devo_controller.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_comp_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/year_month_calendar.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class LifeDevoSharedPage extends StatefulWidget {
  const LifeDevoSharedPage({Key? key}) : super(key: key);

  @override
  _LifeDevoSharedPageState createState() => _LifeDevoSharedPageState();
}

class _LifeDevoSharedPageState extends State<LifeDevoSharedPage> {
  final LifeDevoController _lifeDevoController = Get.find();

  dynamic _pickerOpen = false;

  @override
  void initState() {
    // 탭이 바뀔때마다 init 이 불러지는걸 확인했다.
    // controller 를 확인하고, 데이터가 없으면 불러주는 식으로 가자.
    if (_lifeDevoController.sharedLifeDevoList.isEmpty) {
      _lifeDevoController.getSharedLifeDevo();
    }

    super.initState();
  }

  void switchPicker() {
    setState(() {
      _pickerOpen ^= true;
      //print('Picker opened? ${_pickerOpen}');
      if (!_pickerOpen) {
        _lifeDevoController.getSharedLifeDevo();
      }
    });
  }

  void onSelectMonth(DateTime selectedTime) {
    _lifeDevoController.onChangeMonthForTabShared(selectedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      //mainAxisSize: MainAxisSize.min,
      children: [
        // Life devo 리스트
        Obx(() {
          List<LifeDevoCompModel> _sessionList =
              _lifeDevoController.sharedLifeDevoList;

          if (_lifeDevoController.isTabSharedLoading.value) {
            return const LoadingWidget();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 50,
                horizontal: screenPaddingHorizontal,
              ), // 밑에 캘린더 버튼 보이도록
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _sessionList.map((LifeDevoCompModel el) {
                  return GestureDetector(
                    onTap: () => _lifeDevoController.gotoLifeDevoDetail(el),
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

                            // 작성자
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  el.userName,
                                  style: TextStyle(
                                    fontSize: contentListCardDate,
                                  ),
                                ),
                                Text(
                                  DateFormat.yMMMEd().format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        el.startDateEpoch),
                                  ),
                                  style: TextStyle(
                                    fontSize: contentListCardDate,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 캘린더
            Obx(() {
              return YearMonthCalendar(
                pickerOpen: _pickerOpen,
                selectedMonth:
                    _lifeDevoController.selectedMonthForTabShared.value,
                onSelectMonth: onSelectMonth,
              );
            }),
            // 캘린더 버튼
            Container(
              alignment: Alignment.topRight,
              padding:
                  EdgeInsets.symmetric(horizontal: screenPaddingHorizontal),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                ),
                onPressed: switchPicker,
                child: Obx(
                  () {
                    return Text(
                      _pickerOpen
                          ? 'Close'
                          : DateFormat.yMMM().format(_lifeDevoController
                              .selectedMonthForTabShared.value),
                      style: TextStyle(
                        fontSize: mainPageContentsDesc,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
