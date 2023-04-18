import 'package:devita/helpers/gvariables.dart';
import 'package:flutter/material.dart';
import 'package:devita/style/color.dart';
import 'package:get/get.dart';
import 'package:devita/helpers/gextensions.dart';

class WConnectView extends StatefulWidget {
  const WConnectView({Key? key}) : super(key: key);

  @override
  _WCViewState createState() => _WCViewState();
}

class _WCViewState extends State<WConnectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'r101348'.coreTranslationWord(),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: Align(
        alignment: Alignment.centerRight,
        child: Container(
          height: GlobalVariables.gHeight / 2.8,
          width: GlobalVariables.gWidth - 50,
          decoration: BoxDecoration(
            color: Colors.black, //CoreColor.appGreen().,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: GlobalVariables.gWidth - 80,
                child: MaterialButton(
                  color: CoreColor().grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {},
                  child: Text(
                    'r101096'.coreTranslationWord(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: GlobalVariables.gWidth - 80,
                child: MaterialButton(
                  color: CoreColor().grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {},
                  child: Text(
                    'r101097'.coreTranslationWord(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: MaterialButton(
                      color: CoreColor().appGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      onPressed: () {
                        setState(() {
                          Get.to(() => const WConnectView());
                        });
                      },
                      // child: const Text(
                      //   "tesda",
                      //   textAlign: TextAlign.center,
                      // ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        // setState(() {

                        // });
                        // super.dispose();
                      },
                      color: CoreColor().appGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text('r101100'.coreTranslationWord()),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
