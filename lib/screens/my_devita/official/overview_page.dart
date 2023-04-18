import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  XFile? imageSend;
  final ImagePicker _picker = ImagePicker();

  var categoryList = [
    "Diagnoses",
    "Test Result",
    "Medical Image Records",
    "Health Checkup Records",
    "Surgery History",
  ];
  var department = ['1-р Эмнэлэг', 'Сонгдо', '3-р Эмнэлэг', 'Эх нялхас'];
  final myTitle = TextEditingController();

  String titleValue = '';
  String startTimeValue = '';
  String endTimeValue = '';
  String locationValue = '';
  RxBool illness = false.obs;
  RxBool injury = false.obs;
  String instutionValue = '';

  String categoryValue = '';
  String noteValue = '';

  @override
  void initState() {
    super.initState();
  }

  getView() {
    var bodyData = {"id": 7};
    print("blabla: $bodyData");
    Services()
        .postRequest(json.encode(bodyData),
            "${CoreUrl.baseUrl}metadata/offical/get", true)
        .then((data) {
      var res = json.decode(data.body);
      print(res);
      setState(() {
        titleValue = res['result']['items'][0]['sval'];
        var storage = GetStorage();
        storage.write('viewValue', res['result']['items'][0]['sval']);
      });
    });
  }

  setView() {
    var bodyData = {
      "title": titleValue,
      "type": categoryValue,
      "start_time": startTimeValue,
      "end_time": endTimeValue,
      "is_illness": illness.value == true ? 1 : 0,
      "is_injury": injury.value == true ? 1 : 0,
      "location": locationValue,
      "instution": instutionValue,
      "note": noteValue,
      "img": ""
    };
    print("body: $bodyData");
    Services()
        .postRequest(json.encode(bodyData),
            "${CoreUrl.baseUrl}metadata/offical/insert", true)
        .then(
      (data) {
        var response = json.decode(data.body);
        print('orgil $response');
        if (response['code'] == 200) {
          modal();
        } else {
          Get.back();
          Get.snackbar(
            gWarning,
            'Error',
            colorText: Colors.black,
          );
        }
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
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGalleryProfile();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
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
          // print(res['result']);
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

  int selectedOption = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///[resizeToAvoidBottomInset] keyboard open input push
      resizeToAvoidBottomInset: true,
      backgroundColor: CoreColor().backgroundNew,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: CoreColor().backgroundContainer,
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_sharp,
              size: 30,
              color: CoreColor().appGreen,
            ),
          ),
          leadingWidth: 80,
          titleSpacing: 0.0,
          title: Text(
            'r101328'.coreTranslationWord(),
          ),
          elevation: 0,
          centerTitle: true,
          actions: const [],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            imageUpload(),
            const SizedBox(height: 20),
            formUpload(),
            const SizedBox(height: 20),
            saveClick(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget imageUpload() {
    return Row(
      children: <Widget>[
        const SizedBox(height: 10),
        GlobalVariables.profileImage == ''
            ? Container(
                margin: const EdgeInsets.only(left: 10, top: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: CoreColor().backgroundContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
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
              )
            : InkWell(
                onTap: () {
                  setState(() {
                    print('ene zurag daragd');
                    _showPickerProfile(context);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20, top: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: CoreColor().backgroundContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: SizedBox(
                    width: 130,
                    height: 130,
                    child: CachedNetworkImage(
                      imageUrl: GlobalVariables.socailImg == true
                          ? CoreUrl.imageUrl + GlobalVariables.profileImage
                          : CoreUrl.imageUrl + GlobalVariables.profileImage,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                )),
        const SizedBox(width: 15),
        Column(
          children: [
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.only(right: 25),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showPickerProfile(context);
                  });
                },
                child: Text(
                  'r101329'.coreTranslationWord(),
                  style: TextStyle(
                    color: CoreColor().appGreen,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget formUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.only(
            left: 15,
          ),
          child: Text(
            'r101241'.coreTranslationWord(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                titleValue = value;
              });
            },
            controller: myTitle,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide:
                    BorderSide(color: CoreColor().backgroundNew, width: 1.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide:
                    BorderSide(color: CoreColor().backgroundNew, width: 1.0),
              ),
              fillColor: CoreColor().backgroundContainer,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.only(
            left: 15,
          ),
          child: Text(
            'r101283'.coreTranslationWord(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.only(
            right: 25,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                padding: const EdgeInsets.only(
                  left: 15,
                ),
                width: (GlobalVariables.gWidth - 50) / 3,
                child: TextFormField(
                  onChanged: (val) {
                    startTimeValue = val;
                  },
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(
                          color: CoreColor().backgroundNew, width: 1.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(
                          color: CoreColor().backgroundNew, width: 1.0),
                    ),
                    fillColor: CoreColor().backgroundContainer,
                    border: const OutlineInputBorder(),
                    hintText: '10:00',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                width: 50,
                child: const Text(
                  ' ~ ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                width: (GlobalVariables.gWidth - 50) / 3,
                child: TextFormField(
                  onChanged: (val) {
                    endTimeValue = val;
                  },
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(
                          color: CoreColor().backgroundNew, width: 1.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(
                          color: CoreColor().backgroundNew, width: 1.0),
                    ),
                    fillColor: CoreColor().backgroundContainer,
                    border: const OutlineInputBorder(),
                    hintText: '10:30',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.only(
            left: 15,
          ),
          child: Text(
            'r101330'.coreTranslationWord(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          child: DropdownButtonFormField(
            iconEnabledColor: CoreColor().appGreen,
            iconDisabledColor: CoreColor().appGreen,
            decoration: InputDecoration(
              fillColor: CoreColor().backgroundContainer,
              hintText: "",
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: CoreColor().grey, width: 1.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: CoreColor().grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: CoreColor().grey, width: 1.0),
              ),
            ),
            isExpanded: true,
            hint: const Text(''),
            items: categoryList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              categoryValue = value.toString();
            },
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            children: [
              Text(
                'r101331'.coreTranslationWord(),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                " / ",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'r101332'.coreTranslationWord(),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 25),
          child: Obx(
            () => Row(
              children: <Widget>[
                Checkbox(
                  value: illness.value,
                  onChanged: (val) {
                    setState(() {
                      illness.value = true;
                      injury.value = false;
                    });
                  },
                ),
                Checkbox(
                  value: injury.value,
                  onChanged: (value) {
                    setState(() {
                      injury.value = true;
                      illness.value = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.only(
            left: 15,
          ),
          child: Text(
            'r101192'.coreTranslationWord(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          child: TextFormField(
            onChanged: (val) {
              locationValue = val;
            },
            keyboardType: TextInputType.streetAddress,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide:
                    BorderSide(color: CoreColor().backgroundNew, width: 1.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide:
                    BorderSide(color: CoreColor().backgroundNew, width: 1.0),
              ),
              fillColor: CoreColor().backgroundContainer,
              border: const OutlineInputBorder(),
              hintText: 'Mongolia, Ulaanbaatar',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.only(
            left: 15,
          ),
          child: Text(
            'r101333'.coreTranslationWord(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          child: TextFormField(
            onChanged: (val) {
              instutionValue = val;
            },
            keyboardType: TextInputType.streetAddress,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide:
                    BorderSide(color: CoreColor().backgroundNew, width: 1.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide:
                    BorderSide(color: CoreColor().backgroundNew, width: 1.0),
              ),
              fillColor: CoreColor().backgroundContainer,
              border: const OutlineInputBorder(),
              hintText: 'Songdo hospital',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          child: const Text(
            'If there is no result on your search, please input the name of official institution yourself',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.only(
            left: 15,
          ),
          child: Text(
            'r101245'.coreTranslationWord(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                noteValue = value;
              });
            },
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            maxLength: 500,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide:
                    BorderSide(color: CoreColor().backgroundNew, width: 1.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide:
                    BorderSide(color: CoreColor().backgroundNew, width: 1.0),
              ),
              fillColor: CoreColor().backgroundContainer,
              focusColor: CoreColor().appGreen,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CoreColor().appGreen,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  // filter() {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: CoreColor().backgroundContainer,
  //         scrollable: true,
  //         shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(15.0))),
  //         title: Column(
  //           children: <Widget>[
  //             Container(
  //               padding: const EdgeInsets.only(
  //                 left: 1,
  //               ),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: const <Widget>[
  //                   Icon(
  //                     Icons.warning_amber,
  //                     size: 55,
  //                   ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Text(
  //                     "The data you are about to record is stored on   blockchain, therefore it can not be     edited or permanently deleted.After saving your data, you can only update it in the future. Would you like to proceed?",
  //                     style: TextStyle(
  //                         color: Colors.white70,
  //                         fontSize: 15,
  //                         fontStyle: FontStyle.normal),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             Container(
  //               padding: const EdgeInsets.only(
  //                 left: 10,
  //               ),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   SizedBox(
  //                     width: 320,
  //                     height: 50,
  //                     child: ElevatedButton(
  //                       style: ButtonStyle(
  //                         shape:
  //                             MaterialStateProperty.all<RoundedRectangleBorder>(
  //                           RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(25.0),
  //                             side: BorderSide(
  //                               color: CoreColor().appGreen,
  //                               width: 2.0,
  //                             ),
  //                           ),
  //                         ),
  //                         backgroundColor: MaterialStateProperty.all(
  //                           CoreColor().appGreen,
  //                         ),
  //                         textStyle: MaterialStateProperty.all(
  //                           const TextStyle(fontSize: 17),
  //                         ),
  //                       ),
  //                       child: const Text(
  //                         'Yes, save my data',
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       onPressed: () {
  //                         setState(() {
  //                           setView();
  //                         });
  //                       },
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                   SizedBox(
  //                     width: 320,
  //                     height: 50,
  //                     child: ElevatedButton(
  //                       style: ButtonStyle(
  //                         shape:
  //                             MaterialStateProperty.all<RoundedRectangleBorder>(
  //                           RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(25.0),
  //                             side: BorderSide(
  //                               color:
  //                                   CoreColor().backgroundNew.withOpacity(0.5),
  //                               width: 2.0,
  //                             ),
  //                           ),
  //                         ),
  //                         backgroundColor: MaterialStateProperty.all(
  //                           CoreColor().backgroundNew.withOpacity(0.9),
  //                         ),
  //                         textStyle: MaterialStateProperty.all(
  //                           const TextStyle(fontSize: 15),
  //                         ),
  //                       ),
  //                       child: const Text(
  //                         'Back to overview',
  //                         style: TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       onPressed: () {
  //                         Get.back();
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget saveClick() {
    return SizedBox(
      width: GlobalVariables.gWidth - 150,
      child: MaterialButton(
        color: CoreColor().appGreen,
        child: Text(
          'r101035'.coreTranslationWord(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1,
        ),
        onPressed: () {
          setState(() {
            // filter();
            setView();
          });
        },
      ),
    );
  }

  modal() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CoreColor().backgroundContainer,
          scrollable: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Column(
            children: [
              Image.asset(
                'assets/images/logo_no_word.png',
                height: 65,
              ),
              const SizedBox(height: 20),
              Text(
                'r101256'.coreTranslationWord(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: CoreColor().appGreen,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: GlobalVariables.gWidth - 80,
                child: MaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  color: CoreColor().backgroundNew,
                  child: Text(
                    'r101140'.coreTranslationWord(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  onPressed: () {
                    setState(() {
                      Get.back();
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
