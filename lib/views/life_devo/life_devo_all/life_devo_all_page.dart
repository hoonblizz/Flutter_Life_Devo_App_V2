import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/life_devo/life_devo_controller.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/year_month_calendar.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class LifeDevoAllPage extends StatefulWidget {
  const LifeDevoAllPage({Key? key}) : super(key: key);

  @override
  _LifeDevoAllPageState createState() => _LifeDevoAllPageState();
}

class _LifeDevoAllPageState extends State<LifeDevoAllPage> {
  final LifeDevoController _lifeDevoController = Get.find();

  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  dynamic _pickerOpen = false;

  @override
  void initState() {
    // 탭이 바뀔때마다 init 이 불러지는걸 확인했다.
    // controller 를 확인하고, 데이터가 없으면 불러주는 식으로 가자.
    print('Life Devo ALL Page init........!');
    super.initState();
  }

  void switchPicker() {
    setState(() {
      _pickerOpen ^= true;
    });
    print('Picker opened? ${_pickerOpen}');
  }

  void onSelectMonth(DateTime selectedTime) {
    setState(() {
      _selectedMonth = selectedTime;
    });
    print(
        'Selected Month: ${_selectedMonth.year}-${_selectedMonth.month} => Epoch: ${_selectedMonth.millisecondsSinceEpoch} to ${DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1).subtract(Duration(seconds: 10)).millisecondsSinceEpoch}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        YearMonthCalendar(
          pickerOpen: _pickerOpen,
          selectedMonth: _selectedMonth,
          onSelectMonth: onSelectMonth,
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: screenPaddingHorizontal),
          child: TextButton(
            style: TextButton.styleFrom(
              //minimumSize: Size(_width, _height),
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            ),
            onPressed: switchPicker,
            child: Text(
              DateFormat.yMMM().format(_selectedMonth),
              style: TextStyle(
                fontSize: mainPageContentsDesc,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Container(
          child: Text('All LD'),
        ),
        SizedBox(
          height: 80,
        )
      ],
    );
  }
}
