import 'dart:ui';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/loader.dart';
import 'package:carcheks/view/screens/customer/wallet.dart';
import 'package:flutter/cupertino.dart';

/*import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';*/
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'wheels_tyres_1.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class ChooseDate extends StatefulWidget {
  Garage? garage;
  String? notes;

  ChooseDate({this.garage, this.notes});

  @override
  _ChooseDateState createState() => _ChooseDateState();
}

class _ChooseDateState extends State<ChooseDate> {
  List<String> times = [];
  List<ChooseTime> timeList = [];
  int? selectedIndex;
  bool isloading = false;

  // DateTime? selectedDay = DateTime.now();

  String? time = "";

  // List <NeatCleanCalendarEvent>? selectedEvent;

  List<String> timeSlots = [];

  List<String> generateTimeSlots(String startTime, String endTime) {
    print("Start Time : ${startTime}\nEnd Time: ${endTime}");
    List<String> timeSlots = [];
    final dateFormat = DateFormat('hh:mm');

    DateTime startDateTime = dateFormat.parse(startTime);
    DateTime endDateTime = dateFormat.parse(endTime);

    while (startDateTime.isBefore(endDateTime)) {
      timeSlots.add(dateFormat.format(startDateTime));
      startDateTime = startDateTime.add(Duration(hours: 1));
    }

    return timeSlots;
  }

  @override
  void initState() {
    // TODO: implement initState
    // selectedEvent = events[selectedDay] ?? [];
    //getGarage();
    //getTimeSlots();
    timeSlots = generateTimeSlots(
      widget.garage!.openingTime,
      widget.garage!.closingTime,
    );
    //  timeSlots = generateTimeSlots("09:30", "05:00");
    super.initState();
  }

