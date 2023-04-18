import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/my_devita/daily_inputs/body_temp.dart';
import 'package:devita/screens/my_devita/daily_inputs/heart_screan.dart';
import 'package:devita/screens/my_devita/daily_inputs/steps_screen.dart';
import 'package:devita/screens/my_devita/daily_inputs/water_screen.dart';
import 'package:devita/screens/my_devita/daily_inputs/weight_screen.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'blood_screen.dart';
import 'height_screen.dart';

class DailyInput extends StatefulWidget {
  const DailyInput({Key? key}) : super(key: key);

  @override
  _DailyInputState createState() => _DailyInputState();
}

class _DailyInputState extends State<DailyInput> {
  List dailyListData = [
    {
      "title": 'r101249'.coreTranslationWord(),
      "value": 0,
      "indicator": true,
      "indicatorValue": 0,
      "type_name": "step",
    },
    {
      "title": 'r101260'.coreTranslationWord(),
      "value": 0,
      "indicator": false,
      "indicatorValue": "Add",
      "type_name": "water",
    },
    {
      "title": 'r101263'.coreTranslationWord(),
      "value": 0,
      "indicator": false,
      "indicatorValue": "Add",
      "type_name": "body_temp",
    },
    {
      "title": 'r101110'.coreTranslationWord(),
      "value": 0,
      "indicator": false,
      "indicatorValue": "Add",
      "type_name": "weight",
    },
    {
      "title": 'r101109'.coreTranslationWord(),
      "value": 0,
      "indicator": false,
      "indicatorValue": "Add",
      "type_name": "height",
    },
    {
      "title": 'r101108'.coreTranslationWord(),
      "value": "A (III)",
      "indicator": false,
      "indicatorValue": "Add",
      "type_name": "blood_type",
    },
    {
      "title": 'r101272'.coreTranslationWord(),
      "value": 0,
      "indicator": false,
      "indicatorValue": "Add",
      "type_name": "heart_rate",
    },
    {
      "title": 'r101117'.coreTranslationWord(),
      "value": 0,
      "indicator": false,
      "indicatorValue": "View History"
    },
    {
      "title": 'r101114'.coreTranslationWord(),
      "value": 0,
      "indicator": false,
      "indicatorValue": "Add",
      "type_name": "sleep",
    },
    {
      "title": 'r101311'.coreTranslationWord(),
      "value": 0,
      "indicator": false,
      "indicatorValue": "Add",
      "type_name": "food",
    },
    {
      "title": 'r101312'.coreTranslationWord(),
      "value": 0,
      "indicator": false,
      "indicatorValue": "Add",
      "type_name": "mental",
    },
    {
      "title": 'r101313'.coreTranslationWord(),
      "value": "-- / -- MMHG",
      "indicator": false,
      "indicatorValue": "Add",
      "type_name": "blood_pressure",
    },
  ];
  List items = [];

  dailyData() {
    var bodyData = {};

    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}metadata/daily/profile', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        setState(() {
          items = response['result']['items'];
          for (var element in items) {
            for (var el in dailyListData) {
              if (element['type_name'] == el['type_name']) {
                el['value'] = element['fval'];
                if (element['type_name'] == 'step') {
                  double percent = (element['fval'] / 6000) * 100;
                  GlobalVariables.indicatorValue.value = percent / 100;
                  GlobalVariables.totalStep.value = element['fval'];
                }
                if (element['type_name'] == 'water') {
                  GlobalVariables.totalWater.value = element['fval'];
                }

                if (element['type_name'] == 'body_temp') {
                  GlobalVariables.totalTemp.value = double.parse(element['fval']
                      .toString()
                      .substring(
                          0, element['fval'].toString().length == 2 ? 2 : 4));
                }
                if (element['type_name'] == 'weight') {
                  GlobalVariables.totalWeight.value = double.parse(
                      element['fval'].toString().substring(
                          0, element['fval'].toString().length == 2 ? 2 : 4));
                }
                if (element['type_name'] == 'height') {
                  el['value'] = element['fval'].toString();
                }
                if (element['type_name'] == 'blood_type') {
                  GlobalVariables.bloodValue.value = element['sval'].toString();
                }
                if (element['type_name'] == 'heart_rate') {
                  print('wtheararaf');
                  print(element['fval']);
                  GlobalVariables.totalHeart.value = double.parse(
                      element['fval'].toString().substring(
                          0, element['fval'].toString().length == 2 ? 2 : 4));
                }
              }
            }
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    dailyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //searchar used for it test
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
            'r101258'.coreTranslationWord(),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: dailyList(),
      ),
    );
  }

  Widget dailyList() {
    return ListView.builder(
      itemCount: dailyListData.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              if (index == 0) {
                Get.to(() => const StepsScreen());
              } else if (index == 1) {
                Get.to(() => const WaterScreen());
              } else if (index == 2) {
                Get.to(() => const BodytempScreen());
              } else if (index == 3) {
                Get.to(() => const WeightScreen());
              } else if (index == 4) {
                Get.to(() => const HeightPage());
              } else if (index == 5) {
                Get.to(() => const BloodPage());
              } else if (index == 6) {
                Get.to(() => const HeartScreen());
              } else {
                modal();
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(42, 46, 50, 1),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: ListTile(
              leading: null,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dailyListData[index]['title'].toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  dailyListData[index]['type_name'] == 'step'
                      ? Obx(
                          () => Text(
                            '${GlobalVariables.totalStep.value} / 6000 step',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : dailyListData[index]['type_name'] == 'water'
                          ? Obx(
                              () => Text(
                                '${GlobalVariables.totalWater}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : dailyListData[index]['type_name'] == 'body_temp'
                              ? Obx(
                                  () => Text(
                                    '${GlobalVariables.totalTemp}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : dailyListData[index]['type_name'] == 'weight'
                                  ? Obx(
                                      () => Text(
                                        '${GlobalVariables.totalWeight}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : dailyListData[index]['type_name'] ==
                                          'height'
                                      ? Obx(
                                          () => Text(
                                            '${GlobalVariables.totalHeight}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : dailyListData[index]['type_name'] ==
                                              'blood_type'
                                          ? Obx(
                                              () => Text(
                                                '${GlobalVariables.bloodValue}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : dailyListData[index]['type_name'] ==
                                                  'heart_rate'
                                              ? Obx(
                                                  () => Text(
                                                    '${GlobalVariables.totalHeart}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  dailyListData[index]['value']
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                ],
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 10),
                child: dailyListData[index]['indicator'] == true
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Obx(
                          () => LinearProgressIndicator(
                            minHeight: 10.0,
                            value: GlobalVariables.indicatorValue.value,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              CoreColor().appGreen,
                            ),
                            backgroundColor: CoreColor().backgroundNew,
                          ),
                        ),
                      )
                    : Text(
                        dailyListData[index]['indicatorValue'].toString(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
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
                'r101259'.coreTranslationWord(),
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
