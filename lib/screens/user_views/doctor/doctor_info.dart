import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/user_views/doctor/event.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DoctorInformtaion extends StatefulWidget {
  const DoctorInformtaion({Key? key, required this.docId}) : super(key: key);

  final String docId;

  @override
  _DoctorInformtaionState createState() => _DoctorInformtaionState();
}

class _DoctorInformtaionState extends State<DoctorInformtaion> {
  List<String> speacialities = [
    "Neurocritical",
    "Geriatric",
    "Headache",
  ];
  var doctorInfo = {};
  int monthLength = 0;
  // var calendarDayList = [].obs; //here is must be obx
  final calendarDayList = [].obs;
  var currentMonthName = ''.obs;
  var currentMonth = 11;
  var currentYear = 2021;
  var today = DateTime.now();
  List eventList = [];
  List showList = [].obs;
  List reviewList = [].obs;
  final userDescriptionController = TextEditingController();
  RxInt selectedIndex = 0.obs;
  late final _ratingController;
  late double _rating;
  final double _initialRating = 1;
  String reviewTextFieldValue = "";
  bool isReviewBtnEnabled = true;
  @override
  void initState() {
    getDoctorData(widget.docId);
    getDoctorReview(widget.docId);
    super.initState();
    currentYear = today.year;
    currentMonth = today.month;
    print("currentMonth: $currentMonth");
    currentMonthName.value = DateFormat('MMMM').format(today);
    calendarScrollInit();
    _ratingController = TextEditingController(text: '3.0');
    _rating = _initialRating;
  }

