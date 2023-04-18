import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/login/login_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:devita/screens/main_tab.dart';
import 'package:devita/screens/user_views/vertication/user_verification1.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SplashScreen> {
  var contr;
  var storage = GetStorage();

  @override
  void initState() {
    super.initState();

    /// check user id
    if (storage.read('id') != null) {
      GlobalVariables.storageToVar();
      GlobalVariables.checkVerticationLevel(GlobalVariables.verficationFlag, 7);
      switch (GlobalVariables.verticLevel[6]) {
        case 0:
          contr = const UserVerification1();
          break;
        case 1:
          contr = const MainTab();
          break;
        default:
          break;
      }
    } else {
      contr = const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1000,
      splash: Image.asset(
        'assets/images/logo_no_word.png',
      ),
      nextScreen: contr,
      splashTransition: SplashTransition.rotationTransition,
      backgroundColor: const Color.fromARGB(1, 24, 24, 24),
    );
  }
}
