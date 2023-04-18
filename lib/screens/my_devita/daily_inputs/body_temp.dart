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

class BodytempScreen extends StatefulWidget {
  const BodytempScreen({Key? key}) : super(key: key);

  @override
  _BodytempScreenState createState() => _BodytempScreenState();
}

class _BodytempScreenState extends State<BodytempScreen> {
  final String someText = "Set a target weight to help you manage your weight\n"
      "Your target weight will be shown on the chart";
  RxBool isSwitched = false.obs;
  double tempValue = 0.0;
  double tempValueTest = 0.0;
  // RxDouble totalTemp = 0.0.obs;

  late String timeNow;
  DateFormat timeFormat = DateFormat("kk:mm");

  @override
  void initState() {
    super.initState();
    timeNow = timeFormat.format(DateTime.now());
    setState(() {
      tempValueTest = 0.0;
    });
    getTemp();
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
      "type": "body_temp",
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
          GlobalVariables.totalTemp.value = 0.0;
        } else {
          setState(() {
            GlobalVariables.totalTemp.value = res['result']['items'][0]
                            ['avg_fval']
                        .toString()
                        .length ==
                    2
                ? double.parse(res['result']['items'][0]['avg_fval'].toString())
                : double.parse(res['result']['items'][0]['avg_fval']
                    .toString()
                    .substring(0, 3));
          });
        }
      });
    });
  }

  getTemp() {
    var bodyData = {
      "type": "body_temp",
    };

    Services()
        .postRequest(
            json.encode(bodyData), "${CoreUrl.myDevitaService}/get", true)
        .then((data) {
      var res = json.decode(data.body);
      setState(() {
        GlobalVariables.totalTemp.value = res['result']['items'][0]['fval']
                    .toString()
                    .length ==
                2
            ? double.parse(res['result']['items'][0]['fval'].toString())
            : double.parse(
                res['result']['items'][0]['fval'].toString().substring(0, 3));
      });
    });
  }

  setStep() {
    var bodyData = {
      "type": "body_temp",
      "value": tempValue.toString(),
    };
    Services()
        .postRequest(
            json.encode(bodyData), "${CoreUrl.myDevitaService}/insert", true)
        .then(
      (data) {
        var response = json.decode(data.body);
        if (response['code'] == 200) {
          GlobalVariables.totalTemp.value = tempValue.toDouble();
          successModal();
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

  ///View Widget Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            'r101263'.coreTranslationWord(),
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
            // const SizedBox(height: 10),
            // Text(
            //   'Today',
            //   style: TextStyle(
            //     color: CoreColor().appGreen,
            //     fontSize: 17,
            //   ),
            // ),
            // const SizedBox(height: 25),
            const SizedBox(
              height: 80,
              child: Icon(
                Icons.thermostat_rounded,
                size: 110,
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Obx(
                    () => Text(
                      "${GlobalVariables.totalTemp.value}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: GlobalVariables.gWidth - 110,
              child: TextFormField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                textAlign: TextAlign.start,
                onChanged: (value) {
                  if (value != "") {
                    print(value);
                    tempValue = double.parse(value);
                    tempValueTest = 0.1;
                  }
                },
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
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
            const SizedBox(height: 25),
            SizedBox(
              width: GlobalVariables.gWidth - 200,
              child: MaterialButton(
                color: CoreColor().appGreen,
                child: Text(
                  'r101035'.coreTranslationWord(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
                onPressed: () {
                  setState(() {
                    if (tempValueTest == 0.0) {
                      errorModal('r101369');
                    } else {
                      if (tempValue > 30 && tempValue < 40) {
                        print('zow oruuljde');
                        setStep();
                      } else {
                        print('nohtsol aldatai bna da');
                        errorModal('r101371');
                      }
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 15),
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
                          "${GlobalVariables.totalTemp.value}",
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
      ),
    );
  }

  // setTarget() {
  //   return showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       enableDrag: false,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(40.0),
  //           topRight: Radius.circular(40.0),
  //         ),
  //       ),
  //       builder: (context) {
  //         return SizedBox(
  //           height: GlobalVariables.gHeight - 120,
  //           child: Column(
  //             children: [
  //               Container(
  //                 margin: const EdgeInsets.only(top: 20, bottom: 10),
  //                 child: Text(
  //                   'r101265'.coreTranslationWord(),
  //                   style: const TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 18),
  //                 ),
  //               ),
  //               const Divider(
  //                 color: Colors.white38,
  //               ),
  //               const SizedBox(height: 10),
  //               Text(
  //                 someText,
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(
  //                   height: 1.5,
  //                   color: Colors.white,
  //                   fontSize: 13,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Obx(
  //                 () => Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       isSwitched.value == false ? 'OFF' : 'ON',
  //                       style: const TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 18,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 10),
  //                     Transform.scale(
  //                       scale: 1.3,
  //                       child: Switch(
  //                         value: isSwitched.value,
  //                         onChanged: (value) {
  //                           setState(() {
  //                             isSwitched.value = value;
  //                           });
  //                         },
  //                         activeTrackColor: Colors.lightGreenAccent,
  //                         activeColor: CoreColor().appGreen,
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 30),
  //               Row(
  //                 children: [
  //                   Container(
  //                     margin: const EdgeInsets.only(
  //                       left: 15,
  //                     ),
  //                     width: GlobalVariables.gWidth - 110,
  //                     child: TextFormField(
  //                       keyboardType: TextInputType.number,
  //                       maxLines: 1,
  //                       textAlign: TextAlign.start,
  //                       onChanged: (value) {
  //                         // tempValue = int.parse(value);
  //                       },
  //                       decoration: InputDecoration(
  //                         disabledBorder: OutlineInputBorder(
  //                           borderRadius:
  //                               const BorderRadius.all(Radius.circular(12.0)),
  //                           borderSide: BorderSide(
  //                               color: CoreColor().backgroundNew, width: 1.0),
  //                         ),
  //                         fillColor: CoreColor().backgroundContainer,
  //                         focusColor: CoreColor().appGreen,
  //                         hintStyle: TextStyle(
  //                           color: Colors.grey.shade500,
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(
  //                             color: CoreColor().appGreen,
  //                             width: 2.0,
  //                           ),
  //                           borderRadius: BorderRadius.circular(8.0),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 15),
  //                   SizedBox(
  //                     height: 40,
  //                     width: 65,
  //                     child: ElevatedButton(
  //                       style: ButtonStyle(
  //                         backgroundColor:
  //                             MaterialStateProperty.all(CoreColor().appGreen),
  //                         shape:
  //                             MaterialStateProperty.all<RoundedRectangleBorder>(
  //                           RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(15.0),
  //                             side: BorderSide(
  //                               color: CoreColor().appGreen,
  //                               width: 1.0,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       child: const Icon(
  //                         Icons.check,
  //                         size: 25,
  //                       ),
  //                       onPressed: () {
  //                         setState(() {
  //                           setStep();
  //                         });
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 10),
  //               const Divider(
  //                 color: Colors.grey,
  //                 height: 2,
  //               ),
  //               SizedBox(
  //                 width: GlobalVariables.gWidth - 50,
  //                 child: const Divider(
  //                   color: Colors.white54,
  //                 ),
  //               ),
  //               const SizedBox(height: 30),
  //               const Text(
  //                 'Body Temperature',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               SizedBox(
  //                 width: GlobalVariables.gWidth - 50,
  //                 child: SfLinearGauge(
  //                   maximum: 100.0,
  //                   minimum: 0.0,
  //                   ranges: null,
  //                   markerPointers: null,
  //                   barPointers: const [
  //                     LinearBarPointer(value: 36.60),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  successModal() {
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
