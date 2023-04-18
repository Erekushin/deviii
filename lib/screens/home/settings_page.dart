import 'package:devita/controller/login_controller.dart';
import 'package:devita/helpers/gextensions.dart';

import 'package:devita/helpers/language_translation.dart';
import 'package:devita/screens/login/change_password.dart';
import 'package:devita/screens/login/login_page.dart';
import 'package:devita/screens/main_tab.dart';
import 'package:devita/style/color.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:devita/helpers/gvariables.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static final LoginController _loginController = Get.put(LoginController());
  int selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CoreColor().backgroundNew,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          leadingWidth: 80,
          titleSpacing: 0.0,
          title: Text(
            'r101084'.coreTranslationWord(),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: 70,
            child: Container(
              child: settingMenu(),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingMenu() {
    return Scaffold(
      body: ListView.builder(
        itemCount: options.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return const SizedBox(height: 5.0);
          } else if (index == options.length + 1) {
            return const SizedBox(height: 70.0);
          }
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10.0),
            width: double.infinity,
            height: 60.0,
            decoration: BoxDecoration(
              color: CoreColor().backgroundNew,
              borderRadius: BorderRadius.circular(15.0),
              border: selectedOption == index - 1
                  ? Border.all(
                      color: CoreColor().backgroundNew,
                    )
                  : null,
            ),
            child: ListTile(
              title: Text(
                options[index - 1].title,
                style: TextStyle(
                  color: selectedOption == index - 1
                      ? CoreColor().appGreen
                      : Colors.white,
                ),
              ),
              leading: options[index - 1].icon,
              onTap: () {
                setState(() {
                  selectedOption = index - 1;
                  if (selectedOption == 0) {
                    showLocaleDialog(context);
                  } else if (selectedOption == 2) {
                    print('nogooon');
                    print(GlobalVariables.email);
                    Get.to(() => const ChangePassword());
                  } else if (selectedOption == 3) {
                    final storage = GetStorage();
                    // storage.erase();
                    storage.remove("userInformation");
                    storage.remove("token");
                    storage.remove("id");
                    storage.remove("localeShort");
                    storage.remove("localeLong");
                    storage.remove("totalWeigth");
                    storage.remove("totalHeigth");
                    storage.remove("bloodValue");
                    if (storage.read('rememberMe') != null) {
                      setState(() {
                        _loginController.emailTextController?.text =
                            storage.read('rememberMe');
                        _loginController.rememberMe = true;
                      });
                    }
                    Get.to(() => const LoginPage());
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }

  /// change language dialog
  showLocaleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'r101246'.coreTranslationWord(),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.separated(
            itemBuilder: (context, index) => InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(GlobalVariables.locales[index]['name']),
                ),
                onTap: () async {
                  GlobalVariables.localeShort = GlobalVariables.locales[index]
                          ['locale']
                      .toString()
                      .split('_')[0];
                  GlobalVariables.language.value =
                      GlobalVariables.locales[index]['name'];
                  GlobalVariables.localeLong =
                      GlobalVariables.locales[index]['locale'].toString();
                  await TranslationApi.loadTranslations(
                      GlobalVariables.localeShort);
                  setState(() {
                    var storage = GetStorage();
                    storage.write("localeShort", GlobalVariables.localeShort);
                    storage.write("localeLong",
                        GlobalVariables.locales[index]['locale'].toString());
                    print(GlobalVariables.locales[index]);

                    GlobalVariables.changeLanguage(
                        GlobalVariables.locales[index]['locale']);
                    Get.to(() => const MainTab());
                  });
                }),
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black,
            ),
            itemCount: GlobalVariables.locales.length,
          ),
        ),
      ),
    );
  }
}

class Option {
  Icon icon;
  String title;

  Option({
    required this.icon,
    required this.title,
  });
}

final options = [
  Option(
    icon: const Icon(Icons.language, size: 30.0),
    title: 'r101295'.coreTranslationWord(),
  ),
  Option(
    icon: const Icon(Icons.photo_filter_sharp, size: 30.0),
    title: 'r101247'.coreTranslationWord(),
  ),
  Option(
    icon: const Icon(Icons.lock, size: 30.0),
    title: 'r101235'.coreTranslationWord(),
  ),
  Option(
    icon: const Icon(Icons.login, size: 30.0),
    title: 'r101133'.coreTranslationWord(),
  ),
];
