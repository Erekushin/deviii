import 'dart:async';
import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:devita/controller/oneid_login_controller.dart';
import 'package:devita/eth_wallet.dart';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/one_id.dart';
import 'package:devita/screens/login/devita_sign_up.dart';
import 'package:devita/controller/login_controller.dart';
import 'package:devita/screens/login/forget_password.dart';
import 'package:devita/screens/login/socailLogin/social_login.dart';
import 'package:devita/screens/login/socailLogin/user_information.dart';
import 'package:devita/screens/main_tab.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:devita/helpers/gextensions.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

/// [LoginPage] login user screen

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  String googleAuthUri = '';
  String clientId = '';
  String redirectUri = '';
  String googleAuthScope = '';
  String state = '';
  String responseType = '';
  String initialUrl = '';
  String deepLinkURL = "";
  StreamSubscription? sub;

  static final LoginController _loginController = Get.put(LoginController());
  static final OneIDLoginController _oneIdLoginController =
      Get.put(OneIDLoginController());
  late double screenSize;
  RxString selectGender = 'SeedPhrade'.obs;
  var oneIdController = TextEditingController();

  @override
  void initState() {
    getDeviceDetails();
    super.initState();
  }

  /// [getDeviceDetails] get user device details
  static Future getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        _loginController.deviceIdTextController?.text = build.androidId;
        _loginController.mobileTypeTextController?.text = 'android';
        GlobalVariables.deviceId = build.androidId;
        GlobalVariables.deviceType = 'android';
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        _loginController.deviceIdTextController?.text =
            data.identifierForVendor;
        _loginController.mobileTypeTextController?.text = 'ios';
        GlobalVariables.deviceId = data.identifierForVendor;
        GlobalVariables.deviceType = 'ios';
      }
    } on PlatformException {
      return null;
    }
  }

  getProviders(loginType) {
    var bodyData = {};
    Services()
        .postRequest(
            json.encode(bodyData), '${CoreUrl.authService}providers', false)
        .then((data) {
      var response = json.decode(data.body);

      var contain = response['result']['items']
          .where((element) => element['name'] == loginType);
      googleAuthUri = contain.first['auth_url'];
      clientId = contain.first['client_id'];
      redirectUri = contain.first['callback'];
      googleAuthScope = contain.first['scope'];
      googleAuthUri = contain.first['auth_url'];

      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      state = stringToBase64.encode(contain.first['name']);
      responseType = contain.first['response_type'];

      setState(() {
        initialUrl =
            '$googleAuthUri?client_id=$clientId&redirect_uri=$redirectUri&scope=$googleAuthScope&response_type=$responseType&state=$state&aqs=chrome.0.69i59l3j69i57j69i59j69i60l3.1180j0j9&sourceid=chrome&ie=UTF-8';

        launch(
          initialUrl,
          universalLinksOnly: false,
          forceSafariVC: true,
        );
      });
    });
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        var socialLoginData = json.decode(Uri.decodeFull(uri!.query));
        print("socialLoginData: $socialLoginData");
        var storage = GetStorage();
        storage.write('token', socialLoginData['result']['token'].toString());
        storage.write('userInformation', jsonEncode(socialLoginData['result']));
        storage.write('token', socialLoginData['result']['token']);
        storage.write('id', socialLoginData['result']['id'].toString());

        GlobalVariables.storageToVar();

        GlobalVariables.checkVerticationLevel(
            GlobalVariables.verficationFlag, 7);
        if (GlobalVariables.verficationFlag == 1) {
          Get.to(
            () => UserInfoSocial(
              firstName: socialLoginData['result']['first_name'],
              lastName: socialLoginData['result']['last_name'],
              email: socialLoginData['result']['email_address_primary'],
              phone: '',
            ),
          );
        } else {
          Get.to(() => const MainTab());
        }
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// [screenSize] get device resolution screen size
    screenSize = GlobalVariables.getScreenHeightExcludeSafeArea(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: GlobalVariables.gHeight,
        width: GlobalVariables.gWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Container(
            //   child: MaterialButton(
            //     child: Text('change mode'),
            //     onPressed: ThemeService().switchTheme,
            //   ),
            // ),
            // Container(
            //   alignment: Alignment.topRight,
            //   child: MaterialButton(
            //       child: Obx(() => Text('${GlobalVariables.language.value}')),
            //       onPressed: () {
            //         setState(() {
            //           showLocaleDialog(context);
            //         });
            //       }),
            // ),
            Positioned.fill(
              top: 80,
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/logo_center_white.png',
                  fit: BoxFit.fitWidth,
                  width: GlobalVariables.gWidth / 2,
                ),
              ),
            ),
            Positioned.fill(
              top: 200,
              child: Center(
                child: SizedBox(
                  width: GlobalVariables.gWidth - 50,
                  child: Column(children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'r101039'.coreTranslationWord(),
                        style: const TextStyle().bodyText1(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _loginController.emailTextController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: CoreColor().appGreen,
                        ),
                        hintText: "r101039".coreTranslationWord(),
                      ),
                    ),
                    screenSize < 814
                        ? const SizedBox(height: 10)
                        : const SizedBox(height: 30),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'r101040'.coreTranslationWord(),
                        style: const TextStyle().bodyText1(),
                      ),
                    ),

                    const SizedBox(height: 10),
                    TextField(
                      controller: _loginController.passwordTextController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
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

                    screenSize < 814
                        ? const SizedBox(height: 15)
                        : const SizedBox(height: 30),
                    SizedBox(
                      width: GlobalVariables.gWidth - 50,
                      child: MaterialButton(
                        color: CoreColor().appGreen,
                        child: Text(
                          'r101034'.coreTranslationWord(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_loginController.emailTextController?.text !=
                                    '' &&
                                _loginController.passwordTextController?.text !=
                                    '') {
                              _loginController.loginUser(context);
                            } else {
                              Get.snackbar(
                                gWarning,
                                gWarningTextField,
                                backgroundColor: Colors.grey,
                                colorText: Colors.black,
                              );
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.black,
                              value: _loginController.rememberMe,
                              onChanged: (val) {
                                setState(() {
                                  _loginController.rememberMe = val!;
                                  print(_loginController.rememberMe);
                                });
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {});
                              },
                              child: Text(
                                'r101051'.coreTranslationWord(),
                                style: TextStyle(
                                  color: CoreColor().appGreen,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Get.to(() => const ForgotPassword());
                            });
                          },
                          child: Text(
                            'r101052'.coreTranslationWord(),
                            style: TextStyle(
                              color: CoreColor().appGreen,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // bottom devider beginning
                    screenSize < 814
                        ? const SizedBox(height: 0)
                        : const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "r101062".coreTranslationWord(),
                          style: context.textTheme.bodyText1,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    MaterialButton(
                      color: CoreColor().appGreen,
                      onPressed: () {
                        setState(() {
                          showOneIdDailog(context);
                        });
                      },
                      child: Text('r101055'.coreTranslationWord()),
                    ),
                    screenSize < 814
                        ? const SizedBox(height: 10)
                        : const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              // Get.to(
                              //   () => const SocialLogin(
                              //       loginType: 'provider_google'),
                              // );
                              getProviders('provider_google');
                              _handleIncomingLinks();
                            });
                          },
                          icon: Image.asset(
                            'assets/icons/google.png',
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              // Get.to(
                              //   () => const SocialLogin(
                              //       loginType: 'provider_facebook'),
                              // );
                              getProviders('provider_facebook');
                              _handleIncomingLinks();
                            });
                          },
                          icon: Image.asset('assets/icons/fb.png'),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              // Get.to(
                              //   () => const SocialLogin(
                              //       loginType: 'naver_provider'),
                              // );
                              getProviders('naver_provider');
                              _handleIncomingLinks();
                            });
                          },
                          icon: Image.asset('assets/icons/nev.png'),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              // Get.to(
                              //   () => const SocialLogin(
                              //       loginType: 'provider_kakao'),
                              // );
                              getProviders('provider_kakao');
                              _handleIncomingLinks();
                            });
                          },
                          icon: Image.asset('assets/icons/talk.png'),
                        )
                      ],
                    ),
                  ]),
                ),
              ),
            ),
            Positioned.fill(
              bottom: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "r101054".coreTranslationWord(),
                      style: context.textTheme.bodyText1,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          Get.to(() => const DevitaSignup());
                        });
                      },
                      child: Text(
                        'r101053'.coreTranslationWord(),
                        style: TextStyle(
                          color: CoreColor().appGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
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
              onTap: () => GlobalVariables.changeLanguage(
                  GlobalVariables.locales[index]['locale']),
            ),
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black,
            ),
            itemCount: GlobalVariables.locales.length,
          ),
        ),
      ),
    );
  }

  /// change language dialog
  showOneIdDailog(BuildContext context) {
    selectGender.value = 'SeedPhrade';
    oneIdController.text = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Center(
          child: Column(
            children: [
              Text(
                'r101299'.coreTranslationWord(),
                style: TextStyle(
                  color: CoreColor().appGreen,
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
            ],
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Text(
                        'r101344'.coreTranslationWord(),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      leading: Obx(() => Radio(
                            value: "SeedPhrade",
                            groupValue: selectGender.value,
                            activeColor: CoreColor().appGreen,
                            onChanged: (String? value) {
                              setState(() {
                                oneIdController.text = '';
                                selectGender.value = value!;
                              });
                            },
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Text(
                        'r101345'.coreTranslationWord(),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      leading: Obx(() => Radio(
                            value: "PrivateKey",
                            groupValue: selectGender.value,
                            activeColor: CoreColor().appGreen,
                            onChanged: (String? value) {
                              setState(() {
                                oneIdController.text = '';
                                selectGender.value = value!;
                              });
                            },
                          )),
                    ),
                  ),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                controller: oneIdController,
              ),
              const SizedBox(height: 20),
              MaterialButton(
                onPressed: () async {
                  var storage = GetStorage();
                  if (selectGender.value == 'SeedPhrade') {
                    if (await AddressService()
                        .importFromMnemonic(oneIdController.text)) {
                      _oneIdLoginController.oneIdTextController?.text =
                          storage.read('getAddress');
                      _oneIdLoginController.getTimeLocation(context);
                      return;
                    } else {
                      Get.snackbar(
                        gWarning,
                        'Invalid mnemonic, please try again.',
                        colorText: Colors.white,
                      );
                    }
                  } else {
                    // AddressService().getPublicAddress(oneIdController.text);
                    print(oneIdController.text.length);
                    if (oneIdController.text.length == 64) {
                      final address = await AddressService()
                          .getPublicAddress(oneIdController.text);
                      _oneIdLoginController.oneIdTextController?.text =
                          address.toString();
                      _oneIdLoginController.getTimeLocation(context);
                    } else {
                      Get.snackbar(
                        gWarning,
                        'Private key error',
                        colorText: Colors.white,
                      );
                    }
                  }
                },
                child: Text(
                  'r101346'.coreTranslationWord(),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 0),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EthWalletConnect(type: true),
                        ),
                      );
                    });
                  },
                  child: Text(
                    'r101347'.coreTranslationWord(),
                    style: TextStyle(
                      color: CoreColor().appGreen,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
