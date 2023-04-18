import 'dart:async';
import 'dart:convert';
import 'package:devita/controller/signup_controller.dart';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/screens/login/login_page.dart';
import 'package:get/get.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:devita/helpers/gextensions.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({
    Key? key,
  }) : super(key: key);
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final SignUpController _signUpController = Get.put(SignUpController());
  bool hidePassword = true;

  int temp = 0;
  String inputCode = "";
  FocusNode focusNode = FocusNode();
  late Timer timer;
  RxInt start = 60.obs;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (start.value > 0) {
        setState(() {
          start.value = start.value - 1;
        });
      } else {
        setState(() {
          timer.cancel();
        });
      }
    });
  }

  bool screen1 = false;
  bool screen2 = false;
  bool screen3 = false;
  bool test = false;

  List niitValue = [0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    emailController.text = GlobalVariables.email;
    changeScreen(1);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  sendOtp(String email) {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    var bodyData = {
      "identity": email,
    };

    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}auth/user/reset/password/otp', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        print('tesdadas $response');
        if (response['code'] == 200) {
          setState(() {
            Get.back();
            changeScreen(2);
            startTimer();
          });
        } else {
          Get.back();
          Get.snackbar(
            gWarning,
            response['message_code'].toString().coreTranslationWord(),
            colorText: Colors.white,
          );
        }
      },
    );
  }

  passwordChangeSet() {
    var opt_ = '';
    for (var e in niitValue) {
      opt_ += e;
    }
    var bodyData = {
      "email": emailController.text,
      "code": opt_,
      "password": passwordController.text,
      "repeat_password": confirmPasswordController.text
    };
    print("sda we : $bodyData");
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}auth/user/reset/password/set', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        print('tesdadas $response');
        if (response['code'] == 200) {
          modal();
          setState(
            () {
              Get.to(() => const LoginPage());
            },
          );
        } else {
          Get.snackbar(
            gWarning,
            response['message_code'].toString().coreTranslationWord(),
            colorText: Colors.white,
          );
        }
      },
    );
  }

  otpCheck(String otp) {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    var bodyData = {
      "email": emailController.text,
      "code": otp,
    };
    print(bodyData);
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}auth/user/reset/password/check', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        print('tesdadas $response');
        if (response['code'] == 200) {
          setState(() {
            changeScreen(3);
            Get.back();
          });
        } else {
          Get.back();
          Get.snackbar(
            gWarning,
            response['message_code'].toString().coreTranslationWord(),
            colorText: Colors.white,
          );
        }
      },
    );
  }

  changeScreen(int val) {
    switch (val) {
      case 1:
        screen1 = true;
        screen2 = false;
        screen3 = false;
        break;
      case 2:
        screen1 = false;
        screen2 = true;
        screen3 = false;
        break;
      case 3:
        screen1 = false;
        screen2 = false;
        screen3 = true;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColor().backgroundNew,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 25,
          ),
          child: screen1 == true
              ? emailSendOtp()
              : screen2 == true
                  ? verticationCode()
                  : createPassword(),
        ),
      ),
    );
  }

  Widget emailSendOtp() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 32,
              color: CoreColor().appGreen,
            ),
          ),
        ),
        Container(
          height: 35,
        ),
        Text(
          'r101235'.coreTranslationWord(),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 25,
            color: CoreColor().appGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 10,
        ),
        Container(
          height: 20,
        ),
        Text(
          'r101039'.coreTranslationWord(),
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
        Container(
          height: 5,
        ),
        TextFormField(
          readOnly: true,
          controller: emailController,
          decoration: InputDecoration(
            labelText: "",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: CoreColor().appGreen,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: CoreColor().appGreen,
              ),
            ),
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: GlobalVariables.gWidth - 50,
          child: MaterialButton(
            color: CoreColor().appGreen,
            child: Text(
              'r101036'.coreTranslationWord(),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              print('darkeeeee');
              print(emailController.text);
              if (emailController.text != '') {
                setState(() {
                  sendOtp(emailController.text);
                });
              } else {
                Get.snackbar(
                  gWarning,
                  'Enter your email address !',
                  colorText: Colors.white,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget verticationCode() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
              size: 32,
              color: CoreColor().appGreen,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Text(
          'r101216'.coreTranslationWord(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: CoreColor().appGreen,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _textFieldOTP(first: true, last: false, index: 1),
                  _textFieldOTP(first: false, last: false, index: 2),
                  _textFieldOTP(first: false, last: false, index: 3),
                  _textFieldOTP(first: false, last: false, index: 4),
                  _textFieldOTP(first: false, last: false, index: 5),
                  _textFieldOTP(first: false, last: true, index: 6),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'r101296'.coreTranslationWord(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => Text(
                  start.toString(),
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              Obx(
                () => start.value == 0
                    ? TextButton(
                        onPressed: () {
                          if (emailController.text != '') {
                            setState(() {
                              start.value = 60;
                              sendOtp(emailController.text);
                            });
                          }
                        },
                        child: Text(
                          'r101297'.coreTranslationWord(),
                        ),
                        style: TextButton.styleFrom(
                          primary: CoreColor().appGreen,
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _textFieldOTP({required bool first, last, required index}) {
    return SizedBox(
      height: 75,
      width: 55,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            niitValue.removeAt(index - 1);
            niitValue.insert(index - 1, value);
            {
              if (index == 6 && value != '' && last == true) {
                var opt_ = '';
                for (var e in niitValue) {
                  opt_ += e;
                }
                otpCheck(opt_);
              }

              if (value.length == 1 && last == false) {
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && first == false) {
                FocusScope.of(context).previousFocus();
              }
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: CoreColor().appGreen,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: CoreColor().appGreen,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  Widget createPassword() {
    return Form(
      key: _form,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                size: 32,
                color: CoreColor().appGreen,
              ),
            ),
          ),
          Container(
            height: 35,
          ),
          Text(
            'r101058'.coreTranslationWord(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 25,
              color: CoreColor().appGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 30,
          ),
          Text(
            'r101040'.coreTranslationWord(),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          TextFormField(
            obscureText: hidePassword,
            validator: (val) {
              if (val!.isEmpty) return 'r101057'.coreTranslationWord();
              bool passwordValid = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                  .hasMatch(val);
              if (!passwordValid) {
                return '''
Password must be at least 8 characters,
include an uppercase letter, number and symbol.   ''';
              }
              return null;
            },
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "******",
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.pink,
                icon: Icon(
                  hidePassword ? Icons.visibility : Icons.visibility_off,
                  color: CoreColor().appGreen,
                ),
              ),
              labelStyle: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: CoreColor().appGreen,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: CoreColor().appGreen,
                ),
              ),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          Text(
            'r101059'.coreTranslationWord(),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          TextFormField(
            controller: confirmPasswordController,
            style: const TextStyle(
              color: Colors.white,
            ),
            obscureText: hidePassword,
            validator: (val) {
              if (val!.isEmpty) return 'r101057'.coreTranslationWord();
            },
            decoration: InputDecoration(
              hintText: "******",
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.pink,
                icon: Icon(
                  hidePassword ? Icons.visibility : Icons.visibility_off,
                  color: CoreColor().appGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: GlobalVariables.gWidth - 50,
            child: MaterialButton(
              color: test == false ? null : CoreColor().appGreen,
              child: Text(
                'r101235'.coreTranslationWord(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
              onPressed: () {
                setState(() {
                  if (_form.currentState?.validate() == true) {
                    passwordChangeSet();
                  }
                });
              },
            ),
          ),
        ],
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
