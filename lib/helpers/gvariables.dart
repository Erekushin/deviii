import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/model/messeges_model.dart';
import 'package:devita/screens/main_tab.dart';
import 'package:devita/screens/user_views/vertication/user_verification1.dart';
import 'package:devita/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GlobalVariables {
  static double gWidth = Get.width;
  static double gHeight = Get.height;
  static dynamic gmailData;
  static dynamic facebookData;
  static String? deviceId;
  static String? deviceType;
  static String? deviceToken;
  static var language = ''.obs;

  static List verticLevel = [];

  /// user information data start
  static String email = '';
  static int expiredAt = 0;
  static String firstName = '';
  static int id = 0;
  static String lastName = '';
  static String phoneNumber = '';
  static String token = '';
  static int verficationFlag = 0;
  static String addressCurrent = "";
  static String addressPermanent = "";
  static String birthDate = "";
  static String contactPhoneNo = "";
  static String createdDate = "";
  static String idCardBack = "";
  static String idCardFront = "";
  static String idCardSelfie = "";
  static String profileImage = "";
  static bool socailImg = false;
  static String userRole = "";
  static String selfieImg = "";
  static String status = "";
  static var sendData;
  static int employId = 0;
  static String doctorName = '';
  // static List messageListAll = [].obs;
  static List<MessageData> messageListAll = <MessageData>[].obs;
  static RxInt selectedDays = 0.obs;
  static RxString selectedDateService = ''.obs;
  static String selectedRoomName = "";
  static String localeShort = '';
  static String localeLong = '';
  static String roomID = '';
  static RxBool connectionType = false.obs;
  static String addressWallet = '';
  static RxInt totalStep = 0.obs;
  static RxDouble totalHeart = 0.0.obs;
  static RxDouble totalWeight = 0.0.obs;
  static RxDouble totalHeight = 0.0.obs;
  static RxDouble totalTemp = 0.0.obs;
  static RxInt totalWater = 0.obs;
  static RxDouble indicatorValue = 0.0.obs;
  static RxString bloodValue = ''.obs;

  /// language word list
  static Map<String, Map<String, String>> languageStatic = {
    "mn_MN": {},
    "kr_KR": {},
    "en_US": {},
    "sp_ES": {},
    "ru_RU": {},
    "fr_FR": {},
  };

  /// chat scroll
  static ScrollController scrollController = ScrollController();
  static scrollDown() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 3),
      curve: Curves.fastOutSlowIn,
    );
  }

  /// word change function
  // static coreTranslationWord(String key) {
  //   return languageStatic["mn_MN"]?[key];
  // }

  /// user information data end

  /// [storageToVar] user variables assign a value
  static storageToVar() {
    var storage = GetStorage();
    String? userInformation = storage.read('userInformation');
    Map<String, dynamic> storageLocal =
        jsonDecode(userInformation!) as Map<String, dynamic>;
    GlobalVariables.email = storageLocal['email_address_primary'];
    // GlobalVariables.expiredAt = storageLocal['expired_at'];
    GlobalVariables.firstName = storageLocal['first_name'];
    GlobalVariables.id = storageLocal['id'];
    GlobalVariables.lastName = storageLocal['last_name'];
    GlobalVariables.phoneNumber = storageLocal['cell_no_primary'];
    GlobalVariables.profileImage = storageLocal['profile_img'];
    GlobalVariables.socailImg = storageLocal['profile_img_social'];
    if (storageLocal['token'] != null) {
      GlobalVariables.token = storageLocal['token'];
    }
    GlobalVariables.verficationFlag = storageLocal['verification_flag'];
  }

  ///[check] user vertication level check
  static checkVerticationLevel(int vertication, int step) {
    var verBinary = vertication.toRadixString(2);
    String reversedData = verBinary.toString().split('').reversed.join();
    if (reversedData.length < step) {
      num test = step - reversedData.length;
      for (var i = 0; i < test; i++) {
        reversedData += '0';
      }
    }
    for (var i = 0; i < step; i++) {
      if (reversedData[i] == '1') {
        verticLevel.add(1);
      } else {
        verticLevel.add(0);
      }
    }
    if (reversedData.length >= 60) {
      if (reversedData[60] == '1') {
        print('aprroved');
      } else {
        print('not aprroved');
      }
    }
  }

  /// [roleCheckNavigator]user role check
  /// [
  ///   "0: email",
  ///   "1: phone",
  ///   "2: idCardFront",
  ///   "3: idCardBack",
  ///   "4: IdCardWithSelfie",
  ///   "5: Face Recognition",
  ///   "6: Main Info verify (etc first_name, last_name)",
  ///   "7: Address verification"
  /// ]
  static roleCheckNavigator(index, pending, success) async {
    switch (GlobalVariables.verticLevel[index]) {
      case 0:
        Get.to(pending);
        break;
      case 1:
        Get.to(success);
        break;
      default:
        break;
    }
  }

  /// [updateService] user information update
  static updateService(BuildContext context) async {
    var bodyData = {};
    Services()
        .postRequest(
            json.encode(bodyData), '${CoreUrl.authService}user/profile', true)
        .then((data) {
      var res = json.decode(data.body);
      if (res['code'] == 200) {
        var storage = GetStorage();
        storage.write('userInformation', jsonEncode(res['result']));
        GlobalVariables.storageToVar();
        print('adad');
        switch (GlobalVariables.verficationFlag) {
          case 3:
            Get.to(() => const UserVerification1());
            break;
          default:
            Get.to(() => const MainTab());
            break;
        }
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

  ///[changeLanguage] change app language
  static changeLanguage(Locale locale) {
    print('heleee end duudsandaaa');
    Get.back();
    Get.updateLocale(locale);
  }

  /// get device screen size
  static double getScreenHeightExcludeSafeArea(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return height - padding.top - padding.bottom;
  }

  /// languages list
  static List locales = [
    {'name': 'Mongolian', 'locale': const Locale('mn', 'MN')},
    {'name': 'Korean', 'locale': const Locale('kr', 'KR')},
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': 'Spanish', 'locale': const Locale('sp', 'ES')},
    {'name': 'Russian', 'locale': const Locale('ru', 'RU')},
    {'name': 'French', 'locale': const Locale('fr', 'FR')},
  ];

  static languageCheck(String value) {
    switch (value) {
      case 'mn_MN':
        return GlobalVariables.language.value = 'Mongolian';
      case 'ko_KR':
        return GlobalVariables.language.value = 'Korean';
      case 'en_US':
        return GlobalVariables.language.value = 'English';
      case 'es_ES':
        return GlobalVariables.language.value = 'Spain';
      case 'ru_RU':
        return GlobalVariables.language.value = 'Russian';
      case 'fr_FR':
        return GlobalVariables.language.value = 'France';
      default:
        break;
    }
  }

  /// [hexOfRGBA] gex color code to RGBA
  static int hexOfRGBA(int r, int g, int b, {double opacity = 1}) {
    r = (r < 0) ? -r : r;
    g = (g < 0) ? -g : g;
    b = (b < 0) ? -b : b;
    opacity = (opacity < 0) ? -opacity : opacity;
    opacity = (opacity > 1) ? 255 : opacity * 255;
    r = (r > 255) ? 255 : r;
    g = (g > 255) ? 255 : g;
    b = (b > 255) ? 255 : b;
    int a = opacity.toInt();

    return int.parse(
        '0x${a.toRadixString(16)}${r.toRadixString(16)}${g.toRadixString(16)}${b.toRadixString(16)}');
  }

  static String? validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  static connectOneId(oneId, type) {
    var bodyData = {
      "one_id": oneId.toString(),
    };

    Services()
        .postRequest(json.encode(bodyData),
            'https://backend.devita.mn/auth/user/profile/update/oneid', true)
        .then((data) {
      var res = json.decode(data.body);
      if (res['code'] == 200) {
        switch (type) {
          case 1:
            Get.back();
            Get.snackbar(
              gSuccess,
              res['message'],
              colorText: Colors.black,
            );
            break;
          case 2:
            Get.to(() => const MainTab());
            Get.snackbar(
              gSuccess,
              res['message'],
              colorText: Colors.black,
            );
            break;
          default:
        }
      } else {
        Get.snackbar(
          gWarning,
          res['message'],
          colorText: Colors.black,
        );
      }
    });
  }
}

// /// string extension capitalize
// extension StringExtension on String {
//   String capitalize() {
//     if (isEmpty) {
//       return "";
//     }
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }

//   ///First 3 character of string
//   first3() {
//     return substring(0, 3);
//   }
// }

extension EncryptionRSA on String {
  // Future<String?> rsa() async {
  //   final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
  //   final key = Key('value');
  //   final iv = IV.fromLength(16);

  //   final encrypter = Encrypter(AES(key));

  //   final encrypted = encrypter.encrypt(plainText, iv: iv);
  //   final decrypted = encrypter.decrypt(encrypted, iv: iv);

  //   print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
  //   print(encrypted.base64);
  //   return '';
  // }
}

// extension InputExtension on TextField {
//   devitaTextField() {
//     // return TextField();
//     var s = TextField(
//       decoration: InputDecoration(
//         fillColor: CoreColor().grey,
//         filled: true,
//         contentPadding: const EdgeInsets.all(12),
//         hintStyle:
//             const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(12.0)),
//           borderSide: BorderSide(color: CoreColor().appGreen, width: 1.0),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(12.0)),
//           borderSide: BorderSide(color: CoreColor().appGreen, width: 1.0),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(12.0)),
//           borderSide: BorderSide(color: CoreColor().appGreen, width: 1.0),
//         ),
//       ),
//     );
//     return s;
//   }
// }
