import 'dart:convert';
import 'dart:math';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/screens/my_devita/daily_inputs/blood_screen.dart';
import 'package:devita/screens/my_devita/daily_inputs/body_temp.dart';
import 'package:devita/screens/my_devita/daily_inputs/heart_screan.dart';
import 'package:devita/screens/my_devita/daily_inputs/steps_screen.dart';
import 'package:devita/screens/my_devita/daily_inputs/water_screen.dart';
import 'package:devita/screens/my_devita/official/official_page.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
// import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:radar_chart/radar_chart.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  XFile? imageSend;
  final ImagePicker _picker = ImagePicker();
  String totalWeight = '';
  String totalHeight = '';

  // static const ticks = [1, 2, 3, 4, 6];
  var features = [
    'r101249'.coreTranslationWord().toString(),
    'r101272'.coreTranslationWord().toString(),
    'r101260'.coreTranslationWord().toString(),
    'r101260'.coreTranslationWord().toString(),
    'r101260'.coreTranslationWord().toString(),
  ];
  // var data = [
  //   [6, 6, 6, 6, 6],
  // ];

  @override
  void initState() {
    var storage = GetStorage();
    if (storage.read('totalWeigth') != null) {
      totalWeight = storage.read('totalWeigth').toString();
    }
    if (storage.read('totalHeigth') != null) {
      totalHeight = storage.read('totalHeigth').toString().substring(0, 3);
    }
    if (storage.read('bloodValue') != null) {
      GlobalVariables.bloodValue.value = storage.read('bloodValue').toString();
    }
    if (storage.read('bloodValue') == null) {
      dailyData();
    }

    super.initState();
  }

  dailyData() {
    var bodyData = {};

    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.baseUrl}metadata/daily/profile', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        setState(() {
          var storage = GetStorage();

          for (var element in response['result']['items']) {
            print(element);
            if (element['type_name'] == "height") {
              totalHeight = element['fval'].toString();
              storage.write('totalHeigth', element['fval'].toString());
            } else if (element['type_name'] == "weight") {
              totalWeight = element['fval'].toString();
              storage.write('totalWeigth', element['fval'].toString());
            } else if (element['type_name'] == "blood_type") {
              print('lol');
              print(element['sval'].toString());
              GlobalVariables.bloodValue.value = element['sval'].toString();
              storage.write('bloodValue', element['sval'].toString());
            }
          }
        });
      },
    );
  }

  _imgFromCameraProfile() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    setState(() {
      imageSend = image;
      if (imageSend?.path != null) {
        uploadProfile(imageSend?.path);
      }
    });
  }

  _imgFromGalleryProfile() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    setState(() {
      imageSend = image;
      if (imageSend?.path != null) {
        uploadProfile(imageSend?.path);
      }
    });
  }

  void _showPickerProfile(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text(
                      'r101335'.coreTranslationWord(),
                    ),
                    onTap: () {
                      _imgFromGalleryProfile();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(
                    'r101336'.coreTranslationWord(),
                  ),
                  onTap: () {
                    _imgFromCameraProfile();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  uploadProfile(path) {
    Services()
        .uploadImage(path, "${CoreUrl.authService}user/profile/upload/img",
            true, "PROFILE")
        .then((data) {
      var res = json.decode(data);
      if (res['code'] == 200) {
        Get.snackbar(
          gWarning,
          res['message_code'].toString().coreTranslationWord(),
          colorText: Colors.white,
        );
        setState(() {
          GlobalVariables.socailImg = false;
          GlobalVariables.profileImage = res['result']['name'];
        });

        Get.back();
      } else {
        Get.back();
        Get.snackbar(
          gWarning,
          data['message_code'].toString().coreTranslationWord(),
          colorText: Colors.white,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          header(),
          const SizedBox(height: 20),
          typeSection(),
          const SizedBox(height: 20),
          graph(),
          const SizedBox(height: 20),
          listBottom(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget header() {
    return Row(
      children: [
        GlobalVariables.profileImage == ''
            ? SizedBox(
                width: 150,
                child: ClipPolygon(
                  sides: 6,
                  borderRadius: 8.0,
                  rotate: 60.0,
                  boxShadows: const [],
                  child: Container(
                    color: Colors.grey.withOpacity(0.4),
                    child: IconButton(
                      alignment: Alignment.center,
                      onPressed: () {
                        setState(() {
                          _showPickerProfile(context);
                        });
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 35,
                      ),
                    ),
                  ),
                ),
              )
            : InkWell(
                onTap: () {
                  setState(() {
                    print('ene zurag daragd');
                    _showPickerProfile(context);
                  });
                },
                child: SizedBox(
                  width: 150,
                  child: Center(
                    child: Stack(
                      children: [
                        ClipPolygon(
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
                        Positioned(
                          bottom: 5,
                          right: 10,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50.0)),
                              color: CoreColor().appGreen,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              GlobalVariables.firstName.capitalizeCustom() +
                  ' ' +
                  GlobalVariables.lastName.capitalizeCustom(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              '0 LIFE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: CoreColor().appGreen,
              height: 2,
              width: GlobalVariables.gWidth * 0.5,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'r101107'.coreTranslationWord(),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 50),
                SizedBox(
                  width: 20,
                  child: ClipPolygon(
                    sides: 6,
                    borderRadius: 8.0,
                    rotate: 60.0,
                    boxShadows: [
                      PolygonBoxShadow(
                          color: Colors.transparent, elevation: 1.0)
                    ],
                    child: Container(
                      color: Colors.yellow[900],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                  child: ClipPolygon(
                    sides: 6,
                    borderRadius: 8.0,
                    rotate: 60.0,
                    boxShadows: [
                      PolygonBoxShadow(
                          color: Colors.transparent, elevation: 1.0)
                    ],
                    child: Container(
                      color: Colors.yellow[900],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                  child: ClipPolygon(
                    sides: 6,
                    borderRadius: 8.0,
                    rotate: 60.0,
                    boxShadows: [
                      PolygonBoxShadow(
                          color: Colors.transparent, elevation: 1.0)
                    ],
                    child: Container(
                      color: Colors.yellow[900],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                  child: ClipPolygon(
                    sides: 6,
                    borderRadius: 8.0,
                    rotate: 60.0,
                    boxShadows: [
                      PolygonBoxShadow(
                          color: Colors.transparent, elevation: 1.0)
                    ],
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                  child: ClipPolygon(
                    sides: 6,
                    borderRadius: 8.0,
                    rotate: 60.0,
                    boxShadows: [
                      PolygonBoxShadow(
                          color: Colors.transparent, elevation: 1.0)
                    ],
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget typeSection() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            width: (GlobalVariables.gWidth - 40) / 3,
            height: 80,
            decoration: BoxDecoration(
                color: CoreColor().grey,
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bloodtype),
                    Text(
                      'r101108'.coreTranslationWord(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Text(
                    GlobalVariables.bloodValue.value,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(7),
            width: (GlobalVariables.gWidth - 40) / 3,
            height: 80,
            decoration: BoxDecoration(
                color: CoreColor().grey,
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(Icons.height),
                    Text(
                      'r101109'.coreTranslationWord(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      totalHeight,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'r101268'.coreTranslationWord(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(7),
            width: (GlobalVariables.gWidth - 40) / 3,
            height: 80,
            decoration: BoxDecoration(
                color: CoreColor().grey,
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bloodtype),
                    Text(
                      'r101110'.coreTranslationWord(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      totalWeight,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'r101267'.coreTranslationWord(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  indexBack(sum, input) {
    if (input > 0) {
      print(sum);
      print(input);
      var test = (input * 100) / sum;
      print(test);
      if (100 < test) {
        return 1;
      } else if (100 > test || 80 < test) {
        return 1;
      } else if (80 > test || 60 < test) {
        return 2;
      } else if (60 > test || 40 < test) {
        return 3;
      } else if (40 > test || 20 < test) {
        return 4;
      } else if (20 > test || 0 < test) {
        return 5;
      }
    } else {
      return 5;
    }
  }

  bool useSides = false;
  List<double> values1 = [0, 0, 0, 0, 0, 0];

  Widget graph() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: GlobalVariables.gWidth,
      height: 270,
      decoration: BoxDecoration(
        color: CoreColor().grey,
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: Center(
        child: RadarChart(
          length: 6,
          radius: 100,
          initialAngle: 1.07,
          backgroundColor: CoreColor().backgroundContainer,
          borderStroke: 1,
          borderColor: Colors.grey.withOpacity(0.5),
          radialStroke: 1,
          radialColor: Colors.grey.withOpacity(0.5),
          vertices: [
            for (int i = 0; i < 6; i++)
              RadarVertex(
                radius: 1,
                number: i,
              ),
          ],
          radars: [
            RadarTile(
              radialColor: Colors.transparent,
              values: values1,
              borderStroke: 2,
              borderColor: Colors.transparent,
              backgroundColor: CoreColor().appGreen.withOpacity(0.7),
            ),
          ],
        ),
      ),

      /// old radart chart
      // RadarChart.dark(
      //   ticks: ticks,
      //   features: features,
      //   data: data,
      //   reverseAxis: true,
      //   useSides: true,
      // ),
    );
  }

  Widget listBottom() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => const StepsScreen());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: (GlobalVariables.gWidth - 40) / 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CoreColor().grey,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'r101249'.coreTranslationWord(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const WaterScreen());
                },
                child: Container(
                  width: (GlobalVariables.gWidth - 40) / 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CoreColor().grey,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'r101260'.coreTranslationWord(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const HeartScreen());
                },
                child: Container(
                  width: (GlobalVariables.gWidth - 40) / 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CoreColor().grey,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'r101272'.coreTranslationWord(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => const BloodPage());
                },
                child: Container(
                  width: (GlobalVariables.gWidth - 40) / 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CoreColor().grey,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'r101116'.coreTranslationWord(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const BodytempScreen());
                },
                child: Container(
                  width: (GlobalVariables.gWidth - 40) / 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CoreColor().grey,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'r101338'.coreTranslationWord(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const OfficialPage());
                },
                child: Container(
                  width: (GlobalVariables.gWidth - 40) / 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CoreColor().grey,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'r101341'.coreTranslationWord(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RadarVertex extends StatelessWidget with PreferredSizeWidget {
  RadarVertex({
    Key? key,
    required this.radius,
    required this.number,
  }) : super(key: key);

  final double radius;
  final int number;

  @override
  Size get preferredSize => const Size.fromRadius(20);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: number == 0
          ? Container(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'r101260'.coreTranslationWord(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            )
          : number == 1
              ? Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: 50,
                  child: Text(
                    'r101110'.coreTranslationWord(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                )
              : number == 2
                  ? Container(
                      width: 50,
                      margin: const EdgeInsets.only(right: 10),
                      child: Text(
                        'r101373'.coreTranslationWord(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : number == 3
                      ? Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            'r101249'.coreTranslationWord(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : number == 4
                          ? Container(
                              width: 50,
                              margin: const EdgeInsets.only(left: 20),
                              child: Text(
                                'r101114'.coreTranslationWord(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : Container(
                              width: 50,
                              margin: const EdgeInsets.only(left: 20),
                              child: Text(
                                'r101372'.coreTranslationWord(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
    );
  }
}
