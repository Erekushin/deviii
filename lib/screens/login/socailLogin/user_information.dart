import 'dart:async';
import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/login/login_page.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devita/helpers/gextensions.dart';

class UserInfoSocial extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;

  const UserInfoSocial({
    Key? key,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
  }) : super(key: key);
  @override
  _UserInfoSocialState createState() => _UserInfoSocialState();
}

class _UserInfoSocialState extends State<UserInfoSocial> {
  final emailController = TextEditingController();
  final lastNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final phoneController = TextEditingController();
  final _confirmPhone = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectGender = '';
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool resendButton = false;
  bool resendConfirm = false;
  bool readConfirm = true;
  var secondsText = false.obs;

  var screenType = false.obs;
  Timer? timer;
  int start = 120;

  @override
  void initState() {
    emailController.text = widget.email!;
    lastNameController.text = widget.lastName!;
    firstNameController.text = widget.firstName!;
    phoneController.text = widget.phone!;
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    setState(() {
      secondsText.value = true;
    });
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
            secondsText.value = false;
          });
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }

  /// phone number update
  void updatePhone() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    var body = {
      "identity": phoneController.text.toString(),
    };

    Services()
        .postRequest(json.encode(body),
            'https://backend.devita.mn/auth/user/profile/update/phone', true)
        .then((data) {
      var res = json.decode(data.body);
      if (res['code'] == 200) {
        Get.back();
        Get.snackbar(
          gSuccess,
          res['message'].toString().coreTranslationWord(),
          colorText: Colors.white,
        );
        setState(() {
          readConfirm = false;
        });
        startTimer();
      } else {
        Get.back();
        Get.snackbar(
          gWarning,
          res['message'].toString().coreTranslationWord(),
          colorText: Colors.white,
        );
      }
    });
  }

  /// email, phone otp check service
  /// [url] email, phone check service url
  /// [type] otp check function type

  void otpCheck(String url, String type) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    var bodyPhone = {
      "identity": phoneController.text,
      "otp": _confirmPhone.text,
    };

    Services()
        .postRequest(json.encode(bodyPhone),
            '${CoreUrl.authService}user/confirm/phone', false)
        .then((data) {
      var res = json.decode(data.body);
      if (res['code'] == 200) {
        Get.back();
        Get.snackbar(
          gSuccess,
          res['message'],
          colorText: Colors.white,
        );
        setState(() {
          screenType.value = true;
        });
      } else {
        Get.back();
        Get.snackbar(
          gWarning,
          res['message'],
          colorText: Colors.white,
        );
      }
    });
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
      if (res['code'] == 200) {
        Get.back();
        Get.snackbar(
          gSuccess,
          res['message'],
          colorText: Colors.white,
        );
        setState(() {
          updateDeviceToken();
          // GlobalVariables.updateService(context);
          // Get.to(() => MainTab());
        });
      } else {
        Get.back();
        Get.snackbar(
          gSuccess,
          res['message_code'],
          colorText: Colors.white,
        );
      }
    });
  }

  updateDeviceToken() {
    var body = {"token": GlobalVariables.deviceToken};

    Services()
        .postRequest(json.encode(body),
            '${CoreUrl.authService}user/profile/update/device/token', true)
        .then((data) {
      var res = json.decode(data.body);
      if (res['code'] == 200) {
        Get.back();
        Get.snackbar(
          gSuccess,
          res['message'],
          colorText: Colors.white,
        );
        setState(() {
          GlobalVariables.updateService(context);
          // Get.to(() => MainTab());
        });
      } else {
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          width: GlobalVariables.gWidth,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/background.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: verticationOne()

          /// phone validation boliulaad comment hiisen bga
          // screenType.value == false ? numberValidation() : verticationOne(),
          ),
    );
  }

  Widget numberValidation() {
    return Column(
      children: [
        const SizedBox(height: 30),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 10),
          child: IconButton(
            iconSize: 30,
            onPressed: () {
              Get.to(const LoginPage());
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 20),
          child: Text(
            'r101165'.coreTranslationWord(),
            style: context.textTheme.headline2,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            'r101166'.coreTranslationWord(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text('r101061'.coreTranslationWord(),
              style: context.textTheme.bodyText1),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: GlobalVariables.gWidth * 0.6,
                child: TextFormField(
                  controller: phoneController,
                  maxLength: 8,
                  onChanged: (val) {
                    setState(() {
                      if (val.length == 8) {
                        resendButton = true;
                      } else {
                        resendButton = false;
                      }
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty) return 'r101057'.coreTranslationWord();
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: CoreColor().appGreen,
                    ),
                    hintText: "r101061".coreTranslationWord(),
                    hintStyle: const TextStyle(
                      color: Colors.white30,
                    ),
                    counterText: "",
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: GlobalVariables.gWidth / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: MaterialButton(
                    color: resendButton == false ? null : CoreColor().appGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: CoreColor().appGreen),
                    ),
                    child: Text(
                      secondsText.value == false
                          ? 'r101167'.coreTranslationWord()
                          : "$start",
                      style: TextStyle(
                        color: resendButton == false
                            ? CoreColor().appGreen
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: resendButton == false
                        ? null
                        : () {
                            setState(() {
                              updatePhone();
                            });
                          }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: GlobalVariables.gWidth * 0.6,
                child: TextField(
                  readOnly: readConfirm,
                  controller: _confirmPhone,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {
                      if (val.length == 6) {
                        resendConfirm = true;
                      } else {
                        resendConfirm = false;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "r101069".coreTranslationWord(),
                    hintStyle: const TextStyle(
                      color: Colors.white30,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      borderSide:
                          BorderSide(color: CoreColor().appGreen, width: 1.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      borderSide:
                          BorderSide(color: CoreColor().appGreen, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      borderSide: BorderSide(
                        color: CoreColor().appGreen,
                        width: 1.0,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.verified_user,
                      color: CoreColor().appGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: GlobalVariables.gWidth / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: MaterialButton(
                    color: resendConfirm == false ? null : CoreColor().appGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: CoreColor().appGreen,
                      ),
                    ),
                    child: Text(
                      'm101002'.coreTranslationWord(),
                      style: TextStyle(
                        color: resendConfirm == false
                            ? CoreColor().appGreen
                            : Colors.white,
                      ),
                    ),
                    onPressed: resendConfirm == false
                        ? null
                        : () {
                            setState(() {
                              otpCheck('user/confirm/phone', 'phone');
                            });
                          }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget verticationOne() {
    return Form(
      key: _form,
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 10),
              child: IconButton(
                iconSize: 30,
                onPressed: () {
                  Get.to(const LoginPage());
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                'r101063'.coreTranslationWord(),
                style: context.textTheme.headline2,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: GlobalVariables.gWidth - 50,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('r101039'.coreTranslationWord(),
                        style: context.textTheme.bodyText1),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    controller: emailController,
                    validator: (val) {
                      if (val!.isEmpty) return 'Empty';
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: CoreColor().appGreen,
                      ),
                      hintText: "r101039".coreTranslationWord(),
                      hintStyle: const TextStyle(
                        color: Colors.white30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: GlobalVariables.gWidth - 50,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('r101070'.coreTranslationWord(),
                        style: context.textTheme.bodyText1),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: firstNameController,
                    validator: (val) {
                      if (val!.isEmpty) return 'r101057'.coreTranslationWord();
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: CoreColor().appGreen,
                      ),
                      hintText: "r101070".coreTranslationWord(),
                      hintStyle: const TextStyle(
                        color: Colors.white30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: GlobalVariables.gWidth - 50,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('r101071'.coreTranslationWord(),
                        style: context.textTheme.bodyText1),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastNameController,
                    validator: (val) {
                      if (val!.isEmpty) return 'r101057'.coreTranslationWord();
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: CoreColor().appGreen,
                      ),
                      hintText: "r101071".coreTranslationWord(),
                      hintStyle: const TextStyle(
                        color: Colors.white30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: GlobalVariables.gWidth - 50,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('r101072'.coreTranslationWord(),
                        style: context.textTheme.bodyText1),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: GlobalVariables.gWidth - 50,
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
                ],
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
              width: GlobalVariables.gWidth - 50,
              child: MaterialButton(
                color: CoreColor().appGreen,
                child: Text(
                  'r101075'.coreTranslationWord(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
                onPressed: () {
                  setState(() {
                    if (_form.currentState?.validate() == true) {
                      updateProfile();
                    }
                  });
                },
              ),
            ),
          ],
        ),
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