  GarageProvider garageProvider = locator<GarageProvider>();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  getCalender() {
    return Container(
      height: 425,
      width: 317,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TableCalendar(
        headerVisible: true,
        daysOfWeekVisible: true,
        daysOfWeekHeight: 50,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: TextStyle().fontFamily,
          ),
          weekdayStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: TextStyle().fontFamily,
          ),
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: TextStyle().fontFamily,
          ),
          formatButtonVisible: false,
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: TextStyle().fontFamily,
          ),
          weekendTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: TextStyle().fontFamily,
          ),
          selectedTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: TextStyle().fontFamily,
          ),
          rangeEndTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: TextStyle().fontFamily,
          ),
          rangeStartTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: TextStyle().fontFamily,
          ),
          todayTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: TextStyle().fontFamily,
            color: Colors.white,
          ),
          outsideTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: TextStyle().fontFamily,
            color: Color(0xFFBFBFBF),
          ),
          withinRangeTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: TextStyle().fontFamily,
            color: Color(0xFFBFBFBF),
          ),
          disabledTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: TextStyle().fontFamily,
            color: Color(0xFFBFBFBF),
          ),
        ),
        rowHeight: 50,
        firstDay: DateTime.utc(2010, 10, 20),
        lastDay: DateTime.utc(2040, 10, 20),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.
          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // getTimeSlots();
    print("againgprinttimes${times}");
    //print("againgprinttimes${times[5]}");
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.PRIMARY_COLOR,
        title: Text(
          'Choose Date And Time',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.9,
            child: Container(
              color: ColorResources.PRIMARY_COLOR,
              child: Column(
                children: [
                  SizedBox(height: 50),

                  getCalender(),
                  SizedBox(height: 20),
                  Text(
                    "Garrage Timing Slots",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  /*Container(
                    height: 355,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10,30,10,5),
                      child: Calendar(
                        startOnMonday: true,
                        selectedColor: Colors.blue,
                        todayColor: Colors.red,
                        */
                  /* eventColor: Colors.green,
                          eventDoneColor: Colors.amber,*/
                  /*
                        bottomBarColor: Colors.deepOrange,
                        //initialDate: DateTime.now(),
                        initialDate: DateTime.now(),


                        onRangeSelected: (range) {

                          print('selected Day ${range.from},${range.to}');
                        },
                        onDateSelected: (date){
                          return _handleData(date);
                        },
                       // events: events,
                        isExpanded: true,
                        dayOfWeekStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        bottomBarTextStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        hideBottomBar: false,
                        hideArrows: false,

                        weekDays: ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'],
                      ),
                    ),
                  ),*/
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            selectedIndex = index;
                            time = timeSlots[index].toString();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedIndex == index
                                  ? Colors.green[300]
                                  : Colors.white24,
                            ),
                            child: Text(
                              timeSlots[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: ProsteBezierCurve(
                position: ClipPosition.top,
                list: [
                  BezierCurveSection(
                    start: Offset(screenWidth, 0),
                    top: Offset(screenWidth / 2, 30),
                    end: Offset(0, 0),
                  ),
                ],
              ),
              child: Container(color: Colors.white, height: 100),
            ),
          ),
          Positioned(
            bottom: 30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: CustomButton(
                buttonText: "Continue",
                isEnable: true,
                onTap: () {
                  getLoader(context, isloading);
                  DateTime _currentDate = DateTime.now();
                  print("Selected Date: " + _selectedDay.toString());
                  var formattedDate;

                  if (_selectedDay != null && _selectedDay != _currentDate) {
                    DateTime? date;
                    if (_selectedDay!.isBefore(DateTime.now())) {
                      date = _selectedDay;
                      formattedDate = DateFormat(
                        "yyyy-MM-dd",
                      ).format(DateTime.now());
                      dismissLoader(context);
                      SnackBar snackBar = SnackBar(
                        content: Text(
                          "Please Select todays date or a upcoming date",
                        ),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      date = _selectedDay;
                      formattedDate = DateFormat(
                        "yyyy-MM-dd",
                      ).format(_selectedDay!);
                      if (time == null || time == "") {
                        dismissLoader(context);
                        SnackBar snackBar = SnackBar(
                          content: Text(
                            "Please Select Upcoming time for appointment!",
                          ),
                          duration: Duration(seconds: 3),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        dismissLoader(context);
                        //  model.saveTransactions(created: "$date}",createdBy: "User",active: true,updated: "${date}" ,updatedBy:"User");
                        Navigator.pushNamed(
                          context,
                          AppRoutes.estimate_details,
                          arguments: {
                            widget.garage,
                            formattedDate.toString(),
                            time,
                            widget.notes,
                          },
                        );
                        // Navigator.pushNamed(context,AppRoutes.payment,arguments: {widget.garage,formattedDate.toString(),time,widget.notes});
                      }
                    }
                  } else {
                    dismissLoader(context);
                    SnackBar snackBar = SnackBar(
                      content: Text(
                        "Please Select todays date or a upcoming date",
                      ),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                  /* if (_selectedDay == null || _selectedDay == "") {
                    dismissLoader(context);
                    SnackBar snackBar = SnackBar(
                      content:
                          Text("Please select Date and time for appointment!"),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    var date = DateTime.parse(_selectedDay.toString());
                    var formattedDate =
                        "${date.year}-${date.month}-${date.day}";


                    print(
                        "Selected Formatted Date: " + formattedDate.toString());

                    if (date.year == DateTime.now().year &&
                        date.month >= DateTime.now().month &&
                        date.day >= DateTime.now().day) {
                      if (time != "" || time != null) {
                        var selectedtime = time?.split(':');
                        var currenthour = DateTime.now().hour as int;
                        int selectedtimeee = int.parse(selectedtime![0]);
                        int ampm = selectedtime[0] != "12" &&
                            selectedtime[1].contains("PM")
                            ? selectedtimeee + 12
                            : selectedtimeee;
                        if (date.year == DateTime.now().year &&
                            date.month == DateTime.now().month &&
                            date.day == DateTime.now().day &&
                            ampm > currenthour) {
                          dismissLoader(context);
                          Navigator.pushNamed(context,AppRoutes.payment,arguments: {widget.garage,formattedDate.toString(),time,widget.notes});
                          */ /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => Wallet(
                                        garage: widget.garage,
                                        date: formattedDate.toString(),
                                        time: time,
                                        notes: widget.notes,
                                      )));*/ /*
                        } else if (date.year == DateTime.now().year &&
                            date.month >= DateTime.now().month &&
                            date.day > DateTime.now().day) {
                          dismissLoader(context);
                          Navigator.pushNamed(context,AppRoutes.payment,arguments: {widget.garage,formattedDate.toString(),time,widget.notes});

                         */ /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => Wallet(
                                        garage: widget.garage,
                                        date: formattedDate.toString(),
                                        time: time,
                                        notes: widget.notes,
                                      )));*/ /*
                        } else {
                          dismissLoader(context);
                          SnackBar snackBar = SnackBar(
                            content: Text(
                                "Please Select Upcoming time for appointment!"),
                            duration: Duration(seconds: 3),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {}
                    } else {
                      dismissLoader(context);
                      SnackBar snackBar = SnackBar(
                        content: Text(
                            "Please Select todays date or a upcoming date"),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }*/
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  getTimeSlots() {
    Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime,
      TimeOfDay endTime,
      Duration step,
    ) sync* {
      var hour = startTime.hour;
      var minute = startTime.minute;

      do {
        yield TimeOfDay(hour: hour, minute: minute);
        minute += step.inMinutes;
        while (minute >= 60) {
          minute -= 60;
          hour++;
        }
      } while (hour < endTime.hour ||
          (hour == endTime.hour && minute <= endTime.minute));
    }

    final garageid = widget.garage!.id;
    print(
      "garageTimes:, ${widget.garage!.openingTime}, ${widget.garage!.closingTime}",
    );

    var garageCtime = widget.garage!.closingTime.split(':');
    var garageOtime = widget.garage!.openingTime.split(':');
    var opehrs = 0;
    var clohrs = 0;
    if (widget.garage!.openingTime.contains("AM") &&
        widget.garage!.closingTime.contains("PM")) {
      opehrs = (int.parse(garageOtime[0].trim()));
      clohrs = (int.parse(garageCtime[0].trim()) + 12);
    } else if (widget.garage!.openingTime.contains("PM") &&
        widget.garage!.closingTime.contains("AM")) {
      opehrs = (int.parse(garageOtime[0].trim()) + 12);
      clohrs = (int.parse(garageCtime[0].trim()));
    }

    final startTime = TimeOfDay(
      hour: opehrs,
      minute: int.parse(garageOtime![1].replaceAll(new RegExp(r'[^0-9]'), '')),
    );
    final endTime = TimeOfDay(
      hour: clohrs,
      minute: int.parse(garageCtime![1].replaceAll(new RegExp(r'[^0-9]'), '')),
    );
    final step = Duration(minutes: 60);
    times = getTimes(
      startTime,
      endTime,
      step,
    ).map((tod) => tod.format(context)).toList();
  }

  /*void getGarage() async{
      garage = await garageProvider.getGarageByGarageId(widget.garage!);

  }*/
}

class ChooseTime {
  String time;
  bool isSelected;

  ChooseTime(this.time, this.isSelected);
}
