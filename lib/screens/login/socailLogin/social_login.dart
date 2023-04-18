import 'dart:async';
import 'dart:convert';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/login/socailLogin/user_information.dart';
import 'package:devita/screens/main_tab.dart';
import 'package:devita/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';

class SocialLogin extends StatefulWidget {
  final String loginType;
  const SocialLogin({
    Key? key,
    required this.loginType,
  }) : super(key: key);

  @override
  SocialLoginState createState() => SocialLoginState();
}

class SocialLoginState extends State<SocialLogin> {
  String googleAuthUri = '';
  String clientId = '';
  String redirectUri = '';
  String googleAuthScope = '';
  String state = '';
  String responseType = '';
  String initialUrl = '';
  String deepLinkURL = "";
  StreamSubscription? sub;
  var type = false.obs;

  @override
  void initState() {
    setState(() {
      getProviders();
    });
    super.initState();
    _handleIncomingLinks();
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

  getProviders() {
    var bodyData = {};
    Services()
        .postRequest(
            json.encode(bodyData), '${CoreUrl.authService}providers', false)
        .then((data) {
      var response = json.decode(data.body);

      var contain = response['result']['items']
          .where((element) => element['name'] == widget.loginType);
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

//state base64 bolgono
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(),

      // appBar: AppBar(),

      // type.value == false
      //     ? Center(
      //         child: CircularProgressIndicator(
      //           color: CoreColor().appGreen,
      //         ),
      //       )
      //     : Builder(builder: (BuildContext context) {
      //         return Stack(
      //           children: <Widget>[
      //             WebView(
      //               initialUrl: initialUrl,
      //               javascriptMode: JavascriptMode.unrestricted,
      //               javascriptChannels: {
      //                 JavascriptChannel(
      //                     name: 'messageHandler',
      //                     onMessageReceived: (JavascriptMessage message) {
      //                       Map<String, dynamic> socialLoginData =
      //                           jsonDecode(json.decode(message.message))
      //                               as Map<String, dynamic>;
      //                       print('social login data end irk ba');
      //                       print(socialLoginData);
      //                       var storage = GetStorage();
      //                       storage.write('token',
      //                           socialLoginData['result']['token'].toString());
      //                       storage.write('userInformation',
      //                           jsonEncode(socialLoginData['result']));
      //                       storage.write(
      //                           'token', socialLoginData['result']['token']);
      //                       storage.write('id',
      //                           socialLoginData['result']['id'].toString());

      //                       GlobalVariables.storageToVar();

      //                       GlobalVariables.checkVerticationLevel(
      //                           GlobalVariables.verficationFlag, 7);
      //                       if (GlobalVariables.verficationFlag == 1) {
      //                         Get.to(
      //                           () => UserInfoSocial(
      //                             firstName: socialLoginData['result']
      //                                 ['first_name'],
      //                             lastName: socialLoginData['result']
      //                                 ['last_name'],
      //                             email: socialLoginData['result']
      //                                 ['email_address_primary'],
      //                             phone: '',
      //                           ),
      //                         );
      //                       } else {
      //                         Get.to(() => const MainTab());
      //                       }
      //                     })
      //               },
      //               userAgent:
      //                   "Mozilla/5.0 (Linux; Android 4.1.1; Galaxy Nexus Build/JRO03C) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19",
      //               onWebViewCreated: (controller) {},
      //               onPageFinished: (url) {
      //                 setState(() {
      //                   _loadedPage = true;
      //                 });
      //               },
      //             ),
      //             _loadedPage == false
      //                 ? Center(
      //                     child: CircularProgressIndicator(
      //                       backgroundColor: CoreColor().appGreen,
      //                     ),
      //                   )
      //                 : Container(),
      //           ],
      //         );
      //       }),
    );
  }
}
