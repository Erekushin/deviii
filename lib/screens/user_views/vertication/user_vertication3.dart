import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/login/login_page.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class UserVerification3 extends StatefulWidget {
  const UserVerification3({Key? key}) : super(key: key);

  @override
  _UserVerification3State createState() => _UserVerification3State();
}

class _UserVerification3State extends State<UserVerification3> {
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: GlobalVariables.gWidth,
        height: GlobalVariables.gHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/background.png",
            ),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: screen(),
        ),
      ),
    );
  }

  Widget screen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              iconSize: 30,
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'r101352'.coreTranslationWord(),
            style: context.textTheme.headline2,
          ),
          const SizedBox(height: 20),
          Text(
            'r101353'.coreTranslationWord(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(
            color: Colors.grey,
            height: 2.0,
          ),
          const SizedBox(height: 20),
          userDetail()
        ],
      ),
    );
  }

  Widget userDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'r101354'.coreTranslationWord(),
          style: const TextStyle(
            fontWeight: FontWeight.w200,
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField(
          isExpanded: true,
          hint: const Text(
            "Ulaanbaatar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          items:
              <String>['Ulaanbaatar', 'Darkhan', 'Erdenet'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_) {},
        ),
        const SizedBox(height: 10),
        Text(
          'r101355'.coreTranslationWord(),
          style: const TextStyle(
            fontWeight: FontWeight.w200,
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 10),
        const TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Orgil Stadion",
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'r101360'.coreTranslationWord(),
          style: const TextStyle(
            fontWeight: FontWeight.w200,
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 10),
        const TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Building 48, Apartment 14",
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: GlobalVariables.gWidth,
          child: MaterialButton(
            color: CoreColor().appGreen,
            child: Text(
              'r101361'.coreTranslationWord(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            onPressed: () {
              setState(() {
                Get.to(() => const LoginPage());
              });
            },
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'r101362'.coreTranslationWord(),
              style: TextStyle(
                color: CoreColor().appGreen,
                fontSize: 16,
              ),
            ),
          ),
        )
      ],
    );
  }
}
