import 'package:car_clean/constant/constant.dart';
import 'package:car_clean/pages/screens.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_calendar_widget/date_helper.dart';
import 'package:horizontal_calendar_widget/horizontal_calendar.dart';
import 'package:page_transition/page_transition.dart';

const labelMonth = 'Month';
const labelDate = 'Date';
const labelWeekDay = 'Week Day';

class SelectDateTime extends StatefulWidget {
  @override
  _SelectDateTimeState createState() => _SelectDateTimeState();
}

class _SelectDateTimeState extends State<SelectDateTime> {
  String selectedTime = '';
  String selectedDate;
  String monthString;

  DateTime firstDate;
  DateTime lastDate;
  String dateFormat = 'dd';
  String monthFormat = 'MMM';
  String weekDayFormat = 'EEE';
  List<String> order = [labelMonth, labelDate, labelWeekDay];
  bool forceRender = false;

  Color defaultDecorationColor = Colors.transparent;
  BoxShape defaultDecorationShape = BoxShape.circle;
  bool isCircularRadiusDefault = true;

  Color selectedDecorationColor = primaryColor;
  BoxShape selectedDecorationShape = BoxShape.circle;
  bool isCircularRadiusSelected = true;

  Color disabledDecorationColor = Colors.grey;
  BoxShape disabledDecorationShape = BoxShape.circle;
  bool isCircularRadiusDisabled = true;

  int minSelectedDateCount = 1;
  int maxSelectedDateCount = 1;
  RangeValues selectedDateCount;

  List<DateTime> initialSelectedDates;

  final slotList = [
    {'time': '09:00 AM'},
    {'time': '10:00 AM'},
    {'time': '11:00 AM'},
    {'time': '12:00 PM'},
    {'time': '01:00 PM'},
    {'time': '02:00 PM'},
    {'time': '03:00 PM'},
    {'time': '04:00 PM'},
    {'time': '05:00 PM'},
    {'time': '06:00 PM'},
    {'time': '07:00 PM'}
  ];

  @override
  void initState() {
    super.initState();
    const int days = 30;
    firstDate = toDateMonthYear(DateTime.now());
    lastDate = toDateMonthYear(firstDate.add(Duration(days: days - 1)));
    selectedDateCount = RangeValues(
      minSelectedDateCount.toDouble(),
      maxSelectedDateCount.toDouble(),
    );
    initialSelectedDates = feedInitialSelectedDates(minSelectedDateCount, days);
    setState(() {
      selectedDate =
          '${firstDate.day}-${convertNumberMonthToStringMonth(firstDate.month)}';
    });
  }

  List<DateTime> feedInitialSelectedDates(int target, int calendarDays) {
    List<DateTime> selectedDates = [];

    for (int i = 0; i < calendarDays; i++) {
      if (selectedDates.length == target) {
        break;
      }
      DateTime date = firstDate.add(Duration(days: i));
      if (date.weekday != DateTime.sunday) {
        selectedDates.add(date);
      }
    }
    return selectedDates;
  }

  String convertNumberMonthToStringMonth(month) {
    if (month == 1) {
      monthString = 'January';
    } else if (month == 2) {
      monthString = 'Fabruary';
    } else if (month == 3) {
      monthString = 'March';
    } else if (month == 4) {
      monthString = 'April';
    } else if (month == 5) {
      monthString = 'May';
    } else if (month == 6) {
      monthString = 'June';
    } else if (month == 7) {
      monthString = 'July';
    } else if (month == 8) {
      monthString = 'August';
    } else if (month == 9) {
      monthString = 'September';
    } else if (month == 10) {
      monthString = 'October';
    } else if (month == 11) {
      monthString = 'November';
    } else if (month == 12) {
      monthString = 'December';
    }
    return monthString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: whiteColor,
        title: Text(
          'Select Date & Time',
          style: appBarTextStyle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: blackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 1.0,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: SelectPaymentMethod(),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: 50.0,
            color: primaryColor,
            alignment: Alignment.center,
            child: Text(
              'Continue',
              style: white18BoldTextStyle,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          horizontalDatePicker(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
            height: 1.0,
            width: double.infinity,
            color: greyColor.withOpacity(0.4),
          ),
          slots(),
        ],
      ),
    );
  }

  horizontalDatePicker() {
    return HorizontalCalendar(
      key: forceRender ? UniqueKey() : Key('Calendar'),
      selectedDateTextStyle: TextStyle(color: whiteColor),
      selectedMonthTextStyle: TextStyle(color: whiteColor),
      selectedWeekDayTextStyle: TextStyle(color: whiteColor),
      spacingBetweenDates: 10.0,
      height: 105,
      padding: EdgeInsets.all(fixPadding * 2.0),
      firstDate: firstDate,
      lastDate: lastDate,
      dateFormat: dateFormat,
      weekDayFormat: weekDayFormat,
      monthFormat: monthFormat,
      defaultDecoration: BoxDecoration(
        color: defaultDecorationColor,
        shape: defaultDecorationShape,
        borderRadius: defaultDecorationShape == BoxShape.rectangle &&
                isCircularRadiusDefault
            ? BorderRadius.circular(8)
            : null,
      ),
      selectedDecoration: BoxDecoration(
        color: selectedDecorationColor,
        shape: selectedDecorationShape,
        borderRadius: selectedDecorationShape == BoxShape.rectangle &&
                isCircularRadiusSelected
            ? BorderRadius.circular(8)
            : null,
      ),
      disabledDecoration: BoxDecoration(
        color: disabledDecorationColor,
        shape: disabledDecorationShape,
        borderRadius: disabledDecorationShape == BoxShape.rectangle &&
                isCircularRadiusDisabled
            ? BorderRadius.circular(8)
            : null,
      ),
      isDateDisabled: (date) => date.weekday == DateTime.sunday,
      labelOrder: order.map(toLabelType).toList(),
      maxSelectedDateCount: maxSelectedDateCount,
      initialSelectedDates: initialSelectedDates,
      onDateSelected: (e) async {
        setState(() {
          selectedDate = '${e.day}-${convertNumberMonthToStringMonth(e.month)}';
        });
      },
    );
  }

  LabelType toLabelType(String label) {
    LabelType type;
    switch (label) {
      case labelMonth:
        type = LabelType.month;
        break;
      case labelDate:
        type = LabelType.date;
        break;
      case labelWeekDay:
        type = LabelType.weekday;
        break;
    }
    return type;
  }

  slots() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(fixPadding * 2.0),
          child: Text(
            '11 Slots',
            style: black18BoldTextStyle,
          ),
        ),
        Wrap(
          children: slotList
              .map(
                (e) => Padding(
                  padding: EdgeInsets.only(
                      left: fixPadding * 2.0, bottom: fixPadding * 2.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedTime = e['time'];
                      });
                    },
                    child: Container(
                      width: 90.0,
                      padding: EdgeInsets.all(fixPadding),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(width: 0.7, color: greyColor),
                        color: (e['time'] == selectedTime)
                            ? primaryColor
                            : whiteColor,
                      ),
                      child: Text(e['time'],
                          style: (e['time'] == selectedTime)
                              ? white14MediumTextStyle
                              : primaryColor14MediumTextStyle),
                    ),
                  ),
                ),
              )
              .toList()
              .cast<Widget>(),
        ),
      ],
    );
  }
}
