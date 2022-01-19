import 'package:flutter/material.dart';
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
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  dynamic _pickerOpen = false;

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
      ],
    );
  }
}
