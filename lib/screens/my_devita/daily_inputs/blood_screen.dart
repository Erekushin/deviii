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

class BloodPage extends StatefulWidget {
  const BloodPage({Key? key}) : super(key: key);

  @override
  _BloodPageState createState() => _BloodPageState();
}

const String someText = "Set a target blood to help you manage your blood\n"
    "Your target blood will be shown on the chart";

class _BloodPageState extends State<BloodPage> {
  List<String> listOfValue = [
    'AB+',
    'AB-',
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();
    getBlood();
  }

  getBlood() {
    var bodyData = {
      "type": "blood_type",
    };

    Services()
        .postRequest(
            json.encode(bodyData), "${CoreUrl.myDevitaService}/get", true)
        .then((data) {
      var res = json.decode(data.body);
      print(res);
      setState(() {
        GlobalVariables.bloodValue.value = res['result']['items'][0]['sval'];
        var storage = GetStorage();
        storage.write('bloodValue', res['result']['items'][0]['sval']);
      });
    });
  }

  setBlood() {
    var bodyData = {
      "type": "blood_type",
      "value": GlobalVariables.bloodValue.value,
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
          // totalBlood.value = bloodValue.value;
          var storage = GetStorage();
          storage.write('bloodValue', GlobalVariables.bloodValue.value);
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
            'r101108'.coreTranslationWord(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      body: SizedBox(
        height: GlobalVariables.gHeight - 110,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                'r101269'.coreTranslationWord(),
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
            const Text(
              someText,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                color: Colors.white,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              child: DropdownButtonFormField(
                iconEnabledColor: CoreColor().appGreen,
                iconDisabledColor: CoreColor().appGreen,
                decoration: InputDecoration(
                  fillColor: CoreColor().backgroundContainer,
                  hintText: "",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: CoreColor().grey, width: 1.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: CoreColor().grey, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: CoreColor().grey, width: 1.0),
                  ),
                ),
                isExpanded: true,
                hint: const Text(''),
                items: listOfValue.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  // bloodValue.toString();
                  GlobalVariables.bloodValue.value = value.toString();
                },
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    GlobalVariables.bloodValue.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'r101270'.coreTranslationWord(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 45),
            SizedBox(
              height: 45,
              width: 85,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(CoreColor().appGreen),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    setBlood();
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