  orderCreate(id, description) {
    var bodyData = {
      "timesheet_id": id,
      "description": description,
    };
    print("tsag awsan: $bodyData");
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}calendar/user/order/create', true)
        .then((data) {
      var response = json.decode(data.body);
      if (response['code'] == 200) {
        setState(() {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              Get.back();
            });
          });
          userDescriptionController.text = '';
        });
      } else {
        Get.snackbar(
          gWarning,
          response['status'],
          colorText: Colors.white,
        );
      }
    });
  }

  getDoctorEvent() {
    String startDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    String endDate = DateFormat('yyyy-MM-dd')
        .format(DateTime(kToday.year, kToday.month + 1, 0))
        .toString();
    var bodyData = {
      "emp_id": int.parse(widget.docId),
      "start_date": startDate,
      "end_date": endDate,
    };
    print(bodyData);
    Services()
        .postRequest(
            json.encode(bodyData), '${CoreUrl.baseUrl}calendar/user/list', true)
        .then((data) {
      print('manlai');
      print(data.body);
      var response = json.decode(data.body);
      print(response);

      setState(() {
        print(eventList);
        eventList = response['result']['items'];
        sortShowList(startDate);
      });
    });
  }

  sortShowList(day) {
    showList.clear();
    for (var item in eventList) {
      if (item['date'] == day) {
        setState(() {
          showList.add(item);
        });
      }
    }
  }

  ///sda

  ///Horzintal calendar init
  calendarScrollInit() {
    setState(() {
      calendarDayList.clear();
      monthLength = DateTime(currentYear, currentMonth + 1, 0).day;

      if (currentMonth == today.month) {
        for (var i = 0; i < monthLength - (today.day - 1); i++) {
          var obj = {"dayInt": today.day + i, "dayStr": getDayName(i)};
          calendarDayList.add(obj);
        }
      } else {
        for (var i = 0; i < monthLength; i++) {
          var obj = {"dayInt": 1 + i, "dayStr": getDayName(i)};
          calendarDayList.add(obj);
        }
      }
    });
  }

  getDayName(int i) {
    var today = DateTime.now();
    var tommorow = today.add(Duration(days: i));
    var formatted = DateFormat('EEEE').format(tommorow).first3();
    return formatted;
  }

  ///Change to next month
  addMonth() {
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

  ///Get doctor data by Id
  getDoctorData(id) {
    var bodyData = {"id": int.tryParse(id)};
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}calendar/user/emp/get', true)
        .then(
      (data) {
        var response = json.decode(data.body);

        setState(
          () {
            doctorInfo =
                response["code"] == 200 ? response['result']['items'] : {};
          },
        );
      },
    );
  }

  ///View Widget Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColor().backgroundNew,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          leadingWidth: 80,
          titleSpacing: 0.0,
          title: Text(
            'r101082'.coreTranslationWord(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: SingleChildScrollView(
        child: doctorInfo["id"] == null
            ? const CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    width: GlobalVariables.gWidth,
                    decoration: BoxDecoration(
                      color: CoreColor().backgroundContainer,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: 150,
                          child: ClipPolygon(
                            sides: 6,
                            borderRadius: 8.0,
                            rotate: 60.0,
                            boxShadows: const [],
                            child: doctorInfo['profile_img'] == null
                                ? Image.asset('assets/images/userprofile.png')
                                : CachedNetworkImage(
                                    imageUrl: CoreUrl.imageUrl +
                                        doctorInfo["profile_img"],
                                    fit: BoxFit.fitWidth,
                                    width: 40,
                                    height: 40,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            "assets/images/userprofile.png"),
                                  ),
                          ),
                        ),
                        Text(
                          doctorInfo["first_name"] +
                              ' ' +
                              doctorInfo["last_name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'r101277'.coreTranslationWord(),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: CoreColor().appGreen,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  Text(
                                    '4.5',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'r101278'.coreTranslationWord(),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),
                        MaterialButton(
                          color: CoreColor().appGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38.0),
                          ),
                          onPressed: () {
                            setState(() {
                              // Get.to(() => CalendarScreen());
                              getDoctorEvent();
                              selectedIndex.value = 0;
                              calendar();
                            });
                          },
                          child: Text(
                            'r101284'.coreTranslationWord(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  header('r101188'.coreTranslationWord()),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: tagLanguages('languages'),
                  ),
                  // const Divider(
                  //   color: Colors.white38,
                  // ),
                  // const SizedBox(height: 10),
                  const Divider(
                    color: Colors.white38,
                  ),
                  header('r101285'.coreTranslationWord()),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: tagSpecialities(),
                  ),
                  const Divider(
                    color: Colors.white38,
                  ),
                  header('r101182'.coreTranslationWord()),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: tagEducation(),
                  ),
                  const Divider(
                    color: Colors.white38,
                  ),
                  const SizedBox(height: 5),
                  header('r101286'.coreTranslationWord()),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: tagCertification(),
                  ),
                  const Divider(
                    color: Colors.white38,
                  ),
                  const SizedBox(height: 5),
                  header('r101287'.coreTranslationWord()),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: tagProjects(),
                  ),
                  const SizedBox(height: 5),
                  const Divider(
                    color: Colors.white38,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      header('r101288'.coreTranslationWord()),
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        padding: const EdgeInsets.all(5),
                        width: 120,
                        decoration: BoxDecoration(
                          color: CoreColor().appGreen,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              //open review writing page
                              // Get.to(() => const DoctorInformtaion());
                            });
                          },
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                writeReview();
                                // Get.to(() => const DoctorInformtaion());
                              });
                            },
                            child: Text(
                              'r101289'.coreTranslationWord(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  colList(),
                  // Container(
                  //   alignment: Alignment.center,
                  //   child: const Text('See all review'),
                  // ),
                  const SizedBox(height: 50),
                ],
              ),
      ),
    );
    //     ],
    //   ),
    // );
  }

  Widget tagLanguages(key) {
    var drInfo = doctorInfo['profile']['profiles'];
    var keyInfo = [];
    for (var i = 0; i < drInfo.length; i++) {
      if (drInfo[i]["key"] == key) {
        keyInfo = drInfo[i]["values"];
      }
    }
    return keyInfo.isNotEmpty
        ? SizedBox(
            height: 50,
            child: ListView.builder(
              itemBuilder: (con, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      // Get.to(() => const DoctorInformtaion());
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      color: CoreColor().backgroundContainer,
                    ),
                    child: Text(
                      keyInfo[index],
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
              itemCount: keyInfo.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(5),
              scrollDirection: Axis.horizontal,
            ),
          )
        : const Text("");
  }

  Widget tagSpecialities() {
    var specialtieis = doctorInfo['specialists'];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        itemBuilder: (con, index) {
          return InkWell(
            onTap: () {
              setState(() {
                // Get.to(() => const DoctorInformtaion());
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                color: CoreColor().backgroundContainer,
              ),
              child: Text(
                //by key bug
                speacialities[index],
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          );
        },
        itemCount: specialtieis.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(5),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  tagEducation() {
    var drInfo = doctorInfo['profile']['profiles'];
    var keyInfo = [];
    for (var i = 0; i < drInfo.length; i++) {
      if (drInfo[i]["key"] == 'education') {
        keyInfo = drInfo[i]["values"];
      }
    }
    return Row(
      children: <Widget>[
        for (var item in keyInfo)
          // Icon(
          //   Icons.account_circle,
          //   size: 30,
          // ),
          Text(
            item['header'] + ', ',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
      ],
    );
  }

  tagCertification() {
    var drInfo = doctorInfo['profile']['profiles'];
    var keyInfo = [];
    for (var i = 0; i < drInfo.length; i++) {
      if (drInfo[i]["key"] == 'certificates') {
        keyInfo = drInfo[i]["values"];
      }
    }
    return Row(
      children: <Widget>[
        for (var item in keyInfo)
          // Icon(
          //   Icons.account_circle,
          //   size: 30,s
          // ),
          Text(
            item + ', ',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
      ],
    );
  }

  tagProjects() {
    var drInfo = doctorInfo['profile']['profiles'];
    var keyInfo = [];
    for (var i = 0; i < drInfo.length; i++) {
      if (drInfo[i]["key"] == 'projects') {
        keyInfo = drInfo[i]["values"];
      }
    }
    return Row(
      children: <Widget>[
        for (var item in keyInfo)
          Text(
            item + ', ',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
      ],
    );
  }

  header(text) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  List<String> images = [
    "assets/images/doctor.jpg",
    "assets/images/doctor.jpg",
    "assets/images/doctor.jpg",
  ];

  getDoctorReview(id) {
    print('doctor uudd');
    var bodyData = {
      "emp_id": int.parse(id),
    };
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}calendar/user/emp/review/get', true)
        .then((data) {
      var response = json.decode(data.body);
      print("responsenma da: $response");

      setState(() {
        reviewList = response['result']['reviews'];
      });
    });
  }

  Widget colList() {
    return SizedBox(
      child: ListView.builder(
        itemBuilder: (con, index) {
          return InkWell(
            onTap: () {
              setState(() {
                // Get.to(() => const DoctorInformtaion(docId: ));
              });
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(6),
              width: GlobalVariables.gWidth / 2,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                color: CoreColor().backgroundContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60.0),
                            child: reviewList[index]['user']['profile_img'] ==
                                    null
                                ? Image.asset('assets/images/userprofile.png',
                                    width: 50, height: 50, fit: BoxFit.fitWidth)
                                : CachedNetworkImage(
                                    imageUrl: CoreUrl.imageUrl +
                                        doctorInfo["profile_img"],
                                    fit: BoxFit.fitWidth,
                                    width: 40,
                                    height: 40,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            "assets/images/userprofile.png"),
                                  ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reviewList[index]['user']['first_name'] +
                                    ' ' +
                                    reviewList[index]['user']['last_name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const Text(
                                'Field',
                              )
                            ],
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                            ),
                            Text(
                              reviewList[index]['point'].toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    reviewList[index]['txt'],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
        itemCount: reviewList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(5),
        scrollDirection: Axis.vertical,
      ),
    );
  }

  calendar() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        builder: (context) {
          return SizedBox(
              height: GlobalVariables.gHeight - 200,
              child: Column(
                children: [
                  // const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        child: IconButton(
                          icon: const Icon(Icons.navigate_before),
                          onPressed: () {
                            setState(() {
                              subMonth();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 24),
                      Obx(
                        () => Text(
                          currentMonthName.value,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 24),
                      SizedBox(
                        height: 40,
                        child: IconButton(
                          // color: CoreColor().appGreen,
                          icon: const Icon(Icons.navigate_next),
                          onPressed: () {
                            setState(() {
                              addMonth();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  //   ),
                  // ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      height: 80,
                      child: Obx(
                        () => ListView.builder(
                          itemCount: calendarDayList.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(5),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (con, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex.value = index;
                                  var changeDay = currentMonth < 10
                                      ? "0" + currentMonth.toString()
                                      : currentMonth;

                                  sortShowList(
                                      "$currentYear-$changeDay-${calendarDayList[index]['dayInt']}");
                                  // Get.to(() => const DoctorInformtaion());sssssssssss
                                });
                              },
                              child: Obx(
                                () => Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12.0)),
                                      color: selectedIndex.value == index
                                          ? CoreColor().appGreen
                                          : Colors.transparent),
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
                  const Divider(
                    color: Colors.white38,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'r101283'.coreTranslationWord(),
                                style: const TextStyle(
                                  color: Colors.white38,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'r101239'.coreTranslationWord(),
                                style: const TextStyle(
                                  color: Colors.white38,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: GlobalVariables.gHeight / 2.1,
                    child: Obx(() => ListView.builder(
                          itemCount: showList.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(5),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (con, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  // Get.to(() => const DoctorInformtaion());
                                });
                              },
                              child: showList[index]['status'] == 0
                                  ? listTime(
                                      showList[index]['time']
                                          .toString()
                                          .lastSplice3(),
                                      '',
                                      showList[index]["date"].toString(),
                                      showList[index]["id"],
                                    )
                                  : Container(),
                            );
                          },
                        )),
                  ),
                ],
              ));
        });
  }

  listTime(time1, time2, text, id) {
    return InkWell(
      onTap: () {
        userDescriptionController.text = '';
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                width: 350,
                height: GlobalVariables.gHeight / 2.5,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 30, top: 150),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: CoreColor().backgroundContainer,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    SizedBox(
                      width: GlobalVariables.gWidth - 50,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'r101290'.coreTranslationWord(),
                              style: context.textTheme.bodyText1,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            alignment: Alignment.center,
                            child: TextField(
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 40.0),
                              ),
                              controller: userDescriptionController,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      Get.back();
                                    });
                                  },
                                  child: Text(
                                    'm101003'.coreTranslationWord(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      orderCreate(
                                          id, userDescriptionController.text);
                                    });
                                  },
                                  child: Text(
                                    'r101291'.coreTranslationWord(),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 30, top: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  time2,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Container(
              height: 120,
              width: 1.0,
              color: Colors.white.withOpacity(0.5),
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.all(20),
              height: 120,
              width: GlobalVariables.gWidth / 1.6,
              decoration: BoxDecoration(
                color: CoreColor().appGreen,
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  writeReview() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
                height: GlobalVariables.gHeight * 0.45,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'r101292'.coreTranslationWord(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // const Divider(
                    //   color: Colors.white38,1
                    // ),
                    _ratingBar(),
                    const SizedBox(height: 20),
                    Text(
                      'r101293'.coreTranslationWord(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: GlobalVariables.gWidth - 50,
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          onChanged: (value) {
                            reviewTextFieldValue = value;
                            reviewBntActive();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: GlobalVariables.gWidth - 50,
                        child: MaterialButton(
                          color: CoreColor().appGreen,
                          disabledColor: CoreColor().appGreen.withAlpha(50),
                          child: Text(
                            'r101294'.coreTranslationWord(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          onPressed: () {
                            isReviewBtnEnabled ? submitReview() : null;
                          },
                        ),
                      ),
                    ),
                    // const SizedBox(height: 0),
                  ],
                )),
          );
        });
  }

  Widget _ratingBar() {
    return RatingBar.builder(
      initialRating: _initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: CoreColor().appGreen.withAlpha(50),
      itemCount: 5,
      itemSize: 50.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: CoreColor().appGreen,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
          reviewBntActive();
        });
      },
      updateOnDrag: true,
    );
  }

  reviewBntActive() {
    if (_rating >= 1 && reviewTextFieldValue != "") {
      isReviewBtnEnabled = true;
    } else {
      isReviewBtnEnabled = false;
    }
  }

  submitReview() {
    var bodyData = {
      "emp_id": int.parse(widget.docId),
      "txt": reviewTextFieldValue,
      "point": _rating,
    };
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}calendar/user/emp/review', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        print(response);
        if (response['code'] == 200) {
          setState(() {
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Get.back();
              });
            });
            reviewTextFieldValue = "";
            _rating = 1;
            Navigator.of(context).pop();
          });
        } else {
          Get.snackbar(
            gWarning,
            response['status'],
            colorText: Colors.white,
          );
        }
      },
    );
  }
}
