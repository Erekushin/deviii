import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  double weightValue = 0;
  // RxDouble totalWeight = 0.0.obs;
  late String timeNow;
  DateFormat timeFormat = DateFormat("kk:mm");

  @override
  void initState() {
    super.initState();
    timeNow = timeFormat.format(DateTime.now());
    getWeight();
  }

  getWeight() {
    var bodyData = {
      "type": "weight",
    };

    Services()
        .postRequest(
            json.encode(bodyData), "${CoreUrl.myDevitaService}/get", true)
        .then((data) {
      var res = json.decode(data.body);
      setState(() {
        print(res['result']['items'][0]['fval']);

        GlobalVariables.totalWeight.value = res['result']['items'][0]['fval']
                    .toString()
                    .length ==
                2
            ? double.parse(res['result']['items'][0]['fval'].toString())
            : double.parse(
                res['result']['items'][0]['fval'].toString().substring(0, 3));
        var storage = GetStorage();
        storage.write(
            'totalWeigth', res['result']['items'][0]['fval'].toString());
      });
    });
  }

  setWeight() {
    var bodyData = {
      "type": "weight",
      "value": weightValue.toString(),
    };

    print("body: $bodyData");
    Services()
        .postRequest(
            json.encode(bodyData), "${CoreUrl.myDevitaService}/insert", true)
        .then(
      (data) {
        var response = json.decode(data.body);
        print('tesdadas $response');
        if (response['code'] == 200) {
          GlobalVariables.totalWeight.value = weightValue;
          var storage = GetStorage();
          storage.write('totalWeigth', GlobalVariables.totalWeight.value);
          modal();
        } else {
          // Get.back();
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
            'r101110'.coreTranslationWord(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // SizedBox(
            //   height: GlobalVariables.gHeight / 5,
            //   child: const CalendarListWidget(),
            // ),
            // const SizedBox(height: 10),
            // Container(
            //   padding: const EdgeInsets.only(left: 45, top: 40),
            //   child: Row(
            //     children: const [
            //       Text(
            //         'HISTORY',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 14,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20),
            // SizedBox(
            //   width: GlobalVariables.gWidth - 100,
            //   child: const Divider(
            //     color: Colors.grey,
            //     height: 25,
            //   ),
            // ),
            // const SizedBox(height: 20),
            // SizedBox(
            //   width: GlobalVariables.gWidth - 85,
            //   child: SfLinearGauge(
            //     maximum: 200,
            //     minimum: 0,
            //     ranges: null,
            //     markerPointers: null,
            //     barPointers: const [
            //       LinearBarPointer(value: 87),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 20),

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
            top: 30,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Text(
                "${GlobalVariables.totalWeight.value}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 11),
              child: Text(
                'r101267'.coreTranslationWord(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
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
              Obx(
                () => Text(
                  "${GlobalVariables.totalWeight.value}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
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
        const SizedBox(height: 5),
        SizedBox(
          width: GlobalVariables.gWidth - 90,
          child: const Divider(
            color: Colors.grey,
            height: 25,
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: GlobalVariables.gWidth - 110,
          child: TextFormField(
            keyboardType: TextInputType.number,
            maxLines: 1,
            textAlign: TextAlign.start,
            onChanged: (value) {
              if (value != "") {
                weightValue = double.parse(value);
              }
            },
            decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide:
                    BorderSide(color: CoreColor().backgroundNew, width: 1.0),
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
          width: GlobalVariables.gWidth - 180,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.grey.shade50)),
            color: Colors.grey.shade50,
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
                setWeight();
              });
            },
          ),
        ),
      ],
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
  //                 child: const Text(
  //                   'Set Weight Target',
  //                   style: TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 18),
  //                 ),
  //               ),
  //               const Divider(
  //                 color: Colors.white38,
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
  //                       onChanged: (value) {},
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
  //                           setWeight();
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
  //               // SizedBox(
  //               //   width: GlobalVariables.gWidth - 50,
  //               //   child: const Divider(
  //               //     color: Colors.white54,
  //               //   ),
  //               // ),
  //               const SizedBox(height: 30),
  //               SizedBox(
  //                 width: GlobalVariables.gWidth - 50,
  //                 child: SfLinearGauge(
  //                   maximum: 200,
  //                   minimum: 0.0,
  //                   ranges: null,
  //                   markerPointers: null,
  //                   barPointers: [
  //                     LinearBarPointer(
  //                       value: 71.5,
  //                       color: CoreColor().appGreen,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 30),
  //               const Text(
  //                 'CURRENT WEIGHT:',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               Obx(
  //                 () => Text(
  //                   "${totalWeight.value}",
  //                   style: const TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 25,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

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
