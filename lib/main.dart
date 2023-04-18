import 'package:devita/helpers/gvariables.dart';
import 'package:devita/helpers/language_translation.dart';
import 'package:devita/screens/chat/videoCall/video_chat.dart';
import 'package:devita/screens/splash_screen.dart';
import 'package:devita/style/theme_service.dart';
import 'package:devita/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:devita/helpers/gextensions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(TextTranslations());
  await GetStorage.init();
  var storage = GetStorage();
  GlobalVariables.localeShort = 'en';
  GlobalVariables.localeLong = 'en_US';
  if (storage.read('localeShort') == null) {
    storage.write("localeShort", GlobalVariables.localeShort);
    storage.write("localeLong", GlobalVariables.localeLong);
  } else {
    GlobalVariables.localeShort = storage.read("localeShort");
    GlobalVariables.localeLong = storage.read("localeLong");
  }

  print(GlobalVariables.localeShort);
  await TranslationApi.loadTranslations(GlobalVariables.localeShort);
  await Firebase.initializeApp();

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'devita',
      channelName: 'devita notification',
      channelDescription: "devita notification",
      defaultColor: const Color(0XFF9050DD),
      importance: NotificationImportance.High,
      ledColor: Colors.white,
      channelShowBadge: true,
      playSound: true,
      enableLights: true,
      enableVibration: true,
      defaultRingtoneType: DefaultRingtoneType.Notification,
    ),
  ]);

  late FirebaseMessaging messaging;
  Get.lazyPut<ViewVideoController>(() => ViewVideoController());
  runApp(const Main());

  GlobalVariables.languageCheck(Get.deviceLocale.toString());
  messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
  }
  messaging
      .getToken()
      .then((value) => {GlobalVariables.deviceToken = value.toString()});

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('manlai not: ${message.notification?.title}');
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'devita',
        title: message.notification?.title.toString().coreTranslationWord(),
        body: message.notification?.body.toString().coreTranslationWord(),
        // bigPicture:
        //     'https://protocoderspoint.com/wp-content/uploads/2021/05/Monitize-flutter-app-with-google-admob-min-741x486.png',
        // notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!: $message');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('body note 0: $message');
  });
}

/// [GetMaterialApp] use getx state management
class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///Here locale change in setting

    return GetMaterialApp(
      // translationsKeys:
      //     TextTranslations().keys, //Get.find<TextTranslations>().keys,
      // translations: TextTranslations(), // Get.find<TextTranslations>(),
      // locale: Get.deviceLocale,
      // GlobalVariables.localeShort == 'mn'
      //     ? const Locale('mn', 'MN')
      //     : const Locale('en', 'US'), // Get.deviceLocale,
      // fallbackLocale: const Locale('mn', 'MN'),
      theme: Themes.dark,
      darkTheme: Themes.dark,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeft,
      themeMode: ThemeService().theme,
      home: const SplashScreen(),
    );
  }
}
