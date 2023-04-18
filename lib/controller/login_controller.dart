import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/model/user_model.dart';
import 'package:devita/screens/main_tab.dart';
import 'package:devita/screens/user_views/vertication/user_verification1.dart';
import 'package:devita/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:devita/helpers/gextensions.dart';

class LoginController extends GetxController {
  TextEditingController? emailTextController;
  TextEditingController? passwordTextController;
  TextEditingController? deviceIdTextController;
  TextEditingController? mobileTypeTextController;
  late String currentTimeZone;
  bool rememberMe = false;

  // UserModel? userData;

  late final UserModelData userModelData;

  @override
  void onInit() {
    getTimeLocation();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    deviceIdTextController = TextEditingController();
    mobileTypeTextController = TextEditingController();
    super.onInit();
  }

  getTimeLocation() async {
    currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  }

  void loginUser(BuildContext context) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    var bodyData = {
      // "username": '89208806',
      // "password": '0611',
      "username": emailTextController?.text,
      "password": passwordTextController?.text,
      // "deviceId": deviceIdTextController?.text,
      // "deviceType": mobileTypeTextController?.text,
      "device_token": GlobalVariables.deviceToken,
      "current_lang": GlobalVariables.localeShort,
      "current_timezone": currentTimeZone
    };
    print(GlobalVariables.deviceToken);

    Services()
        .postRequest(
            json.encode(bodyData), '${CoreUrl.authService}login', false)
        .then((data) {
      var res = json.decode(data.body);
      print(res);
      if (res['code'] == 200) {
        var storage = GetStorage();
        storage.write('userInformation', jsonEncode(res['result']));
        storage.write('token', res['result']['token']);
        storage.write('id', res['result']['id'].toString());

        if (rememberMe == true) {
          storage.write('rememberMe', emailTextController?.text);
        } else {
          storage.remove('rememberMe');
        }

        GlobalVariables.storageToVar();
        GlobalVariables.checkVerticationLevel(
            GlobalVariables.verficationFlag, 7);
        GlobalVariables.roleCheckNavigator(
            6, const UserVerification1(), const MainTab());

        emailTextController?.text = '';
        passwordTextController?.text = '';
      } else {
        Get.back();
        Get.snackbar(
          gWarning,
          res['message_code'].toString().coreTranslationWord(),
          colorText: Colors.black,
        );
      }
    });
  }

  @override
  void onClose() {
    emailTextController?.dispose();
    passwordTextController?.dispose();
    deviceIdTextController?.dispose();
    mobileTypeTextController?.dispose();
    super.onClose();
  }

  clean() {
    emailTextController?.text = '';
    passwordTextController?.text = '';
    deviceIdTextController?.text = '';
    mobileTypeTextController?.text = '';
  }
}
