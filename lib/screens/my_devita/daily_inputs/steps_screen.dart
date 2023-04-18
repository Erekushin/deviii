import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:devita/widget/calendar_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ChartData {
  ChartData(this.x, this.y1);
  final String x;
  final int y1;
}

class StepsScreen extends StatefulWidget {
  const StepsScreen({Key? key}) : super(key: key);

  @override
  _StepsScreenState createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  final List<ChartData> stepStatusData = [
    ChartData('Mon', 0),
    ChartData('Tue', 0),
    ChartData('Wed', 0),
    ChartData('Thu', 0),
    ChartData('Fri', 0),
    ChartData('Sat', 0),
    ChartData('Sun', 0),
  ];

  final String someText = "Set a target step to help you manage your step\n"
      "Your target step will be shown on the chart";
  int stepValue = 0;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  late String dateNow;
  RxDouble circularProgressVal = 0.0.obs;

  @override
  void initState() {
    super.initState();
    dateNow = dateFormat.format(DateTime.now());

    getStep();
    getWeekData();
  }

  /// Find the first date of the week which contains the provided date.
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  /// Find last date of the week which contains provided date.
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  selectedDateData(date) {
    var bodyData = {
      "type": "step",
      "start_date": date,
      "end_date": date,
    };
    Services()
        .postRequest(json.encode(bodyData),
            "${CoreUrl.myDevitaService}/get/between/days", true)
        .then((data) {
      var res = json.decode(data.body);
      setState(() {
        if (res['result']['items'] == null) {
          setState(() {
            GlobalVariables.totalStep.value = 0;
            GlobalVariables.indicatorValue.value = 0;
            circularProgressVal.value = 0.0;
          });
        } else {
          setState(() {
            GlobalVariables.totalStep.value =
                res['result']['items'][0]['avg_fval'];
            if (res['result']['items'][0]['fval'] != 0) {
              double percent = (GlobalVariables.totalStep.value / 6000) * 100;
              circularProgressVal.value = percent / 100;
              GlobalVariables.indicatorValue.value = percent / 100;
            } else {
              circularProgressVal.value = 0.0;
            }
          });
        }
      });
    });
  }

  getWeekData() {
    var bodyData = {
      "type": "step",
      "start_date": dateFormat.format(findFirstDateOfTheWeek(DateTime.now())),
      "end_date": dateFormat.format(findLastDateOfTheWeek(DateTime.now()))
    };
    Services()
        .postRequest(json.encode(bodyData),
            "${CoreUrl.myDevitaService}/get/between/days", true)
        .then((data) {
      var res = json.decode(data.body);
      for (var i = 0; i < res['result']['items'].length; i++) {
        for (var z = 0; z < stepStatusData.length; z++) {
          if (getDay(res['result']['items'][i]['day_number']) ==
              stepStatusData[z].x) {
            stepStatusData[z] = ChartData(
                stepStatusData[z].x, res['result']['items'][i]['avg_fval']);
          }
        }
      }
    });
  }

