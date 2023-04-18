import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class CommentController extends GetxController {
  TextEditingController? commentTextController;
  late String currentTimeZone;
  late String newsId = "";

  @override
  void onInit() {
    getTimeLocation();
    commentTextController = TextEditingController();
    super.onInit();
  }

  getTimeLocation() async {
    currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  }

  @override
  void onClose() {
    // commentTextController?.dispose();
    super.onClose();
  }

  clean() {
    commentTextController?.text = '';
  }
}
