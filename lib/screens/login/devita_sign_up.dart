import 'package:devita/controller/signup_controller.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devita/helpers/gextensions.dart';

class DevitaSignup extends StatefulWidget {
  const DevitaSignup({
    Key? key,
  }) : super(key: key);

  @override
  _DevitaSignupState createState() => _DevitaSignupState();
}

class _DevitaSignupState extends State<DevitaSignup> {
  bool hidePassword = true;

  final SignUpController _signUpController = Get.put(SignUpController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                width: GlobalVariables.gWidth,
                height: GlobalVariables.gHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: loginScreen(),
              ),
            ],
          ),
        ));
  }

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  Widget loginScreen() {
    return Form(
      key: _form,
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 10),
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
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                'r101056'.coreTranslationWord(),
                style: context.textTheme.headline2,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: GlobalVariables.gWidth - 50,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('r101039'.coreTranslationWord(),
                        style: context.textTheme.bodyText1),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) return 'r101057'.coreTranslationWord();
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val);
                      if (!emailValid) {
                        return 'The email format is incorrect!!!';
                      }
                      return null;
                    },
                    controller: _signUpController.emailTextController,
                    // keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: CoreColor().appGreen,
                      ),
                      hintText: "r101039".coreTranslationWord(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: GlobalVariables.gWidth - 50,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('r101061'.coreTranslationWord(),
                        style: context.textTheme.bodyText1),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty) return 'r101057'.coreTranslationWord();
                      return null;
                    },
                    controller: _signUpController.phoneTextController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: CoreColor().appGreen,
                      ),
                      hintText: "r101061".coreTranslationWord(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: GlobalVariables.gWidth - 50,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('r101058'.coreTranslationWord() + "",
                        style: context.textTheme.bodyText1),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _signUpController.passwordTextController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    validator: (val) {
                      if (val!.isEmpty) return 'r101057'.coreTranslationWord();
                      bool passwordValid = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                          .hasMatch(val);
                      if (!passwordValid) {
                        return '''
Password must be at least 8 characters,
include an uppercase letter, number and symbol.   ''';
                      }
                      return null;
                    },
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      hintText: "******",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: CoreColor().appGreen,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        color: Colors.pink,
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: CoreColor().appGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: GlobalVariables.gWidth - 50,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('r101059'.coreTranslationWord(),
                        style: context.textTheme.bodyText1),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _signUpController.repeatPassTextController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    obscureText: hidePassword,
                    validator: (val) {
                      if (val!.isEmpty) return 'r101057'.coreTranslationWord();

                      if (val !=
                          _signUpController.passwordTextController!.text) {
                        return 'r101060'.coreTranslationWord();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "******",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: CoreColor().appGreen,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        color: Colors.pink,
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: CoreColor().appGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: GlobalVariables.gWidth - 50,
              child: MaterialButton(
                color: CoreColor().appGreen,
                child: Text(
                  'r101056'.coreTranslationWord(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
                onPressed: () {
                  setState(() {
                    if (_form.currentState?.validate() == true) {
                      _signUpController.signUp(context);
                    }
                    // Navigator.of(context).push(
                    //   ChangeView.routeView(
                    //     OTPVerification(),
                    //   ),
                    // );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