  getDay(index) {
    switch (index) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        break;
    }
  }

  getStep() {
    var bodyData = {
      "type": "step",
    };

    Services()
        .postRequest(
            json.encode(bodyData), "${CoreUrl.myDevitaService}/get", true)
        .then((data) {
      var res = json.decode(data.body);
      setState(() {
        if (res['result']['items'][0]['fval'] != 0) {
          GlobalVariables.totalStep.value = res['result']['items'][0]['fval'];

          double percent = (GlobalVariables.totalStep.value / 6000) * 100;
          circularProgressVal.value = percent / 100;
          GlobalVariables.indicatorValue.value = percent / 100;
        } else {
          GlobalVariables.totalStep.value = 0;
          circularProgressVal.value = 0.0;
        }
      });
    });
  }

  setStep() {
    var bodyData = {
      "type": "step",
      "value": stepValue.toString(),
    };
    Services()
        .postRequest(
            json.encode(bodyData), "${CoreUrl.myDevitaService}/insert", true)
        .then(
      (data) {
        var response = json.decode(data.body);
        if (response['code'] == 200) {
          GlobalVariables.totalStep.value = stepValue;
          double percent = (stepValue / 6000) * 100;
          circularProgressVal.value = percent / 100;

          GlobalVariables.indicatorValue.value = percent / 100;
          Get.back();
          modal();
        } else {
          Get.back();
          Get.snackbar(
            gWarning,
            'Error',
            colorText: Colors.black,
          );
        }
      },
    );
  }

  ///View Widget Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CoreColor().backgroundNew,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () {
              setState(() {
                Get.back();
              });
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          leadingWidth: 80,
          titleSpacing: 0.0,
          title: Text(
            'r101249'.coreTranslationWord(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  setTarget();
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'r101253'.coreTranslationWord(),
                  style: TextStyle(
                    color: CoreColor().appGreen,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: GlobalVariables.gHeight / 5,
              child: CalendarListWidget(
                onPressed: (val) {
                  setState(() {
                    selectedDateData(val);
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Obx(
                        () => CircularProgressIndicator(
                          value: circularProgressVal.value,
                          strokeWidth: 7,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            CoreColor().appGreen,
                          ),
                          backgroundColor: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Obx(
                          () => Text(
                            GlobalVariables.totalStep.value.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'r101249'.coreTranslationWord(),
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '6000',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'r101255'.coreTranslationWord(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: filters(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    StackedColumnSeries<ChartData, String>(
                      color: CoreColor().appGreen,
                      dataSource: stepStatusData,
                      xValueMapper: (ChartData sales, _) => sales.x,
                      yValueMapper: (ChartData sales, _) => sales.y1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filters() {
    return Container(
      width: GlobalVariables.gWidth - 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
              decoration: BoxDecoration(
                color: CoreColor().appGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: null,
                child: Text(
                  'r101252'.coreTranslationWord(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  setTarget() {
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
            height: GlobalVariables.gHeight - 120,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    'r101257'.coreTranslationWord(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                const Divider(
                  color: Colors.white38,
                ),
                const SizedBox(height: 10),
                Text(
                  someText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 1.5,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 15,
                      ),
                      width: GlobalVariables.gWidth - 110,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        onChanged: (value) {
                          stepValue = int.parse(value);
                        },
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(
                                color: CoreColor().backgroundNew, width: 1.0),
                          ),
                          fillColor: CoreColor().backgroundContainer,
                          focusColor: CoreColor().appGreen,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: CoreColor().appGreen,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      height: 40,
                      width: 65,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(CoreColor().appGreen),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(
                                color: CoreColor().appGreen,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 25,
                        ),
                        onPressed: () {
                          setState(() {
                            setStep();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                SizedBox(
                  width: GlobalVariables.gWidth - 50,
                  child: const Divider(
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 30),
                Obx(
                  () => Text(
                    "${GlobalVariables.totalStep.value} steps",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: GlobalVariables.gWidth - 50,
                  child: SfLinearGauge(
                    maximum: 6000.0,
                    minimum: 0.0,
                    ranges: null,
                    markerPointers: null,
                    barPointers: [
                      LinearBarPointer(
                          value: GlobalVariables.totalStep.value.toDouble()),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  modal() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CoreColor().backgroundContainer,
          scrollable: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Column(
            children: [
              Image.asset(
                'assets/images/logo_no_word.png',
                height: 65,
              ),
              const SizedBox(height: 20),
              Text(
                'r101256'.coreTranslationWord(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: CoreColor().appGreen,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: GlobalVariables.gWidth - 80,
                child: MaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  color: CoreColor().backgroundNew,
                  child: Text(
                    'r101140'.coreTranslationWord(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  onPressed: () {
                    setState(() {
                      Get.back();
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
