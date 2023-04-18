import 'dart:async';
import 'dart:convert';
import 'package:devita/controller/signup_controller.dart';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/login/login_page.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devita/helpers/gextensions.dart';

class OTPVerification extends StatefulWidget {
  const OTPVerification({Key? key}) : super(key: key);

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  ///[_signUpController] get signup controller data
  final SignUpController _signUpController = Get.find();
  final TextEditingController _confirmEmail = TextEditingController();
  final TextEditingController _confirmPhone = TextEditingController();

  bool emailButton = false;
  bool emailText = false;
  bool resendEmail = false;

  bool phoneButton = false;
  bool phoneText = true;
  bool resendPhone = false;

  int resendSecond = 120;

  /// resend email, phone otp service
  /// [url] email, phone otp resend url
  void resendOtp(String url) async {
    setState(() {
      resendEmail = false;
    });

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    var body = {
      "identity": _signUpController.emailTextController!.text,
    };

    Services()
        .postRequest(
            json.encode(body), CoreUrl.authService.toString() + url, false)
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
          timeoutCall();
        });
      } else {
        Get.back();
        Get.snackbar(
          gSuccess,
          res['message'],
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
    var bodyEmail = {
      "identity": _signUpController.emailTextController!.text,
      "otp": _confirmEmail.text,
    };

    var bodyPhone = {
      "identity": _signUpController.phoneTextController!.text,
      "otp": _confirmPhone.text,
    };

    Services()
        .postRequest(
            type == "email" ? json.encode(bodyEmail) : json.encode(bodyPhone),
            CoreUrl.authService.toString() + url,
            false)
        .then((data) {
      var res = json.decode(data.body);
      print('wetrfd: $res');
      if (res['code'] == 200) {
        Get.back();
        Get.snackbar(
          gSuccess,
          res['message'],
          colorText: Colors.white,
        );
        setState(() {
          setState(() {
            phoneButton = false;
            phoneText = true;
          });
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              Get.to(() => const LoginPage());
            });
          });
        });

        /// phone auth boliulsan bga
        // setState(() {
        //   if (type == 'email') {
        //     emailText = true;
        //     emailButton = false;
        //     phoneText = false;
        //   } else {
        //     setState(() {
        //       phoneButton = false;
        //       phoneText = true;
        //     });
        //     Future.delayed(const Duration(seconds: 2), () {
        //       setState(() {
        //         Get.to(() => const LoginPage());
        //       });
        //     });
        //   }
        // });
      } else {
        Get.back();
        Get.snackbar(
          gWarning,
          res['message'],
          colorText: Colors.white,
        );
        setState(() {
          // emailText = true;
          emailButton = false;
          phoneText = false;
        });
      }
    });
  }

  /// resend button timeout
  timeoutCall() async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSecond != 0) {
        setState(() {
          resendSecond--;
        });
      } else {
        setState(() {
          resendEmail = true;
        });
        timer.cancel();
      }
      // print(resendSecond);
    });
    // Future.delayed(Duration(seconds: resendSecond), () { // resendSecond = 120
    //   setState(() {
    //     resend Email = true;
    //   });
    // });
  }

  @override
  void initState() {
    super.initState();
    timeoutCall();
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
          child: screen(),
        ),
      ),
    );
  }

  Widget screen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              iconSize: 30,
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'r101063'.coreTranslationWord(),
            style: context.textTheme.headline2,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'r101064'.coreTranslationWord(), // resend
                style: context.textTheme.headline1,
              ),
              resendEmail == true
                  ? Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: MaterialButton(
                        child: Text(
                          'r101065'.coreTranslationWord(),
                          style: TextStyle(
                            color: CoreColor().appGreen,
                            fontSize: 12,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            resendOtp('user/otpsend/email');
                            resendSecond = 120;
                            timeoutCall;
                          });
                        },
                      ),
                    )
                  : SizedBox(
                      width: 35,
                      height: 35,
                      child: Stack(
                        children: [
                          CircularProgressIndicator(
                            value: resendSecond / 120,
                            valueColor:
                                AlwaysStoppedAnimation(CoreColor().appGreen),
                            strokeWidth: 2,
                          ),
                          Center(
                            child: Text(resendSecond.toString() + "s"),
                          )
                        ],
                      )),
            ],
          ),
          Text(
            'r101066'.coreTranslationWord(),
            style: const TextStyle(
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),
          Text(
            _signUpController.emailTextController!.text,
            style: context.textTheme.bodyText2,
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: GlobalVariables.gWidth * 0.6,
                child: TextFormField(
                  readOnly: emailText,
                  onChanged: (val) {
                    setState(() {
                      if (val != '') {
                        emailButton = true;
                      } else {
                        emailButton = false;
                      }
                    });
                  },
                  controller: _confirmEmail,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "r101067".coreTranslationWord(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(
                          color: emailText == true
                              ? Colors.grey
                              : CoreColor().appGreen,
                          width: 1.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(
                          color: emailText == true
                              ? Colors.grey
                              : CoreColor().appGreen,
                          width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(
                        color: emailText == true
                            ? Colors.grey
                            : CoreColor().appGreen,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: GlobalVariables.gWidth / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color:
                      emailButton == false ? Colors.grey : CoreColor().appGreen,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.check,
                    size: 35,
                    color: Colors.white,
                  ),
                  onPressed: emailButton == false
                      ? null
                      : () {
                          setState(() {
                            otpCheck('user/confirm/email', 'email');
                          });
                        },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Text(
          //   'r101068'.coreTranslationWord(),
          //   style: context.textTheme.headline1,
          // ),
          // Row(
          //   children: [
          //     Text(
          //       'r101066'.coreTranslationWord(),
          //       style: const TextStyle(
          //         fontWeight: FontWeight.w200,
          //         color: Colors.white,
          //       ),
          //     ),
          //     const SizedBox(width: 10),
          //     Text(
          //       _signUpController.phoneTextController!.text,
          //       style: context.textTheme.bodyText2,
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 10),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     SizedBox(
          //       width: GlobalVariables.gWidth * 0.6,
          //       child: TextField(
          //         readOnly: phoneText,
          //         controller: _confirmPhone,
          //         keyboardType: TextInputType.number,
          //         onChanged: (val) {
          //           setState(() {
          //             if (val != '') {
          //               phoneButton = true;
          //             } else {
          //               phoneButton = false;
          //             }
          //           });
          //         },
          //         decoration: InputDecoration(
          //           hintText: "r101069".coreTranslationWord(),
          //           enabledBorder: OutlineInputBorder(
          //             borderRadius:
          //                 const BorderRadius.all(Radius.circular(12.0)),
          //             borderSide: BorderSide(
          //                 color: phoneText == true
          //                     ? Colors.grey
          //                     : CoreColor().appGreen,
          //                 width: 1.0),
          //           ),
          //           disabledBorder: OutlineInputBorder(
          //             borderRadius:
          //                 const BorderRadius.all(Radius.circular(12.0)),
          //             borderSide: BorderSide(
          //                 color: phoneText == true
          //                     ? Colors.grey
          //                     : CoreColor().appGreen,
          //                 width: 1.0),
          //           ),
          //           focusedBorder: OutlineInputBorder(
          //             borderRadius:
          //                 const BorderRadius.all(Radius.circular(12.0)),
          //             borderSide: BorderSide(
          //               color: phoneText == true
          //                   ? Colors.grey
          //                   : CoreColor().appGreen,
          //               width: 1.0,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 20),
          //     Container(
          //       width: GlobalVariables.gWidth / 4,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       child: MaterialButton(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10.0),
          //           side: BorderSide(
          //             color: phoneButton == false
          //                 ? Colors.grey
          //                 : CoreColor().appGreen,
          //           ),
          //         ),
          //         child: Text(
          //           'm101002'.coreTranslationWord(),
          //           style: TextStyle(
          //             color: phoneButton == false
          //                 ? Colors.grey
          //                 : CoreColor().appGreen,
          //           ),
          //         ),
          //         onPressed: phoneButton == false
          //             ? null
          //             : () {
          //                 setState(() {
          //                   otpCheck('user/confirm/phone', 'phone');
          //                 });
          //               },
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 20),
          const Divider(
            color: Colors.grey,
            height: 2.0,
          ),
        ],
      ),
    );
  }
}
