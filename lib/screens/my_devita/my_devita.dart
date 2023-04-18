import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/my_devita/daily_inputs/daily_input.dart';
import 'package:devita/screens/my_devita/unofficial/unofficial_page.dart';
import 'package:devita/screens/my_devita/official/official_page.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDevita extends StatefulWidget {
  const MyDevita({Key? key}) : super(key: key);

  @override
  _MyDevitaState createState() => _MyDevitaState();
}

class _MyDevitaState extends State<MyDevita> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //searchar used for it test
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
            'r101081'.coreTranslationWord(),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: Column(
        children: [
          buttonCustom('r101258'.coreTranslationWord(),
              'assets/images/background1.png', 1),
          buttonCustom('r101334'.coreTranslationWord(),
              'assets/images/background2.png', 2),
          buttonCustom('r101320'.coreTranslationWord(),
              'assets/images/background3.png', 3),
        ],
      ),
    );
  }

  Widget buttonCustom(String value, String imgUrl, index) {
    return Expanded(
      child: Stack(
        children: [
          Image.asset(
            imgUrl,
            fit: BoxFit.cover,
            width: GlobalVariables.gWidth,
          ),
          Center(
            child: Container(
              width: GlobalVariables.gWidth / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CoreColor().appGreen,
                    CoreColor().oceanSurface,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: MaterialButton(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    switch (index) {
                      case 1:
                        Get.to(() => const DailyInput());
                        break;
                      case 2:
                        Get.to(() => const Devitaofficial());
                        break;
                      case 3:
                        Get.to(() => const OfficialPage());
                        break;
                      default:
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
