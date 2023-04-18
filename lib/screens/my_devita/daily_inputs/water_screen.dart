import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:devita/widget/calendar_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({Key? key}) : super(key: key);

  @override
  _WaterScreenState createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  RxBool isSwitched = false.obs;
  RxInt summerWater = 0.obs;
  late String dateNow;
  RxDouble circularProgressVal = 0.0.obs;
  // RxInt totalWater = 0.obs;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  RxInt mlSave = 0.obs;
  RxInt mlData = 0.obs;

  @override
  void initState() {
    super.initState();
    dateNow = dateFormat.format(DateTime.now());
    getWater();
  }

  void add() {
    setState(() {
      summerWater.value++;
      mlSave.value = mlSave.value + 250;
    });
  }

  void minus() {
    setState(() {
      if (summerWater.value != 0) {
        summerWater.value--;
        mlSave.value = mlSave.value - 250;
      }
    });
  }

  getWater() {
    var bodyData = {
      "type": "water",
    };

    Services()
        .postRequest(
            json.encode(bodyData), "${CoreUrl.myDevitaService}/get", true)
        .then((data) {
      var res = json.decode(data.body);
      print('dsds: $res');
      setState(() {
        GlobalVariables.totalWater.value = res['result']['items'][0]['fval'];
        mlData.value = 250 * GlobalVariables.totalWater.value;
      });
    });
  }

  setWater() {
    int sum = GlobalVariables.totalWater.value + summerWater.value;

    var bodyData = {
      "type": "water",
      "value": sum.toString(),
    };

    Services()
        .postRequest(
            json.encode(bodyData), "${CoreUrl.myDevitaService}/insert", true)
        .then(
      (data) {
        var response = json.decode(data.body);
        if (response['code'] == 200) {
          // GlobalVariables.totalWater.value = summerWater.value;
          GlobalVariables.totalWater.value = sum;

          mlData.value = 250 * summerWater.value;
          summerWater.value = 0;
          mlSave.value = 0;
          modal();
        } else {
          Get.snackbar(
            gWarning,
            'Error',
            colorText: Colors.black,
          );
        }
      },
    );
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
      "type": "water",
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
            GlobalVariables.totalWater.value = 0;
            mlData.value = 0;
          });
        } else {
          setState(() {
            GlobalVariables.totalWater.value =
                res['result']['items'][0]['avg_fval'];
            mlData.value = 250 * GlobalVariables.totalWater.value;
          });
        }
      });
    });
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
            'r101260'.coreTranslationWord(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [
            // InkWell(
            //   onTap: () {
            //     setState(() {
            //       setTarget();
            //     });
            //   },
            //   child: Container(
            //     alignment: Alignment.center,
            //     padding: const EdgeInsets.only(right: 20),
            //     child: Text(
            //       'Set Target',
            //       style: TextStyle(
            //         color: CoreColor().appGreen,
            //         fontSize: 13,
            //       ),
            //     ),
            //   ),
            // ),
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
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: 100.0,
                        strokeWidth: 7,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CoreColor().appGreen,
                        ),
                        backgroundColor: Colors.grey[700],
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
                            GlobalVariables.totalWater.value.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Obx(
                          () => Text(
                            'Glasses (${mlData.value}ml)',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'r101261'.coreTranslationWord(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              child: filters(),
            ),
          ],
        ),
      ),
    );
  }

  Widget filters() {
    return SizedBox(
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: MaterialButton(
                    color: Colors.lightBlue[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(color: Colors.blueAccent)),
                    onPressed: minus,
                    child: const Icon(
                      Icons.remove,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: CoreColor().appGreen,
                      border:
                          Border.all(color: CoreColor().appGreen, width: 5.0),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Obx(
                      () => Text(
                        '$summerWater',
                        style: const TextStyle(
                            fontSize: 35.0, color: Colors.white),
                      ),
                    )),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: MaterialButton(
                    color: Colors.lightBlue[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(color: Colors.blueAccent)),
                    onPressed: add,
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'r101262'.coreTranslationWord(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 5),
            Obx(
              () => Text(
                "${mlSave.value} ml",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: GlobalVariables.gWidth / 2,
              child: MaterialButton(
                color: CoreColor().appGreen,
                child: Text(
                  'r101035'.coreTranslationWord(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
                onPressed: () {
                  setState(() {
                    setWater();
                  });
                },
              ),
            ),
          ],
        ),
      ),
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
