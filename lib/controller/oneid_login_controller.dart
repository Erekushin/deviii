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

class OneIDLoginController extends GetxController {
  TextEditingController? oneIdTextController;
  TextEditingController? deviceIdTextController;
  TextEditingController? mobileTypeTextController;
  String? currentTimeZone;
  bool rememberMe = false;

  // UserModel? userData;

  late final UserModelData userModelData;

  @override
  void onInit() {
    oneIdTextController = TextEditingController();
    deviceIdTextController = TextEditingController();
    mobileTypeTextController = TextEditingController();
    super.onInit();
  }

  getTimeLocation(BuildContext context) async {
    currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    print("currentTimeZone : $currentTimeZone");
    if (currentTimeZone != null) {
      loginUser(context);
    }
  }

  void loginUser(BuildContext context) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    var bodyData = {
      "one_id": oneIdTextController?.text,
      "device_token": GlobalVariables.deviceToken,
      "current_lang": "en",
      "current_timezone": currentTimeZone,
    };
    Services()
        .postRequest(
            json.encode(bodyData), '${CoreUrl.authService}login/one', false)
        .then((data) {
      var res = json.decode(data.body);
      print('onelogin: $res');
      if (res['code'] == 200) {
        var storage = GetStorage();
        storage.write('userInformation', jsonEncode(res['result']));
        storage.write('token', res['result']['token']);
        storage.write('id', res['result']['id'].toString());
        storage.write('localeshort', 'en');

        GlobalVariables.storageToVar();
        GlobalVariables.checkVerticationLevel(
            GlobalVariables.verficationFlag, 7);
        GlobalVariables.roleCheckNavigator(
            6, const UserVerification1(), const MainTab());
      } else {
        Get.back();
        Get.snackbar(
          gWarning,
          res['message'],
          colorText: Colors.black,
        );
      }
    });
  }

  @override
  void onClose() {
    oneIdTextController?.dispose();
    deviceIdTextController?.dispose();
    mobileTypeTextController?.dispose();
    super.onClose();
  }

  clean() {
    oneIdTextController?.text = '';
    deviceIdTextController?.text = '';
    mobileTypeTextController?.text = '';
  }
}
