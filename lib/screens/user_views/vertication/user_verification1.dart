import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devita/helpers/gextensions.dart';

class UserVerification1 extends StatefulWidget {
  const UserVerification1({Key? key}) : super(key: key);

  @override
  _UserVerification1State createState() => _UserVerification1State();
}

class _UserVerification1State extends State<UserVerification1> {
  bool hidePassword = true;
  String selectGender = '';

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    firstNameController.dispose();
    super.dispose();
  }

  /// user information update
  void updateProfile() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    var body = {
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "gender": selectGender,
      "birth_date": DateFormat('yyyy-MM-dd').format(selectedDate)
    };

    Services()
        .postRequest(json.encode(body),
            '${CoreUrl.authService}user/profile/update/info', true)
        .then((data) {
      var res = json.decode(data.body);

      print(res);
      if (res['code'] == 200) {
        setState(() {
          GlobalVariables.updateService(context);
        });
        // Get.to(() => const MainTab());
        Get.snackbar(
          gSuccess,
          res['message'],
          colorText: Colors.white,
        );
      } else {
        print('sda');
        Get.back();
        Get.snackbar(
          gSuccess,
          res['message_code'],
          colorText: Colors.white,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: GlobalVariables.gWidth,
        height: GlobalVariables.gHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/background.png",
            ),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: userDetail(),
        ),
      ),
    );
  }

  Widget userDetail() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Text(
            'r101063'.coreTranslationWord(),
            style: context.textTheme.headline2,
          ),
          const SizedBox(height: 20),
          Text(
            'r101070'.coreTranslationWord(),
            style: const TextStyle(
              fontWeight: FontWeight.w200,
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.text,
            controller: firstNameController,
          ),
          const SizedBox(height: 10),
          Text(
            'r101071'.coreTranslationWord(),
            style: const TextStyle(
              fontWeight: FontWeight.w200,
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.text,
            controller: lastNameController,
          ),
          const SizedBox(height: 10),
          Text(
            'r101072'.coreTranslationWord(),
            style: const TextStyle(
              fontWeight: FontWeight.w200,
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: GlobalVariables.gWidth,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: CoreColor().appGreen,
                ),
              ),
              onPressed: () {
                _selectDateYear(context);
              },
              child: Text(
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: CoreColor().appGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: Text('r101073'.coreTranslationWord()),
                  leading: Radio(
                    value: "r101073"
                        .coreTranslationWord()
                        .toString()
                        .toUpperCase(),
                    groupValue: selectGender,
                    activeColor: CoreColor().appGreen,
                    onChanged: (String? value) {
                      setState(() {
                        selectGender = value!;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('r101074'.coreTranslationWord()),
                  leading: Radio(
                    value: "r101074"
                        .coreTranslationWord()
                        .toString()
                        .toUpperCase(),
                    groupValue: selectGender,
                    activeColor: CoreColor().appGreen,
                    onChanged: (String? value) {
                      setState(() {
                        selectGender = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: GlobalVariables.gWidth,
            child: MaterialButton(
              color: CoreColor().appGreen,
              child: Text(
                'r101075'.coreTranslationWord(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
              onPressed: () {
                setState(() {
                  print('emddd');
                  updateProfile();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  _selectDateYear(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1960),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }
}
