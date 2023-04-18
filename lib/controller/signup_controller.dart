import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/screens/user_views/vertication/otp_veritication.dart';
import 'package:devita/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:devita/helpers/gextensions.dart';

class SignUpController extends GetxController {
  TextEditingController? emailTextController;
  TextEditingController? phoneTextController;
  TextEditingController? passwordTextController;
  TextEditingController? repeatPassTextController;

  @override
  void onInit() {
    emailTextController = TextEditingController();
    phoneTextController = TextEditingController();
    passwordTextController = TextEditingController();
    repeatPassTextController = TextEditingController();

    super.onInit();
  }

  void signUp(BuildContext context) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    var storage = GetStorage();

    var body = {
      "email": emailTextController?.text,
      "phone_no": phoneTextController?.text,
      "password": passwordTextController?.text,
      "repeat_password": repeatPassTextController?.text,
      "one_id": storage.read('getAddress')
    };
    print(body);
    Services()
        .postRequest(json.encode(body), '${CoreUrl.authService}signup', false)
        .then((data) {
      var res = json.decode(data.body);
      print(res);
      if (res['code'] == 200) {
        Get.to(() => const OTPVerification());
      } else {
        Get.back();
        Get.snackbar(
          gWarning,
          res['message_code'].toString().coreTranslationWord(),
          colorText: Colors.white,
        );
      }
    });
  }

  @override
  void onClose() {
    emailTextController?.dispose();
    phoneTextController?.dispose();
    passwordTextController?.dispose();
    repeatPassTextController?.dispose();

    super.onClose();
  }

  clean() {
    emailTextController?.text = '';
    phoneTextController?.text = '';
    passwordTextController?.text = '';
    repeatPassTextController?.text = '';
  }
}
