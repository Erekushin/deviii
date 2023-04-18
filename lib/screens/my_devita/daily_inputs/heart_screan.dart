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
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HeartScreen extends StatefulWidget {
  const HeartScreen({Key? key}) : super(key: key);

  @override
  _HeartScreenState createState() => _HeartScreenState();
}

class _HeartScreenState extends State<HeartScreen> {
  double heartValue = 0.0;
  double heartValueTest = 0.0;
  // RxInt totalHeart = 0.obs;
  late String timeNow;
  DateFormat timeFormat = DateFormat("kk:mm");
  RxDouble circularProgressVal = 0.0.obs;

  @override
  void initState() {
    timeNow = timeFormat.format(DateTime.now());
    getWeight();
    super.initState();
  }

  getWeight() {
    var bodyData = {
      "type": "heart_rate",
    };

    Services()
        .postRequest(
            json.encode(bodyData), "${CoreUrl.myDevitaService}/get", true)
        .then((data) {
      var res = json.decode(data.body);
      setState(() {
        print(res['result']['items'][0]['fval']);
        GlobalVariables.totalHeart.value = double.parse(
            res['result']['items'][0]['fval'].toString().substring(
                0,
                res['result']['items'][0]['fval'].toString().length == 2
                    ? 2
                    : 4));
        double percent = (res['result']['items'][0]['fval'] / 120) * 100;
        print('wtf');
        print(percent);
        circularProgressVal.value = percent / 100;
      });
    });
  }

  setWeight() {
    var bodyData = {
      "type": "heart_rate",
      "value": heartValue.toString(),
    };

    Services()
        .postRequest(
            json.encode(bodyData), "${CoreUrl.myDevitaService}/insert", true)
        .then(
      (data) {
        var response = json.decode(data.body);
        print('tesdadas $response');
        if (response['code'] == 200) {
          GlobalVariables.totalHeart.value = heartValue;
          double percent = (GlobalVariables.totalHeart.value / 120) * 100;
          circularProgressVal.value = percent / 100;
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

  selectedDateData(date) {
    var bodyData = {
      "type": "heart_rate",
      "start_date": date,
      "end_date": date,
    };
    Services()
        .postRequest(json.encode(bodyData),
            "${CoreUrl.myDevitaService}/get/between/days", true)
        .then((data) {
      print('dotororoadata');
      var res = json.decode(data.body);
      print(res);

      setState(() {
        if (res['result']['items'] == null) {
          setState(() {
            GlobalVariables.totalHeart.value = 0;
            circularProgressVal.value = 0.0;
          });
        } else {
          setState(() {
            GlobalVariables.totalHeart.value = double.parse(
                res['result']['items'][0]['avg_fval'].toString().substring(
                    0,
                    res['result']['items'][0]['avg_fval'].toString().length == 2
                        ? 2
                        : 4));
            double percent =
                (res['result']['items'][0]['avg_fval'] / 120) * 100;
            circularProgressVal.value = percent / 100;
            // GlobalVariables.totalStep.value =
            //     res['result']['items'][0]['avg_fval'];
            // if (res['result']['items'][0]['fval'] != 0) {
            //   double percent = (GlobalVariables.totalStep.value / 6000) * 100;
            //   circularProgressVal.value = percent / 100;
            //   GlobalVariables.indicatorValue.value = percent / 100;
            // } else {
            //   circularProgressVal.value = 0.0;
            // }
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
            'r101272'.coreTranslationWord(),
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
            Container(
              child: weigthData(),
            ),
          ],
        ),
      ),
    );
  }

  Widget weigthData() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 45,
            top: 0,
          ),
          child: Row(
            children: [
              Text(
                'r101271'.coreTranslationWord(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
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
                        GlobalVariables.totalHeart.value.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: CoreColor().appGreen,
                        ),
                        Text(
                          'r101273'.coreTranslationWord(),
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: GlobalVariables.gWidth - 90,
          child: const Divider(
            color: Colors.grey,
            height: 25,
          ),
        ),
        SizedBox(
          width: GlobalVariables.gWidth - 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(
                    () => Text(
                      "${GlobalVariables.totalHeart.value}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'bpm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              Text(
                timeNow,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  setTarget() {
    setState(() {
      heartValueTest = 0.0;
    });
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
                  child: const Text(
                    'Heart Rate',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                const SizedBox(height: 30),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.only(
                    left: 45,
                    top: 0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'r101271'.coreTranslationWord(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Obx(
                        () => Text(
                          GlobalVariables.totalHeart.value.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.only(top: 15),
                      child: Text(
                        'r101273'.coreTranslationWord(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: GlobalVariables.gWidth - 50,
                  child: const Divider(
                    color: Colors.grey,
                    height: 25,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: GlobalVariables.gWidth - 50,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    onChanged: (value) {
                      if (value != "") {
                        heartValueTest = 0.1;
                        print('ldasdsadasda');
                        heartValue = double.parse(value);
                        print(value);
                      }
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
                const SizedBox(height: 10),
                Container(
                  width: GlobalVariables.gWidth - 50,
                  alignment: Alignment.centerLeft,
                  height: 40,
                  child: const Text(
                    'min: 40 max: 120',
                    style: TextStyle(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: GlobalVariables.gWidth - 180,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    color: CoreColor().appGreen,
                    child: Text(
                      'r101035'.coreTranslationWord(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (heartValueTest == 0.0) {
                          errorModal('r101369');
                        } else {
                          if (heartValue > 40 && heartValue < 120) {
                            print('zow oruuljde');
                            setWeight();
                          } else {
                            print('nohtsol aldatai bna da');
                            errorModal('r101370');
                          }
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: GlobalVariables.gWidth - 50,
                  child: const Divider(
                    color: Colors.grey,
                    height: 25,
                  ),
                ),
                SizedBox(
                  width: GlobalVariables.gWidth - 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => Text(
                              "${GlobalVariables.totalHeart.value}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Text(
                            'bpm',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                      Text(
                        timeNow,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
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

  errorModal(String textCode) {
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
              const SizedBox(height: 20),
              Text(
                textCode.coreTranslationWord(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: GlobalVariables.gWidth,
                child: MaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  color: CoreColor().appGreen,
                  child: Text(
                    'OK',
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
