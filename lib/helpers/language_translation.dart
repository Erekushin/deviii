import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gvariables.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

Map<String, Map<String, String>> testManlai = {
  "mn_MN": {},
  "en_US": {},
};

class TextTranslations extends Translations {
  // Map<String, Map<String, String>> map = {};

  @override
  Map<String, Map<String, String>> get keys => testManlai;
}

class TranslationApi {
  getTranslationListMock(changeLang) async {
    var bodyData = {"code": changeLang, "platform": "1"};

    final response = await http.post(
      Uri.parse(CoreUrl.langService),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(bodyData),
    );
    var res = json.decode(utf8.decode(response.bodyBytes));

    Map<String, String> langKeys = {};
    for (var item in res['result']['items']) {
      item.forEach((key, value) {
        langKeys[key] = value;
      });
    }
    GlobalVariables.languageStatic
        .update(GlobalVariables.localeLong, (value) => langKeys);
  }

  static Future loadTranslations(changeLang) async {
    await TranslationApi().getTranslationListMock(changeLang);
  }
}
