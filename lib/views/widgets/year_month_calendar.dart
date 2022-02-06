import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:intl/intl.dart';

class YearMonthCalendar extends StatefulWidget {
  const YearMonthCalendar(
      {required this.selectedMonth,
      required this.onSelectMonth,
      required this.pickerOpen,
      Key? key})
      : super(key: key);
  //final int pickerYear;
  final DateTime selectedMonth;
  final Function onSelectMonth;
  final bool pickerOpen;

  @override
  _YearMonthCalendarState createState() => _YearMonthCalendarState();
}

class _YearMonthCalendarState extends State<YearMonthCalendar> {
  int _pickerYear = DateTime.now().year;

  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(_pickerYear, i, 1);
      final backgroundColor = dateTime.isAtSameMomentAs(widget.selectedMonth)
          ? kPrimaryColor
          : Colors.transparent;

      final textColor = dateTime.isAtSameMomentAs(widget.selectedMonth)
          ? navBG
          : Colors.black;
      months.add(
        Expanded(
          child: AnimatedSwitcher(
            duration: kThemeChangeDuration,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: TextButton(
              key: ValueKey(backgroundColor),
              onPressed: () => widget.onSelectMonth(dateTime),
              style: TextButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: const StadiumBorder(),
              ),
              child: Text(
                DateFormat('MMM').format(dateTime),
                style: TextStyle(
                  fontSize: mainPageContentsDesc,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return months;
  }

  List<Widget> generateMonths() {
    return [
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(1, 6),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(7, 12),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      elevation: 3,
      child: AnimatedSize(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: widget.pickerOpen ? null : 0.0,
          color: navBG,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _pickerYear = _pickerYear - 1;
                      });
                    },
                    icon: const Icon(Icons.navigate_before_rounded),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _pickerYear.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _pickerYear = _pickerYear + 1;
                      });
                    },
                    icon: const Icon(Icons.navigate_next_rounded),
                  ),
                ],
              ),
              ...generateMonths(),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
