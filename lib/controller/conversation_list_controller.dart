import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationListController extends GetxController {
  // late List<UserListModel> userList = <UserListModel>[].obs;
  final recieveRes = false.obs;
  // final LoginController _loginControllerFind = Get.find();
  // late List<ConverstaionListModel> conversationList =
  //     <ConverstaionListModel>[].obs;
  late List conversationList = [].obs;
  @override
  void onInit() {
    super.onInit();
  }

  void userConversationList() async {
    var bodyData = {
      // "userId": _loginControllerFind.userModelData.id,
      "skip": 0,
      "limit": 50
    };
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.socketService}conversations', false)
        .then((data) {
      var res = json.decode(data.body);
      if (res['error'] == false) {
        recieveRes.value = true;
        conversationList = res['data'];
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

  changeData(data) {
    ConversationListController _conversationListControllerPut =
        Get.put(ConversationListController());
    _conversationListControllerPut.conversationList.forEach((element) {
      if (element['_id'] == data['conversationId']) {
        element['msgs'] = data;
      }
    });
    update();
  }
}
