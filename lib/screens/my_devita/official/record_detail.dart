import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/global_words.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class RecordDetailPage extends StatefulWidget {
  final int detailValue;
  const RecordDetailPage({
    Key? key,
    required this.detailValue,
  }) : super(key: key);

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  var titleController = TextEditingController();
  var startTimeController = TextEditingController();
  var endTimeController = TextEditingController();
  var locationController = TextEditingController();
  RxBool illness = false.obs;
  RxBool injury = false.obs;
  var instutionController = TextEditingController();
  var categoryController = TextEditingController();
  var noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getView();
  }

  getView() {
    var bodyData = {
      "id": widget.detailValue,
    };
    print("blabla: $bodyData");
    Services()
        .postRequest(json.encode(bodyData),
            "${CoreUrl.baseUrl}metadata/offical/get", true)
        .then((data) {
      var res = json.decode(data.body);
      print("one detail: $res");

      setState(() {
        titleController.text = res['result']['items']['title'];
        startTimeController.text = res['result']['items']['start_time'];
        endTimeController.text = res['result']['items']['end_time'];
        illness.value =
            res['result']['items']['is_illness'] == 1 ? true : false;
        injury.value = res['result']['items']['is_injury'] == 1 ? true : false;
        locationController.text = res['result']['items']['location'];
        instutionController.text = res['result']['items']['instution'];
        noteController.text = res['result']['items']['note'];
        categoryController.text = res['result']['items']['type'];

        ///img nemne
      });
    });
  }

  int selectedOption = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              'r101322'.coreTranslationWord(),
            ),
            elevation: 0,
            centerTitle: true,
            actions: const [],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              formUpload(),
            ],
          ),
        ),
      ),
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
            controller: titleController,
            readOnly: true,
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
                width: (GlobalVariables.gWidth - 40) / 3,
                child: TextFormField(
                  controller: startTimeController,
                  readOnly: true,
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
                width: 90,
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
                width: (GlobalVariables.gWidth - 40) / 3,
                child: TextFormField(
                  controller: endTimeController,
                  readOnly: true,
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
          child: TextFormField(
            controller: categoryController,
            readOnly: true,
            keyboardType: TextInputType.datetime,
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
              hintText: '10:30',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
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
                  onChanged: null,
                ),
                Checkbox(
                  value: injury.value,
                  onChanged: null,
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
            controller: locationController,
            readOnly: true,
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
            controller: instutionController,
            readOnly: true,
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
            controller: noteController,
            readOnly: true,
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
  //                         setState(() {});
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
}
