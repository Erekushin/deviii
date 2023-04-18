import 'package:devita/helpers/gvariables.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CalendarListWidget extends StatefulWidget {
  final Function(String)? onPressed;

  const CalendarListWidget({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  _CalendarListWidgetState createState() => _CalendarListWidgetState();
}

class _CalendarListWidgetState extends State<CalendarListWidget> {
  int monthLength = 0;
  final calendarDayList = [].obs;
  var currentMonthName = ''.obs;
  var currentMonth = 11;
  var currentYear = 2021;
  var today = DateTime.now();
  late AutoScrollController controller;
  int indexPosition = 0;
  // late int selectedIndex = 0;

  final scrollDirection = Axis.horizontal;
  @override
  void initState() {
    super.initState();
    currentYear = today.year;
    currentMonth = today.month;
    currentMonthName.value = DateFormat('MMMM').format(today);
    controller = AutoScrollController(
        viewportBoundaryGetter: () => const Rect.fromLTRB(0, 0, 0, 0),
        axis: scrollDirection);
    calendarScrollInit();
  }

  scrollToCounter() async {
    await controller.scrollToIndex(indexPosition,
        preferPosition: AutoScrollPosition.middle);
    controller.highlight(indexPosition);
  }

  ///Horzintal calendar init
  calendarScrollInit() {
    setState(() {
      calendarDayList.clear();
      monthLength = DateTime(currentYear, currentMonth + 1, 0).day;

      if (currentMonth == today.month) {
        for (var i = 0; i < monthLength; i++) {
          var obj = {"dayInt": 1 + i, "dayStr": getDayName(i)};
          calendarDayList.add(obj);
          setState(() {
            indexPosition = today.day - 1;
            GlobalVariables.selectedDays.value = today.day - 1;
          });
          scrollToCounter();
        }
      } else {
        for (var i = 0; i < monthLength; i++) {
          var obj = {"dayInt": 1 + i, "dayStr": getDayName(i)};
          calendarDayList.add(obj);
          setState(() => indexPosition = 0);
          scrollToCounter();
        }
      }
    });
  }

  getDayName(int i) {
    var today = DateTime(currentYear, currentMonth);
    var tommorow = today.add(Duration(days: i));
    var formatted = DateFormat('EEEE').format(tommorow).first3();
    return formatted;
  }

  ///Change to next month
  addMonth() {
    GlobalVariables.selectedDays.value = -1;

    if (currentMonth == 12) {
      currentYear = currentYear + 1;
      currentMonth = 1;
      changeMonth();
    } else {
      currentMonth = currentMonth + 1;
      changeMonth();
    }
  }

  ///Change to previous month
  subMonth() {
    GlobalVariables.selectedDays.value = -1;
    if (currentMonth == 1) {
      currentYear = currentYear - 1;
      currentMonth = 12;
      changeMonth();
    } else {
      if (today.month <= currentMonth - 1 && today.year == currentYear) {
        currentMonth = currentMonth - 1;
        changeMonth();
      } else if (today.year < currentYear) {
        currentMonth = currentMonth - 1;
        changeMonth();
      }
    }
  }

  ///Month changer Method
  changeMonth() {
    var changedDate = DateTime(currentYear, currentMonth, 1);
    var formatted = DateFormat('MMMM').format(changedDate);
    currentMonthName.value = formatted;
    calendarScrollInit();
  }

  ///View Widget Build
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GlobalVariables.gHeight - 200,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.navigate_before,
                  size: 35,
                ),
                onPressed: () {
                  setState(() {
                    subMonth();
                  });
                },
              ),
              Obx(
                () => Text(
                  currentMonthName.value + ' ' + currentYear.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.navigate_next,
                  size: 35,
                ),
                onPressed: () {
                  setState(() {
                    addMonth();
                  });
                },
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: SizedBox(
              height: 80,
              child: Obx(
                () => ListView.builder(
                  scrollDirection: scrollDirection,
                  controller: controller,
                  itemCount: calendarDayList.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(5),
                  itemBuilder: (con, index) {
                    return _wrapScrollTag(
                      index: index,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            GlobalVariables.selectedDays.value = index;
                            DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                            String dateNow = dateFormat.format(
                                DateTime(currentYear, currentMonth, index + 1));
                            if (widget.onPressed != null) {
                              widget.onPressed!(dateNow);
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 5, left: 5),
                          padding: const EdgeInsets.all(10),
                          width: GlobalVariables.gWidth / 6,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                12.0,
                              ),
                            ),
                            color: GlobalVariables.selectedDays.value == index
                                ? CoreColor().appGreen
                                : CoreColor().grey,
                          ),
                          child: Column(
                            children: [
                              Text(
                                calendarDayList[index]["dayStr"],
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                '${calendarDayList[index]["dayInt"]}',
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrapScrollTag({required int index, required Widget child}) =>
      AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.1),
      );
}
