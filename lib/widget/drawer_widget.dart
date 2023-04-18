import 'package:cached_network_image/cached_network_image.dart';
import 'package:devita/controller/login_controller.dart';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/screens/login/login_page.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  static final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: CoreColor().grey),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
          bottomLeft: Radius.circular(40.0),
        ),
        child: Drawer(
          elevation: 1.0,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                GlobalVariables.profileImage == ''
                    ? SizedBox(
                        width: 150,
                        child: ClipPolygon(
                          sides: 6,
                          borderRadius: 8.0,
                          rotate: 60.0,
                          child: Container(
                            color: CoreColor().appGreen,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 150,
                        child: ClipPolygon(
                          sides: 6,
                          borderRadius: 8.0,
                          rotate: 60.0,
                          boxShadows: const [],
                          child: CachedNetworkImage(
                            imageUrl: GlobalVariables.socailImg == false
                                ? CoreUrl.imageUrl +
                                    GlobalVariables.profileImage
                                : CoreUrl.imageUrl +
                                    GlobalVariables.profileImage,

                            ///social login zurag solihod nohtsol true bgag false blghgui bga
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                const SizedBox(height: 10),
                Text(
                  GlobalVariables.firstName.capitalizeCustom() +
                      ' ' +
                      GlobalVariables.lastName.capitalizeCustom(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const Text(
                  '5,415 LIFE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.black12,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'r101102'.coreTranslationWord(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 20),
                          Expanded(
                            child: MaterialButton(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(color: Colors.red),
                              ),
                              onPressed: () {
                                setState(() {});
                              },
                              child: Text(
                                'r101036'.coreTranslationWord(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Expanded(
                          //   child: MaterialButton(
                          //     onPressed: () {
                          //       setState(() {});
                          //     },
                          //     color: Colors.green,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8.0),
                          //       side: const BorderSide(color: Colors.green),
                          //     ),
                          //     child: Text('r101103'.coreTranslationWord()),
                          //   ),
                          // ),
                          const SizedBox(width: 20),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      'r101102'.coreTranslationWord(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                const Divider(color: Colors.grey),
                InkWell(
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      'r101084'.coreTranslationWord(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                const Divider(color: Colors.grey),
                InkWell(
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      'r101104'.coreTranslationWord(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                const Divider(color: Colors.grey),
                InkWell(
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      'r101105'.coreTranslationWord(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                const Divider(color: Colors.grey),
                InkWell(
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      'r101106'.coreTranslationWord(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      final storage = GetStorage();
                      // storage.erase();
                      storage.remove("userInformation");
                      storage.remove("token");
                      storage.remove("id");
                      storage.remove("localeshort");
                      if (storage.read('rememberMe') != null) {
                        setState(() {
                          _loginController.emailTextController?.text =
                              storage.read('rememberMe');
                          _loginController.rememberMe = true;
                        });
                      }
                      Get.to(() => const LoginPage());
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
