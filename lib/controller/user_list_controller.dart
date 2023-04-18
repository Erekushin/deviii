import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/model/user_list_model.dart';
import 'package:devita/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListController extends GetxController {
  late List<UserListModel> userList = <UserListModel>[].obs;
  final recieveRes = false.obs;

  void userListService() async {
    var bodyData = {};
    Services()
        .postRequest(
            json.encode(bodyData), '${CoreUrl.authService}userList', true)
        .then((data) {
      userList.clear();

      var res = json.decode(data.body);
      if (res['code'] == 200) {
        for (var item in res['result']) {
          userList.add(
            UserListModel(
              item["_id"],
              item['email'] ?? '',
              item['phone'] ?? '',
              item['firstName'] ?? '',
              item['lastName'] ?? '',
              item['provider'],
              item['picture'] ?? '',
              item['googleId'] ?? '',
              item['facebookId'] ?? '',
            ),
          );
        }
        recieveRes.value = true;
        update();
      } else {
        Get.back();
        Get.snackbar(
          gSuccess,
          res['message'],
          colorText: Colors.black,
        );
        recieveRes.value = true;
        update();
      }
    });
  }
}
